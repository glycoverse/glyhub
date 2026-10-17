# Rebuild reviewed source-backed quantitative objects.
stopifnot(
  unname(tools::md5sum("data-raw/GPST000534/structure-transcription.json")) ==
    "bc80ee68411df1f39b5b54363e9fc91d"
)
stopifnot(
  unname(tools::md5sum("data-raw/GPST000534/Table.docx")) ==
    "f7d7c9530a7568e35c6ba3caf4b0239d"
)
source("data-raw/_shared/build-matrix-specs.R", local = TRUE)
build_matrix_specs("data-raw/GPST000534/matrix-specs.json")
