# Rebuild checksum-pinned source matrices for GPST000676.
source("data-raw/build-matrix-specs.R", local = TRUE)
build_matrix_specs("data-raw/GPST000676/matrix-specs.json")
