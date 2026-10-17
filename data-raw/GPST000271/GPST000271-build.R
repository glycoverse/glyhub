# Rebuild checksum-pinned source matrices for GPST000271.
source("data-raw/_shared/build-matrix-specs.R", local = TRUE)
build_matrix_specs("data-raw/GPST000271/matrix-specs.json")
