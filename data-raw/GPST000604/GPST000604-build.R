# Source-area GAG disaccharide objects. No substitution of saturated HexA for DeltaUA.
# Run from the package root: Rscript data-raw/GPST000604/GPST000604-build.R
args <- commandArgs(trailingOnly = TRUE)
root <- 'data-raw'
outdir <- if (length(args)) {
  args[1]
} else {
  'data-raw/_shared/artifacts/bundled-build'
}
dir.create(outdir, recursive = TRUE, showWarnings = FALSE)
suppressPackageStartupMessages({
  library(glyexp)
  library(glyrepr)
  library(S4Vectors)
  library(SummarizedExperiment)
})
spec <- jsonlite::fromJSON(
  file.path(root, 'GPST000604', 'curated_source_extraction.json'),
  simplifyVector = FALSE
)
stopifnot(file.exists(spec$source_file))
actual_sha <- digest::digest(
  file = spec$source_file,
  algo = "sha256",
  serialize = FALSE
)
stopifnot(identical(actual_sha, spec$sha256))
# Verify original workbook cells, not just an intermediate matrix.
read_source <- function(sheet) {
  readxl::read_xlsx(
    spec$source_file,
    sheet = sheet,
    range = 'A1:T36',
    col_names = FALSE,
    .name_repair = 'minimal'
  )
}
cache <- setNames(
  lapply(unique(vapply(spec$samples, `[[`, '', 'sheet')), read_source),
  unique(vapply(spec$samples, `[[`, '', 'sheet'))
)
for (o in spec$observations) {
  for (c in o$source_cells) {
    col <- utf8ToInt(sub('[0-9]+$', '', c$cell)) - utf8ToInt('A') + 1L
    row <- as.integer(sub('^[A-Z]+', '', c$cell))
    value <- cache[[o$source_sheet]][[col]][row]
    stopifnot(
      if (is.null(c$value)) {
        is.na(value)
      } else {
        identical(as.numeric(value), as.numeric(c$value))
      }
    )
  }
}
# Unsupported residues are explicit missing typed annotations, not approximate chemistry.
stopifnot(!('DeltaUA' %in% available_monosaccharides()))
res <- list()
for (cls in c('HS', 'CS/DS')) {
  ss <- Filter(function(s) s$class == cls, spec$samples)
  ff <- Filter(function(f) f$class == cls, spec$features)
  ids <- vapply(ss, `[[`, '', 'sample_id')
  features <- vapply(ff, `[[`, '', 'feature_id')
  raw <- standard <- matrix(
    NA_real_,
    length(features),
    length(ids),
    dimnames = list(features, ids)
  )
  for (o in spec$observations) {
    if (o$sample_id %in% ids && o$feature_id %in% features) {
      value <- sum(vapply(
        o$source_cells,
        function(c) if (is.null(c$value)) 0 else c$value,
        numeric(1)
      ))
      stopifnot(value == o$summed_XIC_peak_area)
      if (o$isotope == 'C12') {
        raw[o$feature_id, o$sample_id] <- value
      } else {
        standard[o$feature_id, o$sample_id] <- value
      }
    }
  }
  stopifnot(!anyNA(raw), !anyNA(standard), all(standard > 0))
  abundance <- raw
  zero <- raw == 0
  abundance[zero] <- NA_real_
  rd <- DataFrame(
    row.names = features,
    source_feature_id = features,
    source_structure = vapply(ff, `[[`, '', 'source_structure'),
    annotation_status = rep(
      'Unsupported 4,5-unsaturated uronic acid residue in glyrepr 1.1.0',
      length(ff)
    ),
    deltaUA_count = rep(1L, length(ff)),
    N_sulfate = vapply(
      ff,
      function(f) as.integer(f$modifications$N_sulfate),
      integer(1)
    ),
    uronic_acid_2_O_sulfate = vapply(
      ff,
      function(f) as.integer(f$modifications$uronic_acid_2_O_sulfate),
      integer(1)
    ),
    total_sulfate = vapply(
      ff,
      function(f) as.integer(f$modifications$total_sulfate),
      integer(1)
    )
  )
  rd$glycan_composition <- rep(glycan_composition(NA), length(ff))
  rd$source_chemistry <- I(ff)
  cd <- DataFrame(
    row.names = ids,
    source_sample_name = vapply(ss, `[[`, '', 'source_sample_name'),
    source_sheet = vapply(ss, `[[`, '', 'sheet'),
    sample_group = vapply(ss, `[[`, '', 'group'),
    replicate = vapply(ss, function(s) as.integer(s$replicate), integer(1)),
    is_commercial_material = vapply(ss, `[[`, FALSE, 'is_commercial_material'),
    source_duplicate_profile = ids %in%
      c('Brain_HS__Brain_R3', 'Liver_HS__Liver_R3')
  )
  idx <- expand.grid(
    feature_index = seq_len(nrow(raw)),
    observation_index = seq_len(ncol(raw))
  )
  idx$feature_id <- rownames(raw)[idx$feature_index]
  idx$observation_id <- colnames(raw)[idx$observation_index]
  idx$original_value <- as.vector(raw)
  idx$curated_value <- as.vector(abundance)
  idx$reason <- ifelse(as.vector(zero), "zero_abundance", "unchanged")
  idx$source_cells <- vapply(
    seq_len(nrow(idx)),
    function(i) {
      hit <- Filter(
        function(o) {
          o$isotope == "C12" &&
            o$feature_id == idx$feature_id[i] &&
            o$sample_id == idx$observation_id[i]
        },
        spec$observations
      )
      stopifnot(length(hit) == 1)
      paste(
        vapply(
          hit[[1]]$source_cells,
          function(c) paste0(hit[[1]]$source_sheet, "!", c$cell),
          character(1)
        ),
        collapse = ";"
      )
    },
    character(1)
  )
  md <- list(
    processing_ledger = idx,
    glycan_type = 'GAG',
    accession = 'GPST000604',
    doi = '10.1021/acs.analchem.5c02338',
    title = paste('HILIC-Q-TOF-MS', cls, 'disaccharide profiles'),
    unit = spec$assay_units,
    annotation_gate = 'Accepted with representation limitation: exact DeltaUA chemistry unsupported by installed glyrepr; typed missing annotations are intentional and exact source chemistry is preserved.',
    source = list(
      file = basename(spec$source_file),
      sha256 = spec$sha256,
      url = 'https://pmc.ncbi.nlm.nih.gov/articles/PMC12368834/',
      structure_table = 'Supplemental Table S1, PDF page S11'
    ),
    raw_abundance = raw,
    internal_standard_C13_peak_area = standard,
    source_coverage = matrix(
      TRUE,
      nrow(raw),
      ncol(raw),
      dimnames = dimnames(raw)
    ),
    zero_to_na = TRUE,
    processing_masks = list(zero_to_na = zero),
    processing_counts = c(zero_to_na = sum(zero), source_missing = 0),
    zero_handling = 'Only final sample quantitative zeros become NA. Original C12 and C13 areas remain in metadata. Absent adduct fields contribute nothing to per-glycan sums; no imputation or normalization.',
    quantitative_method = 'Sum source C12 XIC peak areas over observed sodium adducts. C13 areas are matched internal standards, not samples. No isotope ratio or absolute amount derived.',
    source_cell_provenance = Filter(
      function(o) o$sample_id %in% ids,
      spec$observations
    ),
    source_tables = cache[unique(vapply(ss, `[[`, '', 'sheet'))],
    quality_flags = spec$warnings,
    published_sum_discrepancies = spec$published_sum_discrepancies,
    software = list(
      glyrepr = as.character(packageVersion('glyrepr')),
      glyexp = as.character(packageVersion('glyexp'))
    )
  )
  obj <- GlycomicSE(abundance, rowData = rd, colData = cd, metadata = md)
  stopifnot(
    validObject(obj),
    nrow(obj) == length(features),
    ncol(obj) == length(ids),
    !any(assay(obj) == 0, na.rm = TRUE),
    all(is.na(rowData(obj)$glycan_composition))
  )
  name <- paste0('glyhub_GPST000604_', if (cls == 'HS') 'HS' else 'CS_DS')
  assign(name, obj)
  save(
    list = name,
    file = file.path(outdir, paste0(name, '.rda')),
    compress = 'xz',
    version = 3
  )
  res[[name]] <- list(
    features = nrow(obj),
    observations = ncol(obj),
    assay_zero_to_na = sum(zero),
    validation = TRUE,
    annotation_gate = 'representation_limited_accepted'
  )
}
jsonlite::write_json(
  res,
  file.path('data-raw', 'GPST000604', 'validation.json'),
  pretty = TRUE,
  auto_unbox = TRUE
)
print(res)
