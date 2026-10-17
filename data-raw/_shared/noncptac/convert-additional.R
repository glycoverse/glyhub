# These adapters preserve source values; no imputation or inverse transforms.
noncptac_lung <- function(path, provenance) {
  d <- as.data.frame(readxl::read_excel(path, sheet = "glycoproteomics"))
  sample_columns <- which(grepl("^[NT]_(AIS|MIA|IA)_[0-9]+$", names(d)))
  stopifnot(length(sample_columns) == 132L, identical(sample_columns, 7:138))
  a <- as.matrix(d[sample_columns])
  stopifnot(is.numeric(a), all(a >= 0, na.rm = TRUE))
  ids <- sprintf("PXD046637_%05d", seq_len(nrow(d)))
  rownames(a) <- ids
  rd <- S4Vectors::DataFrame(
    protein = d[[1]],
    protein_site = rep(NA_integer_, nrow(d)),
    source_position = as.integer(d[[2]]),
    source_amino_acid = d[[3]],
    source_protein_description = d[[4]],
    source_gene = d[[5]],
    source_composition = d[[6]],
    row.names = ids
  )
  stopifnot(all(d[[2]] == as.integer(d[[2]])), all(d[[3]] == "N"))
  rd$glycan_composition <- noncptac_compositions(rd$source_composition)
  samples <- colnames(a)
  cd <- S4Vectors::DataFrame(
    source_sample = samples,
    tissue = ifelse(startsWith(samples, "N_"), "adjacent non-tumor", "tumor"),
    histology_source = sub("^[NT]_([^_]+)_.*", "\\1", samples),
    pair_id = sub("^[NT]_", "", samples),
    species = "Homo sapiens",
    row.names = samples
  )
  stopifnot(all(table(cd$pair_id) == 2L))
  glyexp::GlycoproteomicSE(
    a,
    rowData = rd,
    colData = cd,
    metadata = list(
      glycan_type = "N",
      doi = "10.1038/s41467-025-57364-x",
      accession = "PXD046637",
      source = "Su et al. (2025), Supplementary Data 2, glycoproteomics",
      source_provenance = provenance,
      license = "Attachment applicability not independently confirmed; local staging only",
      article_license = "CC BY-NC-ND 4.0",
      assay_scale = "Source protein-abundance-corrected relative TMT glycopeptide abundance; dimensionless",
      raw_abundance = a,
      raw_abundance_scale = "source relative abundance",
      source_row = seq_len(nrow(d)) + 1L,
      source_measurement_columns = sample_columns,
      source_summary_statistics = d[-c(1:6, sample_columns)],
      processing_masks = list(
        source_missing = is.na(a),
        source_zero = !is.na(a) & a == 0
      ),
      processing = c(
        "Source numeric values and blank cells preserved; blanks -> NA; no zero conversion or imputation",
        "Source Position retained separately; coordinate frame unresolved, canonical protein_site is NA",
        "132 measurements represent 66 paired tissue specimens sets; pair labels retain histology prefix",
        "No raw intensity reconstruction; no log/exponentiation or protein correction repeated",
        "Summary ratios and statistical columns retained as annotations, never as samples"
      )
    )
  )
}

noncptac_atlas <- function(path, metadata_path, provenance) {
  d <- as.data.frame(readxl::read_excel(
    path,
    sheet = "Raw expression matrix",
    col_types = "text"
  ))
  annotation <- as.data.frame(readxl::read_excel(
    path,
    sheet = "57884Glycopeptides"
  ))
  raw_text <- as.matrix(d[-1])
  missing <- is.na(raw_text) | raw_text == "NA" | raw_text == ""
  a <- matrix(
    suppressWarnings(as.numeric(raw_text)),
    nrow(raw_text),
    ncol(raw_text)
  )
  stopifnot(
    all(is.na(a) == missing),
    all(is.finite(a) | missing),
    all(a >= 0, na.rm = TRUE)
  )
  stopifnot(!anyDuplicated(d$ID), !anyDuplicated(annotation$ID))
  ids <- sprintf("PXD070547_%05d", seq_len(nrow(d)))
  dimnames(a) <- dimnames(raw_text) <- list(ids, names(d)[-1])
  dimnames(missing) <- dimnames(a)
  idx <- match(d$ID, annotation$ID)
  ann <- annotation[idx, ]
  rd <- S4Vectors::DataFrame(
    source_id = d$ID,
    protein = ann[[2]],
    peptide = ann[[3]],
    protein_site = as.integer(ann[[4]]),
    source_composition = ann[[5]],
    source_linkage = ann[[6]],
    annotation_match = !is.na(idx),
    source_annotation_row = idx + 1L,
    row.names = ids
  )
  # The workbook defines S only as "Sialic acid". Do not silently call it Neu5Ac.
  labels <- rd$source_composition
  supported <- !is.na(labels) & grepl("^N[0-9]+H[0-9]+F[0-9]+S0$", labels)
  unique_labels <- unique(labels[supported])
  compositions <- lapply(unique_labels, function(s) {
    v <- as.integer(strsplit(sub("^N", "", s), "[HFS]")[[1]])
    names(v) <- c("HexNAc", "Hex", "Fuc", "S")
    glyrepr::glycan_composition(v[seq_len(3)][v[seq_len(3)] > 0])
  })
  rd$glycan_composition <- rep(glyrepr::glycan_composition(NA), nrow(rd))
  rd$glycan_composition[supported] <- do.call(c, compositions)[match(
    labels[supported],
    unique_labels
  )]
  rd$composition_status <- ifelse(
    !rd$annotation_match,
    "unmatched source ID",
    ifelse(
      supported,
      "parsed",
      "S is unspecified sialic acid; complete source label retained"
    )
  )
  samples <- colnames(a)
  specimen <- sub("-[0-9]+$", "", samples)
  subjects <- as.data.frame(readxl::read_excel(
    metadata_path,
    sheet = "Human_subjects"
  ))
  subject_key <- gsub(" ", "", subjects$Organ_No, fixed = TRUE)
  stopifnot(!anyDuplicated(subject_key))
  si <- match(specimen, subject_key)
  stopifnot(!anyNA(si))
  cd <- S4Vectors::DataFrame(
    source_sample = samples,
    specimen_id = specimen,
    organ = sub("[0-9]+$", "", specimen),
    technical_replicate = as.integer(sub(".*-", "", samples)),
    source_organ_no = subjects$Organ_No[si],
    source_subject_number = subjects$Number[si],
    source_batch = subjects$Batch[si],
    sex = rep(NA_character_, length(samples)),
    age = rep(NA_real_, length(samples)),
    row.names = samples
  )
  glyexp::GlycoproteomicSE(
    a,
    rowData = rd,
    colData = cd,
    metadata = list(
      glycan_type = "N",
      doi = "10.1038/s41467-026-74631-7",
      accession = "PXD070547",
      source = "Hu et al. (2026), Supplementary Data 2, Raw expression matrix",
      source_provenance = provenance,
      license = "Attachment applicability not independently confirmed; local staging only",
      article_license = "CC BY-NC-ND 4.0",
      assay_scale = "Source Skyline extracted-ion chromatogram quantification; raw relative signal",
      raw_abundance_scale = "raw XIC signal",
      raw_abundance = a,
      source_row = seq_len(nrow(d)) + 1L,
      source_measurement_columns = seq_len(ncol(a)) + 1L,
      source_subject_table = subjects,
      unmatched_source_ids = d$ID[is.na(idx)],
      processing_masks = list(
        source_missing = missing,
        source_zero = !missing & a == 0
      ),
      processing = c(
        "Explicit source NA strings and blanks -> NA; no imputation, normalization, filtering, zero conversion or aggregation",
        "Annotation joined only by exact ID: unmatched source rows retained with unknown molecular annotation",
        "Source linkage notation retained, no unverified structure parser or inferred linkage",
        "S monosaccharide is unspecified sialic acid; sialylated typed compositions remain NA",
        "Source age/sex cells are cohort summaries, not person-level values; not propagated to samples",
        "Use original measured columns, not the normalized or KNN/ComBat matrices"
      )
    )
  )
}

noncptac_glycodia <- function(path, provenance) {
  d <- as.data.frame(readxl::read_excel(
    path,
    sheet = "SerialDilution_ID_Quant",
    skip = 1
  ))
  label <- d[[1]]
  stopifnot(
    all(grepl("^\\([1-3]G\\):\\([1-3]xT\\):[A-Z]+$", label)),
    !anyDuplicated(label)
  )
  count <- as.integer(sub("^\\(([1-3])G\\).*", "\\1", label))
  stopifnot(all(
    count == as.integer(sub("^.*\\(([1-3])xT\\):.*", "\\1", label))
  ))
  a <- as.matrix(d[-1])
  stopifnot(is.numeric(a), all(a >= 0, na.rm = TRUE))
  ids <- sprintf("PXD011063_%04d", seq_len(nrow(d)))
  rownames(a) <- ids
  rd <- S4Vectors::DataFrame(
    protein = rep(NA_character_, nrow(d)),
    protein_site = rep(NA_integer_, nrow(d)),
    peptide = sub(".*:", "", label),
    source_glycopeptide = label,
    source_T_count = count,
    row.names = ids
  )
  rd$glycan_composition <- do.call(
    c,
    lapply(count, function(n) {
      glyrepr::glycan_composition(c(Hex = n, HexNAc = n))
    })
  )
  samples <- colnames(a)
  cd <- S4Vectors::DataFrame(
    source_sample = samples,
    library_analysis = ifelse(startsWith(samples, "SSL_"), "SSL", "HepG2_WT"),
    dilution_denominator = as.integer(sub(".*1to([0-9]+).*", "\\1", samples)),
    run_replicate = ifelse(grepl("_r2$", samples), 2L, 1L),
    row.names = samples
  )
  glyexp::GlycoproteomicSE(
    a,
    rowData = rd,
    colData = cd,
    metadata = list(
      glycan_type = "O",
      doi = "10.1038/s41592-019-0504-x",
      accession = "PXD011063",
      source = "Ye et al. (2019), Source Data Fig. 2, SerialDilution_ID_Quant",
      source_provenance = provenance,
      license = "Attachment redistribution terms not confirmed; local staging only",
      assay_scale = "Source reported glycopeptide quantities in serial-dilution experiment; no rescaling",
      raw_abundance = a,
      source_row = seq_len(nrow(d)) + 2L,
      source_measurement_columns = 2:11,
      processing_masks = list(
        source_missing = is.na(a),
        source_zero = !is.na(a) & a == 0
      ),
      processing = c(
        "Numeric values and blanks preserved; no imputation, normalization or zero conversion",
        "Library-analysis columns are alternative quantification outputs for the same dilution design, not ten biological samples",
        "T is Hex(1)HexNAc(1), supported by the author library code; total composition summed over attached T groups",
        "No protein accession or individual O-glycosite is supplied in this table; both remain NA",
        "No glycan structure or linkage inferred from aggregate composition"
      )
    )
  )
}

noncptac_solubility <- function(path, provenance) {
  d <- as.data.frame(readxl::read_excel(path, sheet = "solubility_ratios"))
  anncols <- c(
    "Protein.ID",
    "Modified.Peptide",
    "Observed.Modifications",
    "Hyperscore"
  )
  key <- function(x) do.call(paste, c(x[anncols], sep = "\t"))
  annotation <- d[d$group == "rep1_glyco", anncols]
  keys <- key(annotation)
  stopifnot(!anyDuplicated(keys))
  groups <- c(paste0("rep", 1:4, "_glyco"), paste0("rep", 1:4, "_FP"))
  a <- rows <- matrix(
    NA_real_,
    length(keys),
    length(groups),
    dimnames = list(NULL, groups)
  )
  for (j in seq_along(groups)) {
    idx <- which(d$group == groups[j])
    dk <- key(d[idx, ])
    stopifnot(!anyDuplicated(dk), setequal(dk, keys))
    idx <- idx[match(keys, dk)]
    a[, j] <- d$ratio[idx]
    rows[, j] <- idx + 1L
  }
  ids <- sprintf("DQGlyco_solubility_%05d", seq_len(nrow(a)))
  rownames(a) <- rownames(rows) <- ids
  stopifnot(all(a > 0, na.rm = TRUE))
  composition <- sub(" % .*", "", annotation$Observed.Modifications)
  rd <- S4Vectors::DataFrame(
    protein = annotation$Protein.ID,
    protein_site = rep(NA_integer_, nrow(annotation)),
    source_modified_peptide = annotation$Modified.Peptide,
    source_modification = annotation$Observed.Modifications,
    source_composition = composition,
    source_hyperscore = annotation$Hyperscore,
    row.names = ids
  )
  rd$glycan_composition <- noncptac_compositions(composition)
  cd <- S4Vectors::DataFrame(
    source_sample = groups[1:4],
    source_replicate = 1:4,
    tissue = "mouse brain",
    numerator = "NP40 lysis",
    denominator = "SDS lysis",
    replicate_type = "source replicate; biological independence not established from workbook",
    row.names = groups[1:4]
  )
  glyexp::GlycoproteomicSE(
    a[, 1:4],
    rowData = rd,
    colData = cd,
    metadata = list(
      glycan_type = "N",
      doi = "10.1038/s41594-025-01485-w",
      accession = "PXD052447",
      source = "Potel et al. (2025), Supplementary Data 6, solubility_ratios",
      source_provenance = provenance,
      license = "Attachment applicability not independently confirmed; local staging only",
      article_license = "CC BY 4.0",
      assay_scale = "Dimensionless NP40/SDS ratio of summed raw glycopeptide intensities; not log2",
      raw_abundance = a[, 1:4],
      raw_abundance_scale = "linear ratio",
      source_row = rows[, 1:4],
      source_measurement_column = 6L,
      protein_solubility_reference = a[, 5:8],
      source_protein_reference_rows = rows[, 5:8],
      processing_masks = list(
        source_missing = is.na(a[, 1:4]),
        source_zero = !is.na(a[, 1:4]) & a[, 1:4] == 0
      ),
      processing = c(
        "Source glyco ratios pivoted without normalization, imputation, aggregation or exponentiation",
        "Four FP columns are mapped whole-protein comparators, retained in metadata rather than treated as glycopeptide measurements",
        "Author code computes ratios from quant (raw intensity), before later log2 and median normalization",
        "Source Hyperscore retained as part of row key; no collapse of repeated molecular annotations",
        "No protein sites supplied in this sheet; canonical sites remain NA",
        "Unsupported substituent compositions retain full source text and typed NA"
      )
    )
  )
}
