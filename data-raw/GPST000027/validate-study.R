# Rebuild only this study and prove that every pre-existing RDA stays byte-identical.
name <- "glyhub_GPST000027_031_N"
target <- file.path(
  "data-raw/_shared/artifacts/bundled-build",
  paste0(name, ".rda")
)
baseline <- setdiff(
  list.files(
    "data-raw/_shared/artifacts/bundled-build",
    pattern = "[.]rda$",
    full.names = TRUE
  ),
  target
)
stopifnot(length(baseline) == 74L)
before <- tools::md5sum(baseline)
read_study <- function() {
  e <- new.env()
  load(target, e)
  e[[name]]
}
canonical <- function(x) {
  if (inherits(x, "glyrepr_composition") || inherits(x, "glyrepr_structure")) {
    return(unname(as.character(x)))
  }
  if (methods::is(x, "DataFrame")) {
    return(list(
      row_names = rownames(x),
      columns = lapply(as.list(x), canonical)
    ))
  }
  if (is.list(x)) {
    return(lapply(x, canonical))
  }
  x
}
scientific <- function(x) {
  canonical(list(
    assay = SummarizedExperiment::assay(x),
    rowData = SummarizedExperiment::rowData(x),
    colData = SummarizedExperiment::colData(x),
    metadata = S4Vectors::metadata(x)
  ))
}
source("data-raw/GPST000027/GPST000027-build.R", local = new.env())
first <- scientific(read_study())
source("data-raw/GPST000027/GPST000027-build.R", local = new.env())
stopifnot(identical(first, scientific(read_study())))
stopifnot(identical(before, tools::md5sum(baseline)))
x <- read_study()
m <- S4Vectors::metadata(x)
report <- list(
  object = name,
  dimensions = dim(x),
  repeated_rebuild_scientifically_identical = TRUE,
  preexisting_rda_files_byte_identical = length(baseline),
  measured_cells = sum(m$source_coverage),
  unmeasured_cells = sum(!m$source_coverage),
  source_zeros = sum(m$processing_masks$zero_to_na),
  typed_compositions = sum(
    !is.na(SummarizedExperiment::rowData(x)$glycan_composition)
  ),
  missing_compositions = sum(is.na(
    SummarizedExperiment::rowData(x)$glycan_composition
  )),
  structure_column_absent = !"glycan_structure" %in%
    names(SummarizedExperiment::rowData(x)),
  R = as.character(getRversion()),
  glyexp = as.character(utils::packageVersion("glyexp")),
  glyrepr = as.character(utils::packageVersion("glyrepr"))
)
jsonlite::write_json(
  report,
  "data-raw/GPST000027/study-validation.json",
  pretty = TRUE,
  auto_unbox = TRUE
)
message(
  "Study reproduced twice; all 74 pre-existing RDA files are byte-identical."
)
