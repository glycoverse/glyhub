# Rebuild source-faithful Brugia malayi N- and GSL-glycan peak-area matrices.
# Run from the package root. Missing assigned features remain NA; no zero fill.
suppressPackageStartupMessages({
  library(glyexp)
  library(glyrepr)
  library(S4Vectors)
  library(SummarizedExperiment)
})
specs <- jsonlite::fromJSON(
  'data-raw/GPST000240/matrix-specs.json',
  simplifyVector = FALSE
)
num_matrix <- function(x) {
  do.call(
    rbind,
    lapply(x, function(r) {
      vapply(
        r,
        function(z) if (is.null(z)) NA_real_ else as.numeric(z),
        numeric(1)
      )
    })
  )
}
validation <- list()
for (s in specs) {
  sha <- digest::digest(
    file = s$source_file,
    algo = 'sha256',
    serialize = FALSE
  )
  stopifnot(identical(sha, s$source_sha256))
  annotation_sheet <- if (s$glycan_type == 'N') {
    'A - N-glycans'
  } else {
    'A - GSL-glycans'
  }
  annotations <- readxl::read_xlsx(
    s$source_file,
    sheet = annotation_sheet,
    range = 'A1:C80',
    col_names = FALSE,
    col_types = 'text',
    .name_repair = 'minimal'
  )
  for (a in s$row_annotations) {
    stopifnot(
      annotations[[1]][a$annotation_sheet_row] == a$feature_id,
      annotations[[3]][a$annotation_sheet_row] == a$source_composition
    )
  }
  raw <- num_matrix(s$raw_matrix)
  dimnames(raw) <- list(unlist(s$feature_ids), unlist(s$sample_ids))
  coverage <- num_matrix(s$coverage) != 0
  dimnames(coverage) <- dimnames(raw)
  tab <- readxl::read_xlsx(
    s$source_file,
    sheet = s$sheet,
    range = 'A1:AB400',
    col_names = FALSE,
    col_types = 'text',
    .name_repair = 'minimal'
  )
  for (rec in s$source_records) {
    addr <- rec$area_cell
    r <- as.integer(sub('^[A-Z]+', '', addr))
    letters <- utf8ToInt(sub('[0-9]+$', '', addr)) - utf8ToInt('A') + 1L
    c <- Reduce(function(x, y) x * 26 + y, letters, init = 0L)
    stopifnot(
      as.numeric(trimws(tab[[c]][r])) == rec$peak_area,
      trimws(tab[[c + 1]][r]) == rec$feature_id,
      raw[rec$feature_id, rec$sample_id] == rec$peak_area
    )
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
    )
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
  rd$source_annotations <- I(s$row_annotations)
  ids <- colnames(raw)
  groups <- sub('_[0-2]$', '', ids)
  cd <- DataFrame(
    row.names = ids,
    organism = rep('Brugia malayi', length(ids)),
    life_stage = ifelse(
      grepl('Adult', ids),
      'adult',
      ifelse(grepl('Microfilariae', ids), 'microfilariae', 'L3 larva')
    ),
    sex = ifelse(
      grepl('Mixed', ids),
      'mixed',
      ifelse(
        grepl('Female', ids),
        'female',
        ifelse(grepl('Male', ids), 'male', NA_character_)
      )
    ),
    sample_group = groups,
    source_replicate = ifelse(
      grepl('_[0-2]$', ids),
      suppressWarnings(as.integer(sub('.*_', '', ids))),
      NA_integer_
    )
  )
  idx <- expand.grid(
    feature_index = seq_len(nrow(raw)),
    sample_index = seq_len(ncol(raw))
  )
  idx$feature_id <- rownames(raw)[idx$feature_index]
  idx$sample_id <- colnames(raw)[idx$sample_index]
  idx$original_value <- as.vector(raw)
  idx$curated_value <- as.vector(abundance)
  idx$reason <- ifelse(
    !as.vector(coverage),
    'not_assigned_in_source_spectrum',
    ifelse(as.vector(zero), 'zero_abundance', 'unchanged')
  )
  md <- list(
    glycan_type = s$glycan_type,
    accession = s$accession,
    doi = s$doi,
    unit = s$unit,
    title = paste('Brugia malayi', s$glycan_type, 'glycans across life stages'),
    source = list(
      file = s$source_file,
      sha256 = s$source_sha256,
      url = s$source_url,
      sheet = s$sheet
    ),
    license = list(
      name = 'CC BY article and accompanying supplementary tables',
      url = 'https://creativecommons.org/licenses/by/4.0/'
    ),
    raw_abundance = raw,
    source_coverage = coverage,
    source_table = tab,
    source_records = s$source_records,
    source_annotations = s$source_annotation,
    source_cell_matrix = s$source_cells,
    processing_ledger = idx,
    zero_to_na = TRUE,
    processing_masks = list(zero_to_na = zero, not_assigned = !coverage),
    processing_counts = c(
      zero_to_na = sum(zero),
      not_assigned = sum(!coverage)
    ),
    zero_handling = 'Quantitative zeros become NA. Absence of an assigned glycopeak remains NA; no zero imputation or renormalization.',
    molecular_annotation = 'Source compositions: H=Hex, N=HexNAc, F=Fuc, PC=phosphorylcholine, A=GlcA. Analytical anthranilic-acid label excluded from native glycan composition. Embedded most-probable structures are manually transcribed with explicit unknown linkages and attachment uncertainty; GSL-GP34 has conflicting diagram/composition evidence and missing typed annotations.',
    sample_description = 'Original mixed-sex adult and microfilaria spectra plus two explicitly labelled biological replicates for each. Source original profile is coded 0; this is a source index, not a claim of experimental replicate numbering. Female/male and N-glycan L3 spectra are single profiles.',
    reviewed_mapping = s,
    software = list(
      glyexp = as.character(packageVersion('glyexp')),
      glyrepr = as.character(packageVersion('glyrepr'))
    )
  )
  obj <- GlycomicSE(abundance, rowData = rd, colData = cd, metadata = md)
  stopifnot(
    validObject(obj),
    !any(assay(obj) == 0, na.rm = TRUE),
    all(is.na(raw[!coverage]))
  )
  assign(s$name, obj)
  save(
    list = s$name,
    file = file.path('data-raw/_shared/bundled-build', paste0(s$name, '.rda')),
    compress = 'xz',
    version = 3
  )
  validation[[s$name]] <- list(
    features = nrow(obj),
    samples = ncol(obj),
    observed = sum(coverage),
    zero_to_na = sum(zero),
    missing = sum(is.na(abundance)),
    structures = sum(!is.na(structures)),
    valid = TRUE
  )
}
jsonlite::write_json(
  validation,
  'data-raw/GPST000240/validation.json',
  pretty = TRUE,
  auto_unbox = TRUE
)
print(validation)
