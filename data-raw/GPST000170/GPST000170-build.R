# Rebuild reviewed source-backed quantitative objects.
stopifnot(
  unname(tools::md5sum(
    "data-raw/GPST000170/Glycopost_identification file.xlsx"
  )) ==
    "833e543573bb15aa726bfcbcba242e76"
)
source("data-raw/_shared/build-matrix-specs.R", local = TRUE)
build_matrix_specs("data-raw/GPST000170/matrix-specs.json")
