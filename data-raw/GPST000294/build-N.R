suppressPackageStartupMessages({
  library(glyexp)
  library(glyrepr)
  library(S4Vectors)
  library(SummarizedExperiment)
})
s <- jsonlite::fromJSON(
  'data-raw/GPST000294/matrix-specs-N.json',
  simplifyVector = FALSE
)
stopifnot(identical(
  digest::digest(file = s$source_file, algo = 'sha256', serialize = FALSE),
  s$source_sha256
))
raw <- do.call(
  rbind,
  lapply(s$rows, function(r) {
    vapply(
      r$abundance_percent,
      function(x) if (is.null(x)) NA_real_ else x,
      numeric(1)
    )
  })
)
dimnames(raw) <- list(
  vapply(s$rows, `[[`, '', 'feature_id'),
  unlist(s$sample_ids)
)
a <- raw
zero <- !is.na(raw) & raw == 0
a[zero] <- NA_real_
rd <- DataFrame(
  row.names = rownames(a),
  source_feature_id = rownames(a),
  source_page = vapply(s$rows, `[[`, 0, 'source_page'),
  source_table_row = vapply(s$rows, `[[`, 0, 'source_table_row'),
  source_annotation = vapply(s$rows, `[[`, '', 'source_annotation')
)
rd$glycan_composition <- do.call(
  c,
  lapply(s$rows, function(r) {
    if (is.null(r$composition_counts)) {
      glycan_composition(NA)
    } else {
      glycan_composition(unlist(r$composition_counts))
    }
  })
)
st <- vapply(
  s$rows,
  function(r) {
    if (is.null(r$structure_iupac)) NA_character_ else r$structure_iupac
  },
  character(1)
)
if (any(!is.na(st))) {
  rd$glycan_structure <- as_glycan_structure(st)
}
# Detailed diagram composition must match broad source counts before it refines types.
if (any(!is.na(st))) {
  detailed <- as_glycan_composition(rd$glycan_structure)
  broad <- function(z) {
    names(z) <- ifelse(
      names(z) %in% c('Man', 'Gal', 'Glc'),
      'Hex',
      ifelse(names(z) %in% c('GlcNAc', 'GalNAc'), 'HexNAc', names(z))
    )
    tapply(z, names(z), sum)
  }
  for (i in which(!is.na(st))) {
    d <- as.list(detailed[i])[[1]]
    expected <- s$rows[[i]]$composition_counts
    if (!is.null(expected)) {
      x <- broad(d)
      y <- broad(unlist(expected))
      stopifnot(setequal(names(x), names(y)), all(x[names(y)] == y))
    }
    rd$glycan_composition[i] <- detailed[i]
  }
}
rd$source_evidence <- I(s$rows)
cd <- DataFrame(
  row.names = colnames(a),
  organism = rep('Caenorhabditis elegans', 4),
  developmental_stage = rep('L4 larvae', 4),
  culture = c('liquid', 'plate', 'liquid', 'plate'),
  release_fraction = c('F', 'F', 'Ar', 'Ar'),
  preparation_number = rep(2L, 4),
  biological_replicate = rep(NA_integer_, 4)
)
q <- do.call(rbind, lapply(s$rows, function(r) unlist(r$qualifiers)))
dimnames(q) <- dimnames(a)
idx <- expand.grid(
  feature_index = seq_len(nrow(a)),
  sample_index = seq_len(ncol(a))
)
idx$feature_id <- rownames(a)[idx$feature_index]
idx$observation_id <- colnames(a)[idx$sample_index]
idx$original_value <- as.vector(raw)
idx$curated_value <- as.vector(a)
idx$source_token <- as.vector(q)
idx$reason <- ifelse(
  grepl('^[<>]', idx$source_token),
  'censored_percentage',
  ifelse(
    is.na(idx$original_value),
    'no_percentage_reported',
    ifelse(as.vector(zero), 'zero_abundance', 'unchanged')
  )
)
md <- list(
  accession = s$accession,
  glycan_type = 'N',
  doi = s$doi,
  unit = 'reported relative percentage',
  source = list(
    file = s$source_file,
    sha256 = s$source_sha256,
    table = 'Supplementary Table S1',
    pages = 4:17,
    url = paste0('https://doi.org/', s$doi)
  ),
  license = list(
    name = 'Published supplementary information',
    url = paste0('https://doi.org/', s$doi)
  ),
  zero_to_na = TRUE,
  raw_abundance = raw,
  source_percentage_tokens = q,
  source_coverage = q != 'no percentage reported',
  numeric_source_coverage = !is.na(raw),
  processing_ledger = idx,
  processing_masks = list(
    zero_to_na = zero,
    censored = matrix(
      grepl('^[<>]', q),
      nrow = nrow(q),
      dimnames = dimnames(q)
    ),
    not_reported = q == 'no percentage reported'
  ),
  quality_notes = s$notes,
  reported_column_sums = colSums(raw, na.rm = TRUE),
  source_records = s$rows
)
obj <- GlycomicSE(a, rowData = rd, colData = cd, metadata = md)
stopifnot(
  validObject(obj),
  !any(assay(obj) == 0, na.rm = TRUE),
  identical(as.vector(assay(obj)), md$processing_ledger$curated_value)
)
assign(s$name, obj)
save(
  list = s$name,
  file = file.path('data-raw/_shared/bundled-build', paste0(s$name, '.rda')),
  compress = 'xz',
  version = 3
)
jsonlite::write_json(
  list(
    features = nrow(obj),
    samples = ncol(obj),
    numeric_values = sum(!is.na(raw)),
    censored = sum(grepl('^[<>]', q)),
    structures = sum(!is.na(st)),
    composition = sum(!is.na(rd$glycan_composition)),
    column_sums = colSums(raw, na.rm = TRUE),
    valid = TRUE
  ),
  'data-raw/GPST000294/validation-N.json',
  pretty = TRUE,
  auto_unbox = TRUE
)
