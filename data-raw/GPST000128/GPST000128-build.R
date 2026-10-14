# Rebuild checksum-pinned source matrices for GPST000128.
source("data-raw/build-matrix-specs.R", local = TRUE)
build_matrix_specs("data-raw/GPST000128/matrix-specs.json")
