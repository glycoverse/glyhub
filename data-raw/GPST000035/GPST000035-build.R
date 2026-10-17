# Rebuild checksum-pinned source matrices for GPST000035.
source("data-raw/_shared/build-matrix-specs.R", local = TRUE)
build_matrix_specs("data-raw/GPST000035/matrix-specs.json")
