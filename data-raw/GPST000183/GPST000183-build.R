# Rebuild checksum-pinned source matrices for GPST000183.
source("data-raw/_shared/build-matrix-specs.R", local = TRUE)
build_matrix_specs("data-raw/GPST000183/matrix-specs.json")
