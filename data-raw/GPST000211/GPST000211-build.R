# Rebuild reviewed source-backed quantitative objects.
stopifnot(
  unname(tools::md5sum("data-raw/GPST000211/ML_structures+linkages.gwp")) ==
    "3343bbfd88536cdde50cea52098388d2"
)
stopifnot(
  unname(tools::md5sum("data-raw/GPST000211/mmc6.xlsx")) ==
    "57069a899a58589e7e040ac5fd138ec0"
)
source("data-raw/build-matrix-specs.R", local = TRUE)
build_matrix_specs("data-raw/GPST000211/matrix-specs.json")
