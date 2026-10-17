# Rebuild reviewed source-backed quantitative objects.
stopifnot(
  unname(tools::md5sum(
    "data-raw/GPST000473/41467_2025_60563_MOESM5_ESM.xlsx"
  )) ==
    "f92d11e3a0f68f694e07527e590b8cfd"
)
stopifnot(
  unname(tools::md5sum("data-raw/GPST000473/transcribed-structures.json")) ==
    "0fbc2a18d9c13f358327d0f61652e213"
)
source("data-raw/_shared/build-matrix-specs.R", local = TRUE)
build_matrix_specs("data-raw/GPST000473/matrix-specs.json")
