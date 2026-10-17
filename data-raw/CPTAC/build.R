# From package root: Rscript data-raw/CPTAC/build.R /path/to/glycoproteome
# Rebuilds assets and manifest; publishing is a separate, explicit step.
args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) == 1L)
source("data-raw/CPTAC/convert.R")
root <- args[[1]]
out <- "data-raw/CPTAC/assets"
dir.create(out, recursive = TRUE, showWarnings = FALSE)
tag <- "cptac-data-v1"
base_url <- paste0(
  "https://github.com/glycoverse/glyhub/releases/download/",
  tag,
  "/"
)
checks <- utils::read.delim(
  file.path(
    root,
    "description",
    "md5_checksums_PanCancer_JHU_GENCODEv34_fasta_expression_matrices_20210429.tsv"
  ),
  check.names = FALSE
)
manifest <- list()
for (path in sort(list.files(
  file.path(root, "data"),
  pattern = "\\.tsv$",
  full.names = TRUE
))) {
  cohort <- sub("_.*", "", basename(path))
  name <- paste0("glyhub_CPTAC_", cohort)
  md5 <- unname(tools::md5sum(path))
  matched <- checks$Filename[checks[[2]] == md5]
  status <- if (length(matched)) {
    "exact upstream MD5 match"
  } else {
    "not matched to supplied upstream MD5 list"
  }
  if (cohort %in% c("COAD", "PDAC")) {
    alias <- c(COAD = "CRC", PDAC = "PDA")[[cohort]]
    b <- readChar(path, file.info(path)$size, useBytes = TRUE)
    restored <- gsub(paste0(cohort, "."), paste0(alias, "."), b, fixed = TRUE)
    restored_md5 <- digest::digest(
      charToRaw(restored),
      algo = "md5",
      serialize = FALSE
    )
    matched <- checks$Filename[checks[[2]] == restored_md5]
    stopifnot(length(matched) == 1L)
    status <- "upstream MD5 matches after reversing cohort prefixes in header"
  }
  provenance <- list(
    filename = basename(path),
    sha256 = digest::digest(file = path, algo = "sha256"),
    md5 = md5,
    upstream_filename = if (length(matched)) matched else NA_character_,
    upstream_verification = status,
    data_version = tag
  )
  message("Building ", name)
  x <- cptac_convert(path, cohort, provenance)
  stopifnot(
    methods::validObject(x),
    identical(
      SummarizedExperiment::assay(x),
      2^S4Vectors::metadata(x)$raw_abundance
    )
  )
  rds <- file.path(out, paste0(name, ".rds"))
  saveRDS(x, rds, compress = "xz", version = 3)
  # Preserve source bytes exactly, including local cohort renaming.
  raw_path <- file.path(out, paste0(name, ".tsv.gz"))
  con <- gzfile(raw_path, "wb", compression = 9)
  writeBin(readBin(path, "raw", n = file.info(path)$size), con)
  close(con)
  storage <- "release"
  for (kind in c("curated", "raw")) {
    f <- if (kind == "curated") rds else raw_path
    manifest[[length(manifest) + 1L]] <- data.frame(
      dataset = name,
      cohort = cohort,
      kind = kind,
      version = tag,
      storage = if (kind == "curated") storage else "release",
      filename = basename(f),
      bytes = file.info(f)$size,
      sha256 = digest::digest(file = f, algo = "sha256"),
      url = paste0(base_url, basename(f)),
      features = nrow(x),
      measurements = ncol(x),
      source_sha256 = provenance$sha256,
      source_md5 = md5,
      upstream_verification = status,
      stringsAsFactors = FALSE
    )
  }
  message(
    "  RDS MiB: ",
    round(file.info(rds)$size / 1024^2, 2),
    " (",
    storage,
    ")"
  )
}
manifest <- do.call(rbind, manifest)
utils::write.table(
  manifest,
  "data-raw/CPTAC/manifest.tsv",
  sep = "\t",
  quote = FALSE,
  row.names = FALSE
)
file.copy(
  "data-raw/CPTAC/manifest.tsv",
  file.path(out, "manifest.tsv"),
  overwrite = TRUE
)
file.copy(
  list.files(file.path(root, "description"), full.names = TRUE),
  out,
  overwrite = TRUE
)
