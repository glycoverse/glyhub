# Rscript data-raw/PXD013627/build.R /path/to/supplements /path/to/cache
args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) == 2L)
evidence <- normalizePath(args[1], mustWork = TRUE)
cache <- args[2]
source("data-raw/PXD013627/convert.R")
source("data-raw/_shared/scripts/noncptac/register-literature.R")
specs <- jsonlite::fromJSON(
  "data-raw/PXD013627/sources.json",
  simplifyVector = FALSE
)
validation <- list()
for (spec in specs) {
  for (key in c("measurement_columns", "annotation_columns")) {
    spec[[key]] <- unlist(spec[[key]])
  }
  p <- file.path(evidence, spec$archive_member)
  stopifnot(identical(digest::digest(file = p, algo = "sha256"), spec$sha256))
  x <- pxd013627_convert(p, spec)
  original <- readxl::read_excel(
    p,
    sheet = spec$sheet,
    skip = spec$header_row_1based - 1L,
    na = c("", "NA")
  )
  a <- as.matrix(as.data.frame(original)[spec$measurement_columns])
  stopifnot(identical(
    as.numeric(a),
    as.numeric(SummarizedExperiment::assay(x))
  ))
  name <- paste0("glyhub_PXD013627_N_", spec$object_suffix)
  register_literature(
    x,
    name,
    spec$title,
    c(
      spec$sample_design,
      "N-glyco-enriched protein groups from deamidated sequon peptides,",
      "not intact glycopeptides. No glycan compositions or quantitative protein sites are available.",
      "The author-normalized log2 abundance remains log2; it is not raw MS intensity."
    )
  )
  validation[[name]] <- list(
    source_sha256 = spec$sha256,
    dimensions = dim(x),
    source_cells_compared = length(a),
    source_values_exact = TRUE,
    source_missing = sum(is.na(a)),
    zero = sum(a == 0, na.rm = TRUE),
    valid_object = methods::validObject(x)
  )
}
jsonlite::write_json(
  validation,
  "data-raw/PXD013627/validation.json",
  pretty = TRUE,
  auto_unbox = TRUE
)
