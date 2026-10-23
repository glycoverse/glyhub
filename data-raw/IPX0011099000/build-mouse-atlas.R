# New 154-run atlas, not the existing 60-run PD/AD brain cohort.
args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) == 2L)
cache <- args[2]
source("data-raw/_shared/scripts/noncptac/register-literature.R")
spec <- jsonlite::fromJSON("data-raw/IPX0011099000/mouse-atlas-source.json")
path <- file.path(args[1], spec$local_file)
annotation_path <- file.path(args[1], spec$metadata_local_file)
stopifnot(
  identical(digest::digest(file = path, algo = "sha256"), spec$source_sha256),
  identical(
    digest::digest(file = annotation_path, algo = "sha256"),
    spec$metadata_sha256
  )
)
d <- as.data.frame(readxl::read_excel(
  path,
  sheet = spec$sheet,
  range = "A1:EY40467",
  .name_repair = "minimal"
))
stopifnot(
  nrow(d) == 40466L,
  ncol(d) == 155L,
  !anyDuplicated(d[[1]]),
  identical(names(d)[-1], spec$sample_ids)
)
a <- as.matrix(d[-1])
stopifnot(
  is.numeric(a),
  all(is.finite(a)),
  all(a >= 0),
  sum(a == 0) == 5938146L
)
ids <- sprintf("IPX0011099000_MouseAtlas_precursor_%05d", seq_len(nrow(d)))
dimnames(a) <- list(ids, spec$sample_ids)
rd <- S4Vectors::DataFrame(
  source_precursor_id = d[[1]],
  protein = rep(NA_character_, nrow(d)),
  protein_site = rep(NA_integer_, nrow(d)),
  source_row = seq_len(nrow(d)) + 1L,
  row.names = ids
)
rd$glycan_composition <- rep(glyrepr::glycan_composition(NA), nrow(d))
parts <- strsplit(d[[1]], "+", fixed = TRUE)
parsed <- lengths(parts) >= 5L
field <- function(index) {
  vapply(
    parts,
    function(value) {
      if (length(value) >= 5L) value[index] else NA_character_
    },
    character(1)
  )
}
rd$source_protein <- field(1L)
rd$source_site <- field(2L)
rd$source_peptide <- field(3L)
rd$source_composition <- field(4L)
rd$source_charge <- field(5L)
rd$source_precursor_components_parsed <- parsed
single <- parsed &
  !is.na(rd$source_protein) &
  grepl("^(sp|tr)\\|[^|;]+\\|[^;]+$", rd$source_protein) &
  !is.na(rd$source_site) &
  grepl("^[0-9]+$", rd$source_site)
rd$protein[single] <- sub(
  "^(sp|tr)\\|([^|]+)\\|.*$",
  "\\2",
  rd$source_protein[single]
)
rd$protein_site[single] <- as.integer(rd$source_site[single])
stopifnot(identical(spec$sample_mapping$sample_id, spec$sample_ids))
cd <- S4Vectors::DataFrame(
  spec$sample_mapping,
  row.names = spec$sample_ids,
  check.names = FALSE
)
cd$species <- "Mus musculus"
cd$replicate_type <- "source LC-MS/MS run; biological independence not established"
x <- glyexp::GlycoproteomicSE(
  a,
  rowData = rd,
  colData = cd,
  metadata = list(
    accession = "IPX0011099000",
    doi = spec$doi,
    glycan_type = "N",
    source_repository = "iProX",
    source = paste(spec$local_file, spec$sheet),
    source_provenance = spec,
    license = spec$license,
    license_url = "https://creativecommons.org/publicdomain/zero/1.0/",
    assay_scale = "author total-intensity-normalized log2 matrix with author-filled zeros; not raw intensity",
    feature_grain = spec$feature_level,
    raw_abundance = a,
    source_row = rd$source_row,
    source_measurement_columns = 2:155,
    processing_masks = list(source_missing = is.na(a), source_zero = a == 0),
    processing = c(
      spec$assay_semantics,
      spec$sample_design,
      spec$existing_object_comparison,
      "Full source precursor IDs retained; direct component strings extracted, single explicit protein/site mappings only",
      "Source composition notation retained without an unverified token dictionary or inferred structures",
      "No additional zero filling, conversion to NA, normalization or exponentiation",
      "The source's protein/glycan aggregate sheets are alternative levels of this cohort, not new independent datasets"
    )
  )
)
original <- as.matrix(readxl::read_excel(
  path,
  sheet = spec$sheet,
  range = spec$quant_range,
  col_names = FALSE,
  .name_repair = "minimal"
))
stopifnot(
  identical(as.numeric(original), as.numeric(SummarizedExperiment::assay(x))),
  methods::validObject(x)
)
register_literature(
  x,
  "glyhub_IPX0011099000_N_MouseTissueAtlas",
  "Mouse tissue atlas source precursor abundance across 154 LC-MS/MS runs",
  c(
    spec$sample_design,
    spec$assay_semantics,
    spec$existing_object_comparison,
    "Source tissue, enzyme and enrichment labels are matched exactly from the author's run table.",
    "154 runs must not be interpreted as 154 independent animals; source-zero provenance is not reconstructed."
  )
)
jsonlite::write_json(
  list(
    dimensions = dim(x),
    source_cells_compared = length(original),
    source_values_exact = TRUE,
    source_zero = sum(original == 0),
    source_sha256 = spec$source_sha256,
    sample_mapping_count = nrow(cd),
    valid_object = TRUE
  ),
  "data-raw/IPX0011099000/mouse-atlas-validation.json",
  pretty = TRUE,
  auto_unbox = TRUE
)
