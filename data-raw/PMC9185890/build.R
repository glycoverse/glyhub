args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) == 2L)
cache <- args[2]
source("data-raw/_shared/scripts/noncptac/register-literature.R")
source("data-raw/_shared/scripts/noncptac/convert-feature-source.R")
spec <- jsonlite::fromJSON("data-raw/PMC9185890/source.json")
path <- file.path(args[1], spec$local_file)
stopifnot(identical(digest::digest(file = path, algo = "sha256"), spec$sha256))
x <- literature_feature_source(path, spec)
independent <- as.data.frame(readxl::read_excel(
  path,
  sheet = spec$sheet,
  skip = spec$header_excel_row - 1L,
  na = c("", "NA"),
  .name_repair = "minimal"
))
a <- as.matrix(independent[spec$measurement_columns_1based])
stopifnot(
  identical(as.numeric(a), as.numeric(SummarizedExperiment::assay(x))),
  methods::validObject(x)
)
register_literature(
  x,
  spec$dataset,
  spec$title,
  c(
    spec$design,
    spec$molecular_level,
    spec$limitations,
    "Complete selected source rows and measurements retained without additional numerical processing."
  )
)
jsonlite::write_json(
  list(
    dimensions = dim(x),
    source_cells_compared = length(a),
    source_values_exact = TRUE,
    source_sha256 = spec$sha256,
    valid_object = TRUE
  ),
  "data-raw/PMC9185890/validation.json",
  pretty = TRUE,
  auto_unbox = TRUE
)
