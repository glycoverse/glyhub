# Run after preparing resource manifests. Only verified curated assets are read.
# Usage: Rscript data-raw/_shared/catalog-metadata.R [cache directory]
devtools::load_all(quiet = TRUE)
args <- commandArgs(trailingOnly = TRUE)
cache <- if (length(args)) args[[1]] else tools::R_user_dir("glyhub", "cache")
manifest <- utils::read.delim("inst/extdata/manifest.tsv")
entries <- manifest[manifest$kind == "curated", ]
metadata <- lapply(seq_len(nrow(entries)), function(i) {
  entry <- entries[i, ]
  paths <- c(
    file.path("data-raw/_shared/releases", entry$version, entry$filename),
    file.path("data-raw/_shared/bundled-build", entry$filename),
    file.path("data-raw/CPTAC/assets", entry$filename),
    file.path("data-raw/_shared/noncptac/assets", entry$filename)
  )
  paths <- paths[file.exists(paths)]
  verified <- vapply(
    paths,
    function(path) {
      identical(digest::digest(file = path, algo = "sha256"), entry$sha256)
    },
    logical(1)
  )
  if (any(verified)) {
    path <- paths[verified][[1]]
  } else {
    path <- glyhub:::.glyhub_resource_file(entry, cache, FALSE, FALSE)
  }
  if (entry$format == "rds") {
    x <- readRDS(path)
  } else {
    env <- new.env(parent = emptyenv())
    stopifnot(identical(load(path, env), entry$dataset))
    x <- env[[entry$dataset]]
  }
  stopifnot(nrow(x) == entry$features, ncol(x) == entry$measurements)
  md <- S4Vectors::metadata(x)
  rd <- SummarizedExperiment::rowData(x)
  quant <- NA_character_
  for (field in c(
    "quant_method",
    "quantitative_method",
    "assay_scale",
    "unit"
  )) {
    value <- md[[field]]
    if (
      is.character(value) && length(value) && any(!is.na(value) & nzchar(value))
    ) {
      quant <- paste(
        unique(value[!is.na(value) & nzchar(value)]),
        collapse = "; "
      )
      break
    }
  }
  data.frame(
    dataset = entry$dataset,
    sha256 = entry$sha256,
    exp_type = if (methods::is(x, "GlycoproteomicSE")) {
      "glycoproteomics"
    } else {
      "glycomics"
    },
    glycan_type = md$glycan_type,
    has_glycan_structures = "glycan_structure" %in%
      names(rd) &&
      any(!is.na(rd$glycan_structure)),
    quant_method = gsub("[\t\r\n]+", " ", quant)
  )
})
utils::write.table(
  do.call(rbind, metadata),
  "inst/extdata/catalog-metadata.tsv",
  sep = "\t",
  quote = FALSE,
  row.names = FALSE,
  na = "NA"
)
