# Rscript data-raw/PXD031071/build.R /path/to/emt_files /path/to/cache
args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) == 2L)
cache <- args[2]
source("data-raw/_shared/scripts/noncptac/register-literature.R")
spec <- jsonlite::fromJSON("data-raw/PXD031071/source.json")
path <- file.path(args[1], spec$local_file)
stopifnot(identical(digest::digest(file = path, algo = "sha256"), spec$sha256))
header <- as.data.frame(readxl::read_excel(path, sheet = "GLYCO", range = "B2:AE2",
  col_names = FALSE, .name_repair = "minimal"))
stopifnot(identical(as.character(unlist(header)), spec$sample_ids))
d <- as.data.frame(readxl::read_excel(path, sheet = "GLYCO", range = "A3:AE551",
  col_names = FALSE, .name_repair = "minimal"))
genes <- d[[1]]
a <- as.matrix(d[-1])
stopifnot(identical(dim(a), c(549L, 30L)), !anyDuplicated(genes), !anyNA(genes),
  is.numeric(a), all(is.finite(a)), all(a >= 0))
ids <- sprintf("PXD031071_gene_%04d", seq_along(genes))
dimnames(a) <- list(ids, spec$sample_ids)
rd <- S4Vectors::DataFrame(source_gene = genes, protein = rep(NA_character_, 549L),
  protein_site = rep(NA_integer_, 549L), source_row = 3:551, row.names = ids)
rd$glycan_composition <- rep(glyrepr::glycan_composition(NA), 549L)
cd <- S4Vectors::DataFrame(source_sample = spec$sample_ids,
  time_hours = spec$time_hours, source_biological_replicate = spec$biological_replicate,
  replicate_type = "biological", species = "Homo sapiens", cell_line = spec$cell_line,
  treatment = ifelse(spec$time_hours == 0, "baseline control", spec$treatment),
  row.names = spec$sample_ids)
x <- glyexp::GlycoproteomicSE(a, rowData = rd, colData = cd, metadata = list(
  accession = spec$accession, doi = spec$doi, glycan_type = "N",
  source = paste(spec$local_file, "GLYCO"), source_provenance = spec,
  attribution = paste("Original-author EMT surfaceome GLYCO measurements; doi:", spec$doi),
  license = spec$license_scope, license_url = spec$license_url,
  assay_scale = "author-processed log2 surfaceome expression; exact published processing stage unresolved",
  feature_grain = spec$feature_level, raw_abundance = a,
  source_measurement_columns = 2:31, source_row = 3:551,
  processing_masks = list(source_missing = is.na(a), source_zero = a == 0),
  processing = c(spec$assay_semantics, spec$author_imputation,
    "No additional normalization, imputation, filtering or inverse transformation",
    "Only gene-level source identifiers available; no UniProt, sequence, site or glycan identity inferred")
))
independent <- as.matrix(readxl::read_excel(path, sheet = "GLYCO",
  range = spec$quant_range, col_names = FALSE, .name_repair = "minimal"))
stopifnot(identical(as.numeric(independent), as.numeric(SummarizedExperiment::assay(x))),
  methods::validObject(x))
register_literature(x, "glyhub_PXD031071_N_Surfaceome",
  "MCF10A EMT gene-level N-enriched surfaceome expression", c(
    "Complete author GLYCO table: 549 genes and ten timepoints with three biological replicates each.",
    "This is protein-enriched surfaceome expression, not intact glycopeptide or glycosite quantification.",
    "Only source gene labels are supplied; protein accessions, sites and glycan compositions remain unknown.",
    "Authors describe log2 transformation, normalization and LLS imputation; the precise stage of this",
    "published sheet is unresolved. Values are retained without further processing and are not raw intensity."))
jsonlite::write_json(list(dimensions = dim(x), source_cells_compared = length(a),
  source_values_exact = TRUE, source_sha256 = spec$sha256, valid_object = TRUE),
  "data-raw/PXD031071/validation.json", auto_unbox = TRUE, pretty = TRUE)
