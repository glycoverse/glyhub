# Rscript data-raw/PXD019914/build-source.R /path/to/PXD019914 /path/to/cache
args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) == 2L)
source("data-raw/_shared/scripts/noncptac/register-source.R")
original <- file.path(args[1], "MOESM4.xlsx")
provenance <- jsonlite::fromJSON(
  "data-raw/PXD019914/source.json",
  simplifyVector = FALSE
)
out <- file.path(
  "data-raw/_shared/artifacts/noncptac/assets",
  "PXD019914-source"
)
status <- system2(
  "python",
  c("data-raw/PXD019914/extract-source.py", shQuote(original), shQuote(out))
)
stopifnot(status == 0L)
for (matrix in provenance$matrices) {
  path <- file.path(out, matrix$file)
  label <- if (matrix$sheet == "Intact_Normalized") "Intact" else "SPEG"
  spec <- list(
    glycan_type = "N",
    dataset = paste0("glyhub_PXD019914_N_", label, "_AuthorProcessed"),
    accession = "PXD019914",
    repository = "PRIDE",
    format = "tsv.gz",
    features = matrix$feature_rows,
    measurements = matrix$quant_columns,
    sha256 = digest::digest(file = path, algo = "sha256"),
    source_workbook_sha256 = provenance$source_files[[3]]$sha256,
    source_workbook_url = provenance$source_files[[3]]$url,
    source_sheet = matrix$sheet,
    source_metadata_columns = matrix$metadata_columns,
    source_scale = provenance$scale,
    license = provenance$license,
    doi = provenance$doi,
    curated_status = provenance$curated_status,
    sample_roles = "119 TCGA tumor and 10 CONTROL quality-control samples; exact source labels retained",
    changes = "Exact XML cell strings exported to deterministic UTF-8 TSV gzip; no numerical transformation",
    cohort_note = "Distinct source IDs and iTRAQ study versus existing prospective CPTAC TMT HGSC; no donor alias crosswalk available"
  )
  register_literature_source(path, spec, args[2])
}
