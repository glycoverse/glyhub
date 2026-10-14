# Run from the package root. Compare scientific contents, not igraph runtime IDs.
canonical <- function(x) {
  rd <- SummarizedExperiment::rowData(x)
  rd$glycan_structure <- as.character(rd$glycan_structure)
  rd$glycan_composition <- as.character(rd$glycan_composition)
  if ("source_annotations" %in% names(rd)) {
    rd$source_annotations <- I(as.list(rd$source_annotations))
  }
  list(
    abundance = SummarizedExperiment::assay(x),
    rowData = rd,
    colData = SummarizedExperiment::colData(x),
    metadata = S4Vectors::metadata(x)
  )
}
read_object <- function(file) {
  env <- new.env(parent = emptyenv())
  name <- load(file, env)
  stopifnot(length(name) == 1)
  canonical(env[[name]])
}
files <- list.files("data", pattern = "[.]rda$", full.names = TRUE)
before <- lapply(files, read_object)
source("data-raw/build.R", local = new.env())
after <- lapply(files, read_object)
stopifnot(identical(before, after))
message(
  "Reproduced all ",
  length(files),
  " objects: assays, annotations, conditions and provenance identical."
)
