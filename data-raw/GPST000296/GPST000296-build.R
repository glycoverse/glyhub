# Rebuild reviewed source-backed quantitative objects.
stopifnot(
  unname(tools::md5sum("data-raw/GPST000296/structure-transcription.json")) ==
    "18963324494f17a95a7b38c2b51bda7d"
)
stopifnot(
  unname(tools::md5sum("data-raw/GPST000296/mmc2.xlsx")) ==
    "04b1cd055f65be76a406e776cffdb6f0"
)
stopifnot(
  unname(tools::md5sum("data-raw/GPST000296/Glycan_results.xlsx")) ==
    "bcad2218504724dafc1e4f9193afccd7"
)
stopifnot(
  unname(tools::md5sum("data-raw/GPST000296/mmc3.pdf")) ==
    "200832fd016a3e1370eacd19b8ab6dde"
)
source("data-raw/_shared/scripts/build-matrix-specs.R", local = TRUE)
build_matrix_specs("data-raw/GPST000296/matrix-specs.json")

source("data-raw/GPST000296/GPST000296-Glycoproteomics-build.R", local = TRUE)
