# These study-level matrices are already consolidated by compatible glycan type.
# The original panel merger runs first and restores its own documentation catalog.
records <- jsonlite::fromJSON(
  "data-raw/expansion-dataset-descriptions.json",
  simplifyVector = FALSE
)
accessions <- unique(vapply(records, `[[`, "", "accession"))
for (accession in accessions) {
  source(
    file.path("data-raw", accession, paste0(accession, "-build.R")),
    local = new.env()
  )
}
original <- jsonlite::fromJSON(
  "data-raw/dataset-descriptions.json",
  simplifyVector = FALSE
)
all_records <- c(original, records)
object_names <- vapply(all_records, `[[`, "", "name")
stopifnot(!anyDuplicated(object_names))
stopifnot(all(file.exists(file.path(
  "data-raw/bundled-build",
  paste0(object_names, ".rda")
))))
jsonlite::write_json(
  all_records,
  "data-raw/dataset-descriptions.json",
  auto_unbox = TRUE,
  pretty = TRUE,
  null = "null"
)
