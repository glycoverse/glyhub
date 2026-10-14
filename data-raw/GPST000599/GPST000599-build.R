# Rebuild checksum-pinned source matrices for GPST000599.
source("data-raw/build-matrix-specs.R", local = TRUE)
build_matrix_specs("data-raw/GPST000599/matrix-specs.json")
