# Rebuild reviewed source-backed quantitative objects.
stopifnot(
  unname(tools::md5sum(
    "data-raw/GPST000190/MoranAB_Glycopost_Identification.xlsx"
  )) ==
    "28eaaf8a12e5262920c72e8a0814c3c9"
)
source("data-raw/build-matrix-specs.R", local = TRUE)
build_matrix_specs("data-raw/GPST000190/matrix-specs.json")
