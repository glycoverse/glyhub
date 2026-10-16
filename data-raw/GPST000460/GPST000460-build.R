# Rebuild reviewed source-backed quantitative objects.
stopifnot(
  unname(tools::md5sum("data-raw/GPST000460/Supplemental_Tables_S3-S8.xlsx")) ==
    "4a1a8aabf3e1c0cfd6b28dbe856be77f"
)
stopifnot(
  unname(tools::md5sum("data-raw/GPST000460/glytoucan_sequences.json")) ==
    "a7edd77fb19b17fb63458b4aff094526"
)
stopifnot(
  unname(tools::md5sum("data-raw/GPST000460/verified-mapping.json")) ==
    "3051dbbba50aa3e8652b624c108e9395"
)
stopifnot(
  unname(tools::md5sum("data-raw/GPST000460/glytoucan_parsed.json")) ==
    "9039ef4a2a1290dccaf15f8fe3e7a61c"
)
stopifnot(
  unname(tools::md5sum("data-raw/GPST000460/source-worksheets.json")) ==
    "f9b448954c51180a685223db3b8937fb"
)
source("data-raw/build-matrix-specs.R", local = TRUE)
build_matrix_specs("data-raw/GPST000460/matrix-specs.json")
