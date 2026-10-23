args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) == 2L)
cache <- args[2]
source("data-raw/_shared/scripts/noncptac/register-literature.R")
spec <- jsonlite::fromJSON("data-raw/PXD013893/source.json")
path <- file.path(args[1], spec$local_file)
stopifnot(digest::digest(file = path, algo = "sha256") == spec$sha256)
d <- utils::read.delim(
  path,
  check.names = FALSE,
  quote = "",
  stringsAsFactors = FALSE,
  na.strings = c("", "NA")
)
a <- as.matrix(d[spec$columns])
stopifnot(
  identical(dim(a), c(1527L, 6L)),
  is.numeric(a),
  !anyNA(a),
  all(is.finite(a)),
  all(a >= 0),
  sum(a == 0) == 2485L
)
ids <- sprintf("PXD013893_source_%05d", seq_len(nrow(d)))
rownames(a) <- ids
rd <- S4Vectors::DataFrame(
  d[setdiff(names(d), spec$columns)],
  row.names = ids,
  check.names = FALSE
)
reverse <- !is.na(d$Reverse) & d$Reverse == "+"
contaminant <- !is.na(d$`Potential contaminant`) &
  d$`Potential contaminant` == "+"
rd$source_reverse <- reverse
rd$source_potential_contaminant <- contaminant
rd$row_role <- ifelse(
  reverse & contaminant,
  "reverse_and_potential_contaminant",
  ifelse(
    reverse,
    "reverse_control",
    ifelse(contaminant, "potential_contaminant", "source_target_record")
  )
)
rd$protein <- ifelse(
  !reverse & !contaminant & !grepl(";", d$Proteins),
  d$Proteins,
  NA_character_
)
site <- suppressWarnings(as.integer(d$`Positions within proteins`))
rd$protein_site <- ifelse(
  !is.na(rd$protein) & !grepl(";", d$`Positions within proteins`),
  site,
  NA_integer_
)
rd$glycan_composition <- rep(glyrepr::glycan_composition(NA), nrow(d))
rd$source_row <- seq_len(nrow(d)) + 1L
cd <- S4Vectors::DataFrame(
  source_experiment = spec$mapping$experiment,
  source_run = spec$mapping$raw_file,
  method = rep(c("glyco_only", "sequential_phospho_then_glyco"), each = 3),
  replicate = rep(1:3, 2),
  replicate_type = "technical",
  species = "Homo sapiens",
  material = "plasma-derived extracellular vesicles",
  row.names = spec$columns
)
stopifnot(identical(paste("Intensity", cd$source_experiment), spec$columns))
x <- glyexp::GlycoproteomicSE(
  a,
  rowData = rd,
  colData = cd,
  metadata = list(
    accession = spec$accession,
    doi = spec$doi,
    glycan_type = "N",
    source_repository = "PRIDE",
    source = spec$archive_member,
    source_provenance = spec,
    license = "CC0 1.0 repository dataset",
    license_url = "https://creativecommons.org/publicdomain/zero/1.0/",
    assay_scale = "author native MaxQuant site-group intensity; not LFQ or downstream imputed abundance",
    feature_grain = spec$feature_grain,
    raw_abundance = a,
    source_table = d,
    source_row = rd$source_row,
    source_measurement_columns = match(spec$columns, names(d)),
    processing_masks = list(
      source_missing = is.na(a),
      source_zero = !is.na(a) & a == 0
    ),
    processing = spec$limitations
  )
)
register_literature(
  x,
  "glyhub_PXD013893_N_EVEnrichmentMethods",
  "Plasma extracellular-vesicle N-glyco enrichment method comparison",
  c(
    "Complete 1527-row author native site-group table with six technical measurements.",
    "Includes reverse and potential-contaminant rows; use explicit row_role and source flags when selecting biological targets.",
    "All original source columns, multiplicity alternatives, zeros and ambiguous groups remain available.",
    "No new filtering, normalization or imputation; these are not six independent patients."
  )
)
jsonlite::write_json(
  list(
    dimensions = dim(x),
    zeros = sum(a == 0),
    missing = sum(is.na(a)),
    reverse = sum(reverse),
    potential_contaminant = sum(contaminant),
    overlap = sum(reverse & contaminant),
    original_values_exact = identical(
      as.numeric(a),
      as.numeric(as.matrix(d[spec$columns]))
    ),
    valid_object = methods::validObject(x)
  ),
  "data-raw/PXD013893/validation.json",
  auto_unbox = TRUE,
  pretty = TRUE
)
