# Requires source exports from build-source.R; conversion is specific to this study.
args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) == 2L)
cache <- args[2]
source("data-raw/_shared/scripts/noncptac/register-literature.R")
provenance <- jsonlite::fromJSON(
  "data-raw/PXD019914/source.json",
  simplifyVector = FALSE
)
validation <- list()
for (spec in provenance$matrices) {
  path <- file.path(args[1], spec$file)
  d <- utils::read.delim(
    gzfile(path),
    check.names = FALSE,
    stringsAsFactors = FALSE,
    na.strings = c("", "NaN"),
    quote = ""
  )
  nmeta <- spec$metadata_columns
  original <- as.matrix(d[-seq_len(nmeta)])
  stopifnot(
    is.numeric(original),
    nrow(original) == spec$feature_rows,
    ncol(original) == 129L,
    !anyDuplicated(d[[1]]),
    !anyDuplicated(colnames(original)),
    all(is.finite(original) | is.na(original))
  )
  label <- if (spec$sheet == "Intact_Normalized") "Intact" else "SPEG"
  ids <- sprintf("PXD019914_%s_%05d", label, seq_len(nrow(d)))
  rownames(original) <- ids
  a <- 2^original
  stopifnot(
    identical(is.na(a), is.na(original)),
    all(a > 0, na.rm = TRUE),
    all(a[!is.na(original) & original == 0] == 1)
  )
  rd <- S4Vectors::DataFrame(
    d[seq_len(nmeta)],
    row.names = ids,
    check.names = FALSE
  )
  rd$source_feature_id <- d[[1]]
  rd$source_gene_label <- sub("_.*$", "", d[[1]])
  rd$protein <- rep(NA_character_, nrow(d))
  rd$protein_site <- rep(NA_integer_, nrow(d))
  rd$glycan_composition <- rep(glyrepr::glycan_composition(NA), nrow(d))
  rd$source_row <- seq_len(nrow(d)) + 1L
  samples <- colnames(original)
  qc <- grepl("CONTROL", samples, fixed = TRUE)
  stopifnot(sum(qc) == 10L, sum(!qc) == 119L)
  cd <- S4Vectors::DataFrame(
    source_sample = samples,
    sample_role = ifelse(qc, "quality_control", "tumor"),
    species = "Homo sapiens",
    tissue = "ovarian tumor study",
    source_cohort = "TCGA; iTRAQ",
    row.names = samples
  )
  x <- glyexp::GlycoproteomicSE(
    a,
    rowData = rd,
    colData = cd,
    metadata = list(
      accession = "PXD019914",
      doi = provenance$doi,
      glycan_type = "N",
      source = paste("MOESM4.xlsx", spec$sheet),
      source_provenance = provenance,
      license = "CC BY 4.0 original-author supplementary measurements",
      license_url = "https://creativecommons.org/licenses/by/4.0/",
      source_scale = "author-normalized log2 relative ratio",
      assay_scale = "linear relative ratio (2^author-normalized log2 ratio), not raw intensity",
      assay_transformation = "2^source_log2_normalized_ratio",
      feature_grain = if (label == "Intact") {
        "author intact glycopeptide ID"
      } else {
        "author SPEG deglycopeptide ID; not intact glycoform"
      },
      raw_abundance = original,
      source_annotation = d[seq_len(nmeta)],
      source_row = rd$source_row,
      source_measurement_columns = nmeta + seq_len(129L),
      processing_masks = list(
        source_missing = is.na(original),
        source_zero = !is.na(original) & original == 0,
        source_negative = !is.na(original) & original < 0
      ),
      processing = c(
        "Exponentiate each finite source log2 ratio with base 2; source zero becomes one",
        "Keep source NA unchanged; retain all 119 tumor and 10 quality-control columns",
        "No new normalization, imputation, filtering or reassignment of missingness",
        "Complete original log2 matrix and source asset remain available; values are relative ratios, not intensity",
        "Source gene/peptide/glycan text retained; unverified UniProt/site/composition mappings are not inferred"
      )
    )
  )
  # Independently reread source text, rather than comparing only a stored intermediate.
  reread <- utils::read.delim(
    gzfile(path),
    check.names = FALSE,
    na.strings = c("", "NaN"),
    quote = ""
  )
  source_values <- as.matrix(reread[-seq_len(nmeta)])
  stopifnot(
    identical(
      as.numeric(2^source_values),
      as.numeric(SummarizedExperiment::assay(x))
    ),
    identical(
      as.numeric(source_values),
      as.numeric(S4Vectors::metadata(x)$raw_abundance)
    ),
    methods::validObject(x)
  )
  name <- paste0("glyhub_PXD019914_N_", label, "_RelativeRatios")
  register_literature(
    x,
    name,
    paste("TCGA ovarian", label, "linear relative ratios"),
    c(
      "Complete author matrix with 119 tumor and 10 QC columns; QC is not an independent patient.",
      "This study-specific 2^x conversion retains the full original normalized log2 matrix.",
      "It does not restore raw intensity or reverse the author's normalization.",
      "Distinct from the existing prospective CPTAC TMT HGSC source; no donor alias crosswalk is assumed."
    )
  )
  validation[[name]] <- list(
    dimensions = dim(x),
    source_cells_compared = length(original),
    source_file_sha256 = digest::digest(file = path, algo = "sha256"),
    original_log2_values_exact = TRUE,
    exponentiated_values_exact = TRUE,
    source_missing = sum(is.na(original)),
    source_zero = sum(original == 0, na.rm = TRUE),
    zero_becomes_one = TRUE,
    valid_object = TRUE
  )
}
jsonlite::write_json(
  validation,
  "data-raw/PXD019914/validation.json",
  pretty = TRUE,
  auto_unbox = TRUE
)
