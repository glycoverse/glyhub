# Supplemental tables are processed outputs, not native glyread input files.
# This adapter uses the same glyexp rowData contract without fabricating PSMs.
noncptac_compositions <- function(labels) {
  unique_labels <- unique(labels)
  parsed <- lapply(unique_labels, function(label) {
    if (is.na(label) || !grepl("^([A-Za-z]+\\([0-9]+\\))+$", label)) {
      stop("Unexpected source composition syntax.")
    }
    tokens <- regmatches(label, gregexpr("[A-Za-z]+\\([0-9]+\\)", label))[[1]]
    monos <- sub("\\(.*", "", tokens)
    if (!all(monos %in% glyrepr::available_monosaccharides())) {
      return(glyrepr::glycan_composition(NA))
    }
    counts <- as.integer(sub(".*\\(([0-9]+)\\)", "\\1", tokens))
    names(counts) <- monos
    glyrepr::glycan_composition(counts)
  })
  do.call(c, parsed)[match(labels, unique_labels)]
}

noncptac_dqglyco <- function(path, provenance) {
  sheets <- c("N-glyco_liver", "N-glyco_kidney", "N-glyco_brain")
  annotations <- c(
    "Protein.ID",
    "Gene",
    "n_position",
    "Modified.Peptide",
    "glycan_type",
    "Observed.Modifications",
    "Hyperscore"
  )
  key <- function(x) do.call(paste, c(x[annotations], sep = "\t"))
  matrices <- source_rows <- sample_tables <- list()
  reference <- reference_key <- NULL
  for (sheet in sheets) {
    d <- as.data.frame(readxl::read_excel(path, sheet = sheet))
    stopifnot(identical(
      names(d),
      c(
        "tissue",
        "mouse",
        "group",
        annotations,
        "quant_abundance_corrected"
      )
    ))
    stopifnot(
      !anyNA(d$n_position),
      all(d$n_position == as.integer(d$n_position)),
      all(d$n_position > 0)
    )
    samples <- unique(d$group)
    if (is.null(reference)) {
      reference <- d[d$group == samples[1], annotations]
      reference_key <- key(reference)
      stopifnot(!anyDuplicated(reference_key))
    }
    mat <- rows <- matrix(NA_real_, nrow(reference), length(samples))
    for (i in seq_along(samples)) {
      idx <- which(d$group == samples[i])
      keys <- key(d[idx, ])
      stopifnot(!anyDuplicated(keys), setequal(keys, reference_key))
      idx <- idx[match(reference_key, keys)]
      mat[, i] <- d$quant_abundance_corrected[idx]
      rows[, i] <- idx + 1L
    }
    colnames(mat) <- colnames(rows) <- samples
    matrices[[sheet]] <- mat
    source_rows[[sheet]] <- rows
    cd <- unique(d[c("group", "tissue", "mouse")])
    stopifnot(nrow(cd) == length(samples), identical(cd$group, samples))
    cd$replicate <- as.integer(sub(".*_rep", "", cd$group))
    cd$replicate_type <- "technical; three measurements per mouse tissue"
    cd$sex <- "male"
    cd$species <- "Mus musculus"
    cd$source_sheet <- sheet
    sample_tables[[sheet]] <- cd
  }
  abundance <- do.call(cbind, matrices)
  source_row <- do.call(cbind, source_rows)
  ids <- sprintf("DQGlyco_tissue_%05d", seq_len(nrow(reference)))
  dimnames(abundance) <- dimnames(source_row) <- list(ids, colnames(abundance))
  stopifnot(
    all(is.finite(abundance) | is.na(abundance)),
    all(abundance >= 0, na.rm = TRUE)
  )
  composition <- sub(" % .*", "", reference$Observed.Modifications)
  rd <- S4Vectors::DataFrame(
    protein = reference$Protein.ID,
    protein_site = as.integer(reference$n_position),
    source_gene = reference$Gene,
    source_modified_peptide = reference$Modified.Peptide,
    source_glycan_class = reference$glycan_type,
    source_modification = reference$Observed.Modifications,
    source_composition = composition,
    source_hyperscore = reference$Hyperscore,
    row.names = ids
  )
  rd$glycan_composition <- noncptac_compositions(composition)
  rd$composition_status <- ifelse(
    is.na(rd$glycan_composition),
    "unsupported substituent; complete source composition retained",
    "parsed"
  )
  # Source score is part of the published row identity. Do not collapse rows
  # whose peptide notation became identical during the authors' export.
  molecular_key <- paste(
    rd$protein,
    rd$protein_site,
    rd$source_modified_peptide,
    rd$source_composition
  )
  rd$repeated_molecular_annotation <- duplicated(molecular_key) |
    duplicated(molecular_key, fromLast = TRUE)
  cd <- do.call(rbind, sample_tables)
  rownames(cd) <- cd$group
  glyexp::GlycoproteomicSE(
    abundance,
    rowData = rd,
    colData = S4Vectors::DataFrame(cd),
    metadata = list(
      glycan_type = "N",
      doi = "10.1038/s41594-025-01485-w",
      accession = "PXD052447",
      source = "Supplementary Data 5, N-glyco_liver/kidney/brain",
      license = "Supplementary workbook: no independent license statement located; local staging only",
      article_license = "CC BY 4.0",
      attachment_license_status = "Article licensing statement verified; applicability to redistributed adapted workbook asset not independently confirmed",
      license_url = "https://creativecommons.org/licenses/by/4.0/",
      attribution = "Potel et al. (2025), Nature Structural & Molecular Biology; DQGlyco",
      source_provenance = provenance,
      assay_scale = "protein-abundance-corrected TMT intensity after limma::normalizeVSN; source scale",
      raw_abundance_scale = "VSN transformed",
      raw_abundance = abundance,
      source_row = source_row,
      source_measurement_column = 11L,
      processing_masks = list(
        source_missing = is.na(abundance),
        source_zero = !is.na(abundance) & abundance == 0
      ),
      processing = c(
        "Long table pivoted with complete seven-column source annotation key; no aggregation",
        "No filtering, imputation, zero conversion, normalization or exponentiation",
        "VSN is not exactly log2: do not use 2^value to recover linear intensities",
        "Duplicate molecular labels with different source Hyperscores retained as distinct source features",
        "Unsupported Phospho composition retained verbatim; typed composition is NA for these rows",
        "Source glycosylation sites retained without independent sequence remapping; structures not inferred",
        "18 technical measurement columns represent 3 tissues from 2 mice, not 18 animals"
      )
    )
  )
}
