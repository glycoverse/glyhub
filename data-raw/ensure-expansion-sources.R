source("data-raw/recover-sources.R", local = TRUE)
# Recover only sources used by accepted high-impact expansion datasets.
records <- jsonlite::fromJSON(
  "data-raw/expansion-dataset-descriptions.json",
  simplifyVector = FALSE
)
accessions <- unique(vapply(records, `[[`, "", "accession"))
for (accession in accessions) {
  recovery <- file.path("data-raw", accession, "ensure-source.R")
  if (file.exists(recovery)) source(recovery, local = new.env())
}

for (accession in accessions) {
  manifest <- file.path("data-raw", accession, "source-recovery.json")
  if (file.exists(manifest)) recover_sources(manifest)
}
