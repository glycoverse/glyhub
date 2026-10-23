# Rscript data-raw/PXD047982/build.R /path/to/PXD047982 /path/to/cache
args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) == 2L)
input <- normalizePath(args[1], mustWork = TRUE)
cache <- args[2]
source("data-raw/PXD047982/convert.R")
source("data-raw/_shared/scripts/noncptac/register-literature.R")
provenance <- jsonlite::fromJSON(
  "data-raw/PXD047982/sources.json",
  simplifyVector = FALSE
)
validation <- list()
for (spec in provenance$files) {
  spec$columns <- unlist(spec$columns)
  spec$actual_raw_names <- unlist(spec$actual_raw_names)
  path <- file.path(input, spec$name)
  stopifnot(identical(
    digest::digest(file = path, algo = "sha256"),
    spec$sha256
  ))
  x <- pxd047982_convert(path, spec, provenance)
  original <- utils::read.delim(
    path,
    check.names = FALSE,
    quote = "",
    na.strings = character()
  )
  stopifnot(
    identical(as.numeric(SummarizedExperiment::assay(x)), original$MonoArea),
    identical(
      as.data.frame(SummarizedExperiment::rowData(x))$IsotopeArea,
      original$IsotopeArea
    ),
    methods::validObject(x)
  )
  name <- paste(
    "glyhub_PXD047982_O",
    spec$age,
    spec$enrichment,
    paste0("Run", spec$biological_replicate_label),
    sep = "_"
  )
  register_literature(
    x,
    name,
    paste(
      "Mouse testis source PSM MonoArea",
      spec$age,
      spec$enrichment,
      spec$biological_replicate_label
    ),
    c(
      "One author run-specific PSM table. Each column is one actual run, not a quantitative metric.",
      "Repeated molecular features remain separate source PSM rows, identified by GlySpec/Scan and source row.",
      "These objects are not aligned across runs; no merging, summing or filling is performed.",
      "IsotopeArea and corrected-area sentinels remain source annotations.",
      "Source plausible structures and composition labels are preserved without unverified typed conversion."
    )
  )
  validation[[name]] <- list(
    dimensions = dim(x),
    source_sha256 = spec$sha256,
    source_cells_compared = length(original$MonoArea),
    source_values_exact = TRUE,
    isotope_area_exact = TRUE,
    source_zero = sum(original$MonoArea == 0),
    source_missing = sum(is.na(original$MonoArea)),
    valid_object = TRUE
  )
}
jsonlite::write_json(
  validation,
  "data-raw/PXD047982/validation.json",
  pretty = TRUE,
  auto_unbox = TRUE
)
