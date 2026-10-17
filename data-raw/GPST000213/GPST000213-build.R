# Rebuild checksum-pinned source matrices for GPST000213.
source("data-raw/_shared/scripts/build-matrix-specs.R", local = TRUE)
build_matrix_specs("data-raw/GPST000213/matrix-specs.json")
