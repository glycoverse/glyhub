# Read the deposited author matrix, not the publisher's processed supplement.
msv000097695_site <- function(path, provenance, composition_dictionary) {
  d <- utils::read.delim(
    path,
    check.names = FALSE,
    stringsAsFactors = FALSE,
    colClasses = "character",
    quote = "\"",
    comment.char = "",
    na.strings = ""
  )
  samples <- paste0("20231124-CX-", rep(c("Cpg", "Xpg"), each = 3), "-", 1:3)
  expected <- c(
    "Protein",
    "Site",
    "Glycan(H,N,F,A,G,X,HA)",
    "Empty_Separator",
    samples,
    ""
  )
  stopifnot(identical(names(d), expected), nrow(d) > 0L)
  stopifnot(all(is.na(d[[4]])), all(is.na(d[[11]])))
  key <- do.call(paste, c(d[1:3], sep = "\t"))
  stopifnot(!anyNA(d[[1]]), !anyNA(d[[2]]), !anyDuplicated(key))
  ids <- sprintf("MSV000097695_N_site_%05d", seq_len(nrow(d)))
  abundance <- do.call(
    cbind,
    lapply(d[samples], function(x) {
      value <- suppressWarnings(as.numeric(x))
      stopifnot(!any(is.na(value) & !is.na(x)))
      value
    })
  )
  dimnames(abundance) <- list(ids, samples)
  stopifnot(
    all(is.finite(abundance) | is.na(abundance)),
    all(abundance >= 0, na.rm = TRUE)
  )
  source_composition <- d[[3]]
  tokens <- c("H", "N", "F", "A", "G", "X", "HA")
  stopifnot(
    all(names(composition_dictionary) %in% tokens),
    all(
      unname(composition_dictionary) %in% glyrepr::available_monosaccharides()
    )
  )
  counts <- lapply(source_composition, function(x) {
    stopifnot(grepl("^\\[[0-9 ]+\\]$", x))
    out <- as.integer(strsplit(trimws(substr(x, 2L, nchar(x) - 1L)), " +")[[1]])
    stopifnot(length(out) == length(tokens), !anyNA(out), all(out >= 0))
    stats::setNames(out, tokens)
  })
  compositions <- lapply(counts, function(x) {
    present <- names(x)[x != 0L]
    if (!all(present %in% names(composition_dictionary))) {
      return(glyrepr::glycan_composition(NA))
    }
    glyrepr::glycan_composition(stats::setNames(
      x[present],
      composition_dictionary[present]
    ))
  })
  single <- !grepl(";", d$Protein, fixed = TRUE) & grepl("^[0-9]+$", d$Site)
  site <- rep(NA_integer_, nrow(d))
  site[single] <- as.integer(d$Site[single])
  stopifnot(all(site > 0L, na.rm = TRUE))
  rd <- S4Vectors::DataFrame(
    protein = ifelse(single, d$Protein, NA_character_),
    protein_site = site,
    source_protein = d$Protein,
    source_site = d$Site,
    source_composition = source_composition,
    source_protein_site_group = !single,
    source_row = seq_len(nrow(d)) + 1L,
    row.names = ids
  )
  rd$glycan_composition <- do.call(c, compositions)
  rd$composition_status <- ifelse(
    is.na(rd$glycan_composition),
    "source composition retained; token mapping not independently established",
    "parsed"
  )
  cd <- S4Vectors::DataFrame(
    source_measurement = samples,
    source_measurement_column = seq.int(5L, 10L),
    species = "Schistosoma mansoni",
    taxon_id = 6183L,
    material = "whole adult worm",
    days_post_infection = 42L,
    sex = rep(c("female", "male"), each = 3),
    replicate = rep(seq_len(3L), 2),
    replicate_type = "not_reported",
    row.names = samples
  )
  glyexp::GlycoproteomicSE(
    abundance,
    rowData = rd,
    colData = cd,
    metadata = list(
      glycan_type = "N",
      doi = "10.1038/s41467-026-68400-9",
      accession = "MSV000097695",
      source = "N-pGlycoQuant.site.list; author update 2025-12-01",
      license = "MassIVE deposited dataset: CC0-1.0; not the publisher supplement license",
      article_license = "CC BY-NC-ND 4.0; separate from deposited dataset",
      attribution = "Chen et al. (2026), Tissue-specific and sex-biased glycoproteomic landscape of Schistosoma mansoni; MSV000097695",
      source_provenance = provenance,
      assay_scale = "Author pGlycoQuant site-specific glycan abundance; before subsequent protein-ratio normalization and Perseus log2/filtering/imputation",
      quant_method = "pGlycoQuant version 202407 source quantitative output",
      raw_abundance = abundance,
      source_row = seq_len(nrow(d)) + 1L,
      source_measurement_columns = seq.int(5L, 10L),
      source_annotation = d[1:3],
      source_composition_dictionary = composition_dictionary,
      processing_masks = list(
        source_missing = is.na(abundance),
        source_zero = !is.na(abundance) & abundance == 0
      ),
      feature_grain = "One deposited Protein/Site/Glycan composition row; protein/site groups are not expanded",
      processing = c(
        "All source rows and six measurement columns retained in source order",
        "Only the empty separator and empty trailing formatting column are excluded",
        "No zero conversion, filtering, imputation, normalization, inverse transformation or aggregation",
        "Ambiguous protein/site groups retained verbatim; scalar protein and protein_site remain NA",
        "No glycan topology, linkage, protein accession remapping or biological replication inferred",
        "Male/female labels follow the depositor's explicit prefix mapping; replicate independence was not reported"
      )
    )
  )
}
