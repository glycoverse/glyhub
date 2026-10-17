# Rebuild checksum-pinned source matrices for GPST000431.
source("data-raw/_shared/scripts/build-matrix-specs.R", local = TRUE)
build_matrix_specs("data-raw/GPST000431/matrix-specs.json")
