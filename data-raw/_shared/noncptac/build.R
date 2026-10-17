# Deterministic local rebuild; no downloads or publication.
args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) == 2L)
evidence <- normalizePath(args[1], mustWork = TRUE)
checks <- read.delim(
  "data-raw/_shared/noncptac/input-checksums.tsv",
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
  "data-raw/PXD070547/build-workbooks.R",
  "data-raw/MSV000089484/build-pglyco.R",
  "data-raw/PXD046637/build-lung-raw.R",
  "data-raw/PXD052447/build-raw-psm.R",
  "data-raw/PXD052447/build-pngase-pk.R",
  "data-raw/IPX0011099000/build-mouse-area.R",
  "data-raw/PXD065283/build-hcc.R",
  "data-raw/PXD011063/build-glycodia-reports.R",
  "data-raw/PXD011063/build-glycodia-serum.R"
)) {
  source(script, local = TRUE)
}
