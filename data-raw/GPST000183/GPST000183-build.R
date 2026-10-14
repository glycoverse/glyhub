# Rebuild checksum-pinned source matrices for GPST000183.
source("data-raw/build-matrix-specs.R", local = TRUE)
build_matrix_specs("data-raw/GPST000183/matrix-specs.json")
