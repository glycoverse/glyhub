# Deterministic local rebuild; no downloads or publication.
args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) == 2L)
evidence <- normalizePath(args[1], mustWork = TRUE)
checks <- read.delim(
  "data-raw/noncptac/input-checksums.tsv",
  stringsAsFactors = FALSE
)
for (i in seq_len(nrow(checks))) {
  p <- file.path(evidence, checks$file[i])
  stopifnot(
    file.exists(p),
    digest::digest(file = p, algo = "sha256") == checks$sha256[i]
  )
}
for (script in c(
  "build-workbooks.R",
  "build-pglyco.R",
  "build-lung-raw.R",
  "build-raw-psm.R",
  "build-pngase-pk.R",
  "build-mouse-area.R",
  "build-hcc.R",
  "build-glycodia-reports.R",
  "build-glycodia-serum.R"
)) {
  source(file.path("data-raw/noncptac", script), local = TRUE)
}
