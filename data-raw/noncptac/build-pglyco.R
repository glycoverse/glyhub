# Source-only rebuild of the user-authorized -1 -> NA convention.
args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) == 2L)
evidence <- normalizePath(args[1], mustWork = TRUE)
cache <- args[2]
source("data-raw/noncptac/convert.R")
source("data-raw/noncptac/register.R")
path <- file.path(evidence, "41467_2022_35172_MOESM6_ESM.xlsx")
sha <- digest::digest(file = path, algo = "sha256")
stopifnot(
  sha == "1778bec72de7eb087cb4f3fe1a9419a032c9ae6bd766eddd5c4724cfa7e7da7e"
)
d <- as.data.frame(readxl::read_excel(
  path,
  sheet = "Intact glycopeptides-original"
))
samples <- c(paste0("97L-", 1:4), paste0("Hep3B-", 1:4), paste0("LM3-", 1:4))
stopifnot(nrow(d) == 11001L, identical(names(d)[4:15], samples))
raw <- as.matrix(d[4:15])
stopifnot(
  !anyNA(raw),
  all(is.finite(raw)),
  all(raw >= 0 | raw == -1),
  sum(raw == -1) == 40338L,
  sum(raw == 0) == 2137L
)
ids <- sprintf("MSV000089484_%05d", seq_len(nrow(d)))
rownames(raw) <- ids
mask <- raw == -1
abundance <- raw
abundance[mask] <- NA_real_
stopifnot(
  identical(is.na(abundance), mask),
  identical(abundance[!mask], raw[!mask])
)
counts <- t(vapply(
  strsplit(gsub("[\\[\\]]", "", d[[3]], perl = TRUE), "[[:space:]]+"),
  function(z) as.integer(z[nzchar(z)]),
  integer(5)
))
stopifnot(!anyNA(counts), all(counts >= 0), all(counts[, 5] == 0))
labels <- apply(counts[, 1:4, drop = FALSE], 1, function(z) {
  paste0(
    c("Hex", "HexNAc", "NeuAc", "dHex")[z > 0],
    "(",
    z[z > 0],
    ")",
    collapse = ""
  )
})
rd <- S4Vectors::DataFrame(
  protein = sub("^[^|]*\\|([^|]+)\\|.*", "\\1", d[[1]]),
  protein_site = as.integer(d[[2]]),
  source_protein = d[[1]],
  source_composition = d[[3]],
  row.names = ids
)
stopifnot(all(d[[2]] == rd$protein_site), all(rd$protein_site > 0))
rd$glycan_composition <- noncptac_compositions(labels)
cd <- S4Vectors::DataFrame(
  source_sample = samples,
  cell_line = rep(c("MHCC97L", "Hep3B", "MHCCLM3"), each = 4),
  silac_label = rep(c("K0R0", "K4R6", "K8R10"), each = 4),
  lc_ms_replicate = rep(1:4, 3),
  replicate_type = "LC-MS replicate index; independent biological replication not established",
  row.names = samples
)
x <- glyexp::GlycoproteomicSE(
  abundance,
  rowData = rd,
  colData = cd,
  metadata = list(
    glycan_type = "N",
    doi = "10.1038/s41467-022-35172-x",
    accession = "MSV000089484",
    source = "Kong et al. (2022), Supplementary Data 3, Intact glycopeptides-original",
    source_provenance = list(
      workbook_sha256 = sha,
      source_url = "https://media.springernature.com/original/springer-static/esm/art%3A10.1038%2Fs41467-022-35172-x/MediaObjects/41467_2022_35172_MOESM6_ESM.xlsx",
      sheet = "Intact glycopeptides-original",
      source_range = "D2:O11002",
      retrieved = "2026-10-17",
      glycan_dictionary = "Official pGlycoQuant v202211 glyco.ini: H/N/A/F/pH = Hex/HexNAc/NeuAc/dHex/phosphoHex; pH counts are all zero"
    ),
    license = "Article CC BY 4.0; attachment applicability not independently confirmed; no new license granted",
    article_license = "CC BY 4.0",
    publication = list(
      source_license_status = "unresolved-for-complete-object",
      authorization = "User requested inclusion and publication with explicit -1 missing-value convention; source-license scope is not newly established"
    ),
    curation_status = "User-confirmed -1 missing-value convention; author definition not located",
    assay_scale = "Source SILAC glycoform-site intensity; -1 mapped to NA by user-confirmed curation convention",
    raw_abundance = raw,
    raw_abundance_scale = "Original source intensity including exact -1 codes",
    source_row = seq_len(nrow(d)) + 1L,
    source_measurement_columns = 4:15,
    missing_value_convention = list(
      source_code = -1,
      target = "NA",
      authority = "User-confirmed curation decision, not an author-confirmed definition",
      converted_cells = sum(mask),
      retained_zero_cells = sum(raw == 0)
    ),
    processing_masks = list(source_minus_one = mask, source_zero = raw == 0),
    processing = c(
      "Exactly 40338 source -1 entries mapped to assay NA by explicit user instruction; the author has not directly defined this code in inspected sources",
      "Original -1 entries and every source value remain in metadata raw_abundance",
      "All 2137 zeros and every positive intensity preserved exactly; no log transform, normalization, imputation or filtering",
      "One record per source protein/site/glycan row; no invented peptide sequence or PSM",
      "The 6435-row filtered sheet is not a separate dataset or cohort",
      "Repeat labels do not establish independent biological replication"
    )
  )
)
register(x, "glyhub_MSV000089484_N_HCC", compression = "gzip")
name <- "glyhub_MSV000089484_N_HCC"
for (mp in c("inst/extdata/manifest.tsv", "data-raw/noncptac/manifest.tsv")) {
  m <- read.delim(mp, stringsAsFactors = FALSE)
  i <- m$dataset == name
  m$storage[i] <- "release"
  m$version[i] <- "data-v0.1.0"
  m$url[i] <- paste0(
    "https://github.com/glycoverse/glyhub/releases/download/data-v0.1.0/",
    m$filename[i]
  )
  write.table(m, mp, sep = "\t", quote = FALSE, row.names = FALSE, na = "")
}
y <- readRDS(file.path("data-raw/noncptac/assets", paste0(name, ".rds")))
a <- SummarizedExperiment::assay(y)
stopifnot(
  identical(x, y),
  identical(is.na(a), mask),
  identical(a[!mask], raw[!mask]),
  identical(S4Vectors::metadata(y)$raw_abundance, raw)
)
result <- list(
  dimensions = dim(a),
  source_cells_compared = length(raw),
  source_values_exact_in_metadata = TRUE,
  retained_nonnegative_values_exact = TRUE,
  minus_one_to_NA = sum(mask),
  zero_retained = sum(a == 0, na.rm = TRUE),
  sha256 = digest::digest(
    file = file.path("data-raw/noncptac/assets", paste0(name, ".rds")),
    algo = "sha256"
  )
)
jsonlite::write_json(
  result,
  "data-raw/noncptac/pglyco-validation.json",
  pretty = TRUE,
  auto_unbox = TRUE
)

receipt_path <- file.path("data-raw/noncptac", paste0(name, "-receipt.json"))
receipt <- jsonlite::fromJSON(receipt_path, simplifyVector = FALSE)
receipt$manifest <- m[m$dataset == name, ]
receipt$missing_value_authority <- "User-confirmed convention; not an author definition"
jsonlite::write_json(receipt, receipt_path, pretty = TRUE, auto_unbox = TRUE)
