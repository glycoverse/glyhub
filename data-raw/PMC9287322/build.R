args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) == 2L)
cache <- args[2]
source("data-raw/_shared/scripts/noncptac/register-literature.R")
source("data-raw/_shared/scripts/noncptac/convert-protein-source.R")
specs <- jsonlite::fromJSON("data-raw/PMC9287322/sources.json", simplifyVector = FALSE)
validation <- list()
for (s in specs) {
  # Simplify each nested record independently; sample mapping becomes a data frame.
  spec <- jsonlite::fromJSON(jsonlite::toJSON(s, auto_unbox = TRUE))
  spec$measurement_columns <- unlist(spec$measurement_columns)
  spec$read_range <- NULL
  path <- file.path(args[1], spec$local_file)
  stopifnot(identical(digest::digest(file = path, algo = "sha256"), spec$sha256))
  x <- literature_protein_source(path, spec)
  independent <- as.data.frame(readxl::read_excel(path, sheet = spec$sheet,
    skip = spec$header_row - 1L, na = c("", "NA"), .name_repair = "minimal"))
  a <- as.matrix(independent[spec$source_measurement_columns_1based])
  stopifnot(identical(as.numeric(a), as.numeric(SummarizedExperiment::assay(x))),
    methods::validObject(x))
  register_literature(x, spec$dataset, spec$title, c(
    spec$author_processing, spec$replication_caution,
    "Preserve every author row, including repeated protein labels; do not deduplicate or infer quantified glycans/sites.",
    "These panels share a study source family and are not independent cohorts; accession mapping is retained per source table."))
  validation[[spec$dataset]] <- list(dimensions = dim(x), source_cells_compared = length(a),
    source_values_exact = TRUE, source_sha256 = spec$sha256, valid_object = TRUE)
}
jsonlite::write_json(validation, "data-raw/PMC9287322/validation.json", pretty = TRUE, auto_unbox = TRUE)
