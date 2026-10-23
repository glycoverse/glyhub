# Run from package root with source directory and cache directory.
args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) == 2L)
cache <- args[2]
source("data-raw/_shared/scripts/noncptac/register-literature.R")
source("data-raw/_shared/scripts/noncptac/convert-protein-source.R")
spec <- jsonlite::fromJSON("data-raw/MSV000088624/source.json")
path <- file.path(args[1], spec$local_file)
stopifnot(identical(digest::digest(file = path, algo = "sha256"), spec$sha256))
x <- literature_protein_source(path, spec)
independent <- as.matrix(readxl::read_excel(
  path,
  sheet = spec$sheet,
  range = spec$independent_quant_range,
  col_names = FALSE,
  na = c("", "NA"),
  .name_repair = "minimal"
))
stopifnot(
  identical(
    as.numeric(independent),
    as.numeric(SummarizedExperiment::assay(x))
  ),
  methods::validObject(x)
)
register_literature(
  x,
  spec$dataset,
  spec$title,
  c(
    "Complete selected author protein-level glyco-enrichment matrix, not intact glycopeptide or quantified glycosite data.",
    spec$author_processing,
    spec$replication_caution,
    "Source identifiers and annotations retained; no glycan composition, topology or site inferred."
  )
)
jsonlite::write_json(
  list(
    dimensions = dim(x),
    source_cells_compared = length(independent),
    source_values_exact = TRUE,
    source_sha256 = spec$sha256,
    valid_object = TRUE
  ),
  "data-raw/MSV000088624/validation.json",
  pretty = TRUE,
  auto_unbox = TRUE
)
