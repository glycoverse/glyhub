# Rebuild reviewed source-backed quantitative objects.
stopifnot(
  unname(tools::md5sum(
    "data-raw/GPST000584/41467_2026_68579_MOESM12_ESM.xlsx"
  )) ==
    "9ac52417fc03eddfa38c5563f3bca0b9"
)
stopifnot(
  unname(tools::md5sum(
    "data-raw/GPST000584/41467_2026_68579_MOESM14_ESM.xlsx"
  )) ==
    "f19ec113214a9d5242dab66fab785e2f"
)
stopifnot(
  unname(tools::md5sum("data-raw/GPST000584/group-mapping.json")) ==
    "95d18a08f0e4799e8b804757deefae0b"
)
stopifnot(
  unname(tools::md5sum(
    "data-raw/GPST000584/41467_2026_68579_MOESM6_ESM.xlsx"
  )) ==
    "062cea74d2e865317cd5e482f8a63c2f"
)
source("data-raw/_shared/scripts/build-matrix-specs.R", local = TRUE)
build_matrix_specs("data-raw/GPST000584/matrix-specs.json")
