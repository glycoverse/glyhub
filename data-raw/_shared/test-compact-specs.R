# Run from the repository root: Rscript data-raw/_shared/test-compact-specs.R
source("data-raw/_shared/build-matrix-specs.R")

# Exercise nulls, zeros, integer/double types, nested annotations and key order.
local({
  path <- tempfile(fileext = ".json")
  on.exit(unlink(path))
  writeLines(
    '[{"raw_matrix":[[null,null,0],[1.25,1.25,2]],"row_annotations":[{"id":"a","extra":null},{"id":"b","extra":{"x":[1,2]}}]}]',
    path
  )
  original <- read_matrix_specs(path)
  writeLines(
    '{"format":"glyhub-compact-specs-v1","specs":[{"raw_matrix":{"encoding":"runs","dim":[2,3],"runs":[[2,null],[1,0],[2,1.25],[1,2]]},"row_annotations":{"encoding":"records","keys":["id","extra"],"rows":[["a",null],["b",{"x":[1,2]}]]}}]}',
    path
  )
  stopifnot(identical(read_matrix_specs(path), original))
  writeLines(
    '{"format":"glyhub-compact-specs-v1","specs":[{"raw_matrix":{"encoding":"runs","dim":[2,3],"runs":[[2,null]]}}]}',
    path
  )
  stopifnot(inherits(try(read_matrix_specs(path), silent = TRUE), "try-error"))
  writeLines('{"format":"unknown","specs":[]}', path)
  stopifnot(inherits(try(read_matrix_specs(path), silent = TRUE), "try-error"))
})

# All unchanged specs retain their legacy reader behaviour.
paths <- list.files(
  "data-raw",
  pattern = "matrix-specs[.]json$",
  recursive = TRUE,
  full.names = TRUE
)
for (path in paths) {
  original <- jsonlite::fromJSON(path, simplifyVector = FALSE)
  decoded <- read_matrix_specs(path)
  if (is.null(original$format)) stopifnot(identical(decoded, original))
}
message(
  "Compact format round-trip, malformed input and legacy compatibility passed"
)
