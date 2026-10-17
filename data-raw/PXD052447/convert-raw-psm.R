# Preserve deposited PSM rows and reporter channels without aggregation.
noncptac_raw_psm <- function(
  path,
  sample_annotation,
  accession,
  experiment,
  provenance,
  spectrum_pattern = NULL
) {
  d <- utils::read.delim(
    path,
    check.names = FALSE,
    stringsAsFactors = FALSE,
    quote = "",
    comment.char = "",
    na.strings = "",
    colClasses = "character"
  )
  source_rows <- seq_len(nrow(d)) + 1L
  if (!is.null(spectrum_pattern)) {
    keep <- grepl(spectrum_pattern, d$Spectrum, fixed = TRUE)
    stopifnot(any(keep))
    d <- d[keep, , drop = FALSE]
    source_rows <- source_rows[keep]
  }
  measurement <- grep("^sample-?[0-9]{2}$", names(d))
  stopifnot(length(measurement) == 18L)
  txt <- as.matrix(d[measurement])
  a <- matrix(suppressWarnings(as.numeric(txt)), nrow(txt), ncol(txt))
  stopifnot(
    identical(is.na(a), unname(is.na(txt))),
    all(is.finite(a) | is.na(a)),
    all(a >= 0, na.rm = TRUE)
  )
  ids <- sprintf("%s_%s_PSM_%07d", accession, experiment, seq_len(nrow(d)))
  dimnames(a) <- list(ids, names(d)[measurement])
  composition <- sub(" % .*", "", d[["Observed Modifications"]])
  supported <- !is.na(composition) &
    grepl("^([A-Za-z]+\\([0-9]+\\))+$", composition)
  gc <- rep(glyrepr::glycan_composition(NA), nrow(d))
  gc[supported] <- noncptac_compositions(composition[supported])
  rd <- S4Vectors::DataFrame(
    protein = d[["Protein ID"]],
    peptide = d$Peptide,
    protein_site = rep(NA_integer_, nrow(d)),
    source_composition = composition,
    source_glycan_annotation_present = !is.na(composition),
    row.names = ids
  )
  rd$glycan_composition <- gc
  # All original non-measurement fields remain losslessly available as text.
  rd$source_annotation <- S4Vectors::DataFrame(
    d[-measurement],
    check.names = FALSE
  )
  stopifnot(all(grepl("^sample-?[0-9]{2}$", sample_annotation$source_sample)))
  sample_annotation$source_annotation_label <- sample_annotation$source_sample
  si <- match(
    gsub("-", "", colnames(a), fixed = TRUE),
    gsub("-", "", sample_annotation$source_sample, fixed = TRUE)
  )
  cd <- sample_annotation[si, , drop = FALSE]
  cd$source_sample <- colnames(a)
  cd$sample_annotation_matched <- !is.na(si)
  rownames(cd) <- colnames(a)
  glyexp::GlycoproteomicSE(
    a,
    rowData = rd,
    colData = S4Vectors::DataFrame(cd),
    metadata = list(
      glycan_type = "N",
      accession = accession,
      experiment = experiment,
      doi = "10.1038/s41594-025-01485-w",
      source = basename(path),
      source_provenance = provenance,
      assay_scale = "Deposited untransformed PSM-level TMT reporter intensities",
      raw_abundance = a,
      raw_abundance_scale = "source reporter intensity",
      feature_grain = "PSM; all deposited rows retained, including rows without glycan annotation",
      source_row = source_rows,
      source_measurement_columns = measurement,
      source_sample_annotation = sample_annotation,
      source_selection = "Deposited reporter intensities preferred over normalized supplementary glycopeptide matrices or ratios",
      processing = c(
        "No normalization, logarithm, imputation, confidence filtering, aggregation or zero conversion; acquisition partitions use explicit source Spectrum prefixes",
        "Source blanks are NA; numeric zero retained with no interpretation of its missingness semantics",
        "All 18 deposited reporter channels retained; unmatched channel roles remain unknown",
        "PSM counts are not counts of unique glycopeptides; no peptide-level aggregation performed",
        "Protein sites are not inferred from peptide coordinates; original search annotations are retained",
        "Source search/FDR and reporter extraction precede this deposit; any undocumented upstream correction remains unknown"
      ),
      processing_masks = list(
        source_missing = is.na(a),
        source_zero = !is.na(a) & a == 0
      ),
      license = "Repository file redistribution terms require confirmation before publication; local staging only"
    )
  )
}
