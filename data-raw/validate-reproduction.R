# Run from the package root. Compare scientific contents, not igraph runtime IDs.
canonical_value <- function(x) {
  if (inherits(x, "glyrepr_structure") || inherits(x, "glyrepr_composition")) return(unname(as.character(x)))
  if (methods::is(x, "DataFrame")) return(list(row_names=rownames(x), columns=lapply(as.list(x), canonical_value)))
  if (is.list(x)) return(lapply(x, canonical_value))
  x
}
canonical <- function(x) canonical_value(list(
  abundance=SummarizedExperiment::assay(x),
  rowData=SummarizedExperiment::rowData(x),
  colData=SummarizedExperiment::colData(x),
  metadata=S4Vectors::metadata(x)))
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
