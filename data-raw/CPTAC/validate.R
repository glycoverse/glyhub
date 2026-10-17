# Validate distributed assets against every supplied source cell.
stopifnot(requireNamespace("glyexp", quietly = TRUE))
args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) == 1L)
manifest <- utils::read.delim(
  "data-raw/CPTAC/manifest.tsv",
  stringsAsFactors = FALSE
)
for (cohort in unique(manifest$cohort)) {
  m <- manifest[manifest$cohort == cohort, ]
  for (i in seq_len(nrow(m))) {
    f <- file.path("data-raw/CPTAC/assets", m$filename[i])
    stopifnot(
      file.info(f)$size == m$bytes[i],
      digest::digest(file = f, algo = "sha256") == m$sha256[i]
    )
  }
  raw_path <- file.path("data-raw/CPTAC/assets", m$filename[m$kind == "raw"])
  con <- gzfile(raw_path, "rb")
  bytes <- readBin(con, "raw", n = 1e9)
  close(con)
  stopifnot(
    digest::digest(bytes, algo = "sha256", serialize = FALSE) ==
      m$source_sha256[1]
  )
  source_path <- list.files(
    file.path(args[[1]], "data"),
    pattern = paste0("^", cohort, "_"),
    full.names = TRUE
  )
  source <- utils::read.delim(
    source_path,
    check.names = FALSE,
    quote = "",
    na.strings = "None",
    comment.char = ""
  )
  x <- readRDS(file.path(
    "data-raw/CPTAC/assets",
    m$filename[m$kind == "curated"]
  ))
  original <- as.matrix(source[, -(1:3)])
  storage.mode(original) <- "double"
  dimnames(original) <- dimnames(x)
  stopifnot(
    methods::validObject(x),
    identical(original, S4Vectors::metadata(x)$raw_abundance),
    identical(2^original, SummarizedExperiment::assay(x)),
    identical(
      source$Sequence,
      SummarizedExperiment::rowData(x)$source_sequence
    ),
    identical(source$Gene, SummarizedExperiment::rowData(x)$source_gene),
    identical(names(source)[-(1:3)], colnames(x)),
    !anyDuplicated(rownames(x)),
    !anyDuplicated(colnames(x))
  )
  message(cohort, ": all ", length(original), " source cells verified")
}
