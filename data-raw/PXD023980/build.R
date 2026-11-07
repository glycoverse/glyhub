args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) == 2L)
cache <- args[2]
source("data-raw/PXD023980/convert.R")
source("data-raw/_shared/scripts/noncptac/register-literature.R")
specs <- jsonlite::fromJSON(
  "data-raw/PXD023980/sources.json",
  simplifyVector = FALSE
)
validation <- list()
for (s in specs) {
  spec <- jsonlite::fromJSON(jsonlite::toJSON(s, auto_unbox = TRUE))
  path <- file.path(args[1], spec$local_file)
  stopifnot(identical(
    digest::digest(file = path, algo = "sha256"),
    spec$sha256
  ))
  x <- gprodia_source(path, spec)
  original <- as.data.frame(readxl::read_excel(
    path,
    sheet = spec$sheet,
    skip = spec$header_excel_row - 1L,
    na = c("", "NA"),
    .name_repair = "minimal"
  ))
  a <- as.matrix(original[spec$measurement_columns_1based])
  stopifnot(
    identical(as.numeric(a), as.numeric(SummarizedExperiment::assay(x))),
    methods::validObject(x)
  )
  register_literature(
    x,
    spec$dataset,
    paste("GproDIA source N-glycopeptide panel", spec$name),
    c(
      spec$design,
      spec$variant_policy,
      "Complete selected author precursor matrix retained; no newly aligned or aggregated features.",
      "Source peptide, composition, charge and ambiguous protein/site annotations are preserved."
    )
  )
  validation[[spec$dataset]] <- list(
    dimensions = dim(x),
    source_cells_compared = length(a),
    source_values_exact = TRUE,
    source_sha256 = spec$sha256,
    valid_object = TRUE
  )
}
jsonlite::write_json(
  validation,
  "data-raw/PXD023980/validation.json",
  pretty = TRUE,
  auto_unbox = TRUE
)
