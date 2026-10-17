# Full image-table transcription: Supplementary Tables 9 and 10, PDF pages S46/S47.
suppressPackageStartupMessages({
  library(glyexp)
  library(glyrepr)
  library(S4Vectors)
  library(SummarizedExperiment)
})
specs <- jsonlite::fromJSON(
  'data-raw/GPST000297/matrix-specs.json',
  simplifyVector = FALSE
)
validation <- list()
for (s in specs) {
  sha <- digest::digest(
    file = s$source_file,
    algo = 'sha256',
    serialize = FALSE
  )
  stopifnot(identical(sha, s$source_sha256))
  raw <- do.call(
    rbind,
    lapply(s$raw_matrix, function(r) {
      vapply(r, function(z) if (is.null(z)) NA_real_ else z, numeric(1))
    })
  )
  dimnames(raw) <- list(unlist(s$feature_ids), unlist(s$sample_ids))
  for (rec in s$records) {
    stopifnot(raw[rec$feature_id, rec$sample] == rec$relative_percentage)
  }
  abundance <- raw
  zero <- !is.na(raw) & raw == 0
  abundance[zero] <- NA_real_
  rd <- DataFrame(
    row.names = rownames(raw),
    source_feature_id = rownames(raw),
    source_composition = vapply(
      s$row_annotations,
      `[[`,
      '',
      'source_composition'
    ),
    source_mz = vapply(s$row_annotations, `[[`, 0, 'source_mz')
  )
  rd$glycan_composition <- do.call(
    base::c,
    lapply(s$row_annotations, function(a) {
      if (is.null(a$composition_counts)) {
        glycan_composition(NA)
      } else {
        glycan_composition(unlist(a$composition_counts))
      }
    })
  )
  structures <- vapply(
    s$row_annotations,
    function(a) {
      if (is.null(a$structure_iupac)) NA_character_ else a$structure_iupac
    },
    character(1)
  )
  if (any(!is.na(structures))) {
    rd$glycan_structure <- as_glycan_structure(structures)
  }
  # Validate residue/substituent totals for every transcribed structure.
  for (i in which(!is.na(structures))) {
    got <- as.list(as_glycan_composition(rd$glycan_structure[i]))[[1]]
    want <- unlist(s$row_annotations[[i]]$composition_counts)
    stopifnot(
      identical(sort(names(got)), sort(names(want))),
      all(got[names(want)] == want)
    )
  }
  rd$source_annotations <- I(s$row_annotations)
  cd <- DataFrame(
    row.names = colnames(raw),
    organism = rep('Cornu aspersum', 3),
    sample_type = tolower(colnames(raw)),
    biospecimen = rep('snail mucus', 3),
    reported_profiles = rep(1L, 3)
  )
  idx <- expand.grid(
    feature_index = seq_len(nrow(raw)),
    sample_index = seq_len(ncol(raw))
  )
  idx$feature_id <- rownames(raw)[idx$feature_index]
  idx$observation_id <- colnames(raw)[idx$sample_index]
  idx$original_value <- as.vector(raw)
  idx$curated_value <- as.vector(abundance)
  idx$reason <- ifelse(
    is.na(idx$original_value),
    'not_reported_in_source_table',
    ifelse(as.vector(zero), 'zero_abundance', 'unchanged')
  )
  md <- list(
    glycan_type = s$glycan_type,
    accession = s$accession,
    doi = s$doi,
    unit = s$unit,
    source = list(
      file = s$source_file,
      sha256 = s$source_sha256,
      page = s$page,
      table = s$table,
      url = 'https://doi.org/10.1038/s41467-023-41094-z'
    ),
    license = list(
      name = 'Published article supplementary material',
      url = 'https://doi.org/10.1038/s41467-023-41094-z'
    ),
    raw_abundance = raw,
    source_coverage = !is.na(raw),
    source_records = s$records,
    processing_ledger = idx,
    processing_masks = list(zero_to_na = zero, not_reported = is.na(raw)),
    processing_counts = c(
      zero_to_na = sum(zero),
      not_reported = sum(is.na(raw))
    ),
    zero_to_na = TRUE,
    zero_handling = 'Quantitative zeros become NA; unreported source-table combinations are missing. Original values preserved. No imputation or percentage renormalization.',
    reported_column_sums = colSums(raw, na.rm = TRUE),
    quality_notes = s$notes,
    molecular_annotation = 'Composition labels were transcribed verbatim and repeated residue tokens summed. Two N-glycan source composition/diagram conflicts have missing typed molecular annotations; original source evidence is preserved. Native methyl substituents remain explicit Me components. Only independently reviewed diagram topologies are encoded; unspecified linkages stay unknown. Distinct source masses and proposed isomers are retained as separate rows.',
    transcription = 'Complete Table 9 and Table 10 image rows manually transcribed from rendered PDF and independently compared against OCR; source PDF checksum pinned.',
    reviewed_mapping = s,
    software = list(
      glyexp = as.character(packageVersion('glyexp')),
      glyrepr = as.character(packageVersion('glyrepr'))
    )
  )
  obj <- GlycomicSE(abundance, rowData = rd, colData = cd, metadata = md)
  stopifnot(validObject(obj), !any(assay(obj) == 0, na.rm = TRUE))
  assign(s$name, obj)
  save(
    list = s$name,
    file = file.path(
      'data-raw/_shared/artifacts/bundled-build',
      paste0(s$name, '.rda')
    ),
    compress = 'xz',
    version = 3
  )
  validation[[s$name]] <- list(
    features = nrow(obj),
    samples = ncol(obj),
    source_rows = length(s$records),
    reported = sum(!is.na(raw)),
    missing = sum(is.na(raw)),
    structures = sum(!is.na(structures)),
    column_sums = colSums(raw, na.rm = TRUE),
    valid = TRUE
  )
}
jsonlite::write_json(
  validation,
  'data-raw/GPST000297/validation.json',
  pretty = TRUE,
  auto_unbox = TRUE
)
print(validation)
