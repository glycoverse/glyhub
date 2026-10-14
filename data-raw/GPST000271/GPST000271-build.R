# Rebuild checksum-pinned source matrices for GPST000271.
source("data-raw/build-matrix-specs.R", local = TRUE)
build_matrix_specs("data-raw/GPST000271/matrix-specs.json")
