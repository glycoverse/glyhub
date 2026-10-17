args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) == 2L)
evidence <- normalizePath(args[1], mustWork = TRUE)
cache <- args[2]
source("data-raw/_shared/noncptac/convert.R")
source("data-raw/_shared/noncptac/convert-additional.R")
source("data-raw/_shared/noncptac/register.R")

p <- file.path(evidence, "human-atlas/Supplementary Data 2.xlsx")
mp <- file.path(evidence, "human-atlas/Supplementary Data 1.xlsx")
sha <- digest::digest(file = p, algo = "sha256")
stopifnot(
  sha == "ee62f8387f5f4fcd39b6ae0d8533fdfbd5e56765abaa02801b746562643441d4"
)
x <- noncptac_atlas(
  p,
  mp,
  list(
    workbook_sha256 = sha,
    subject_workbook_sha256 = digest::digest(file = mp, algo = "sha256"),
    retrieved = "2026-10-17",
    source_url = "https://media.springernature.com/original/springer-static/esm/art%3A10.1038%2Fs41467-026-74631-7/MediaObjects/41467_2026_74631_MOESM3_ESM.zip",
    workbook = "Supplementary Data 2.xlsx",
    sheet = "Raw expression matrix"
  )
)
stopifnot(identical(dim(x), c(57884L, 219L)))
register(x, "glyhub_PXD070547_N_HumanAtlas")
rm(x)
