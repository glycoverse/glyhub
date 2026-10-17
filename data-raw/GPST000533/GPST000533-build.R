# Rebuild checksum-pinned source matrices for GPST000533.
source("data-raw/_shared/scripts/build-matrix-specs.R", local = TRUE)
build_matrix_specs("data-raw/GPST000533/matrix-specs.json")
