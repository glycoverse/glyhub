args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) == 2L)
cache <- args[2]
source("data-raw/_shared/scripts/noncptac/register-literature.R")
source("data-raw/_shared/scripts/noncptac/convert-feature-source.R")
source("data-raw/_shared/scripts/noncptac/merge-experiments.R")
experiments <- identities <- list()
old_names <- character()
for (spec0 in jsonlite::fromJSON("data-raw/PXD017033/feature-sources.json", simplifyVector = FALSE)) {
 spec <- jsonlite::fromJSON(jsonlite::toJSON(spec0, auto_unbox = TRUE, null = "null"))
 if (is.list(spec$read_range)) spec$read_range <- NULL
 path <- file.path(args[1], spec$local_file)
 stopifnot(identical(digest::digest(file = path, algo = "sha256"), spec$sha256))
 x <- literature_feature_source(path, spec)
 stopifnot(methods::validObject(x))
 id <- sub("^glyhub_PXD017033_N_", "", spec$dataset)
 experiments[[id]] <- x
 identities[[id]] <- S4Vectors::metadata(x)$source_table[1:10]
 old_names <- c(old_names, spec$dataset)
}
x <- merge_literature_experiments(experiments, identities, "PXD017033_HGF")
SummarizedExperiment::colData(x)$source_sheet <- rep(vapply(experiments,
  function(y) S4Vectors::metadata(y)$source_provenance$sheet, character(1)), each = 6L)
SummarizedExperiment::colData(x)$source_measurement_column <- unlist(lapply(experiments,
  function(y) S4Vectors::metadata(y)$source_measurement_columns), use.names = FALSE)
md <- S4Vectors::metadata(x)
md$source <- "Complete SMMC-7721 and HepG2 author HGF reporter-intensity tables"
md$feature_grain <- "Exact author intact-glycopeptide annotation group, not a confirmed charge-specific precursor or unique isomer"
md$processing <- c(md$processing,
  "Each cell-line/timepoint is one measured pool of three biological replicates; not three independent reporter measurements",
  "Cell-line TMT experiments remain separate batches; no interplex normalization",
  "Source structure/composition conflicts and dehydrated-composition unknowns remain unresolved; no topology selected")
S4Vectors::metadata(x) <- md
stopifnot(identical(dim(x), c(2318L, 12L)),
  sum(md$processing_masks$source_coverage) == 18936L,
  sum(md$processing_masks$structural_missing) == 8880L,
  sum(SummarizedExperiment::rowData(x)$source_structure_composition_conflict) == 7L,
  sum(is.na(SummarizedExperiment::rowData(x)$glycan_composition)) == 28L)
name <- "glyhub_PXD017033_N_HGFTimecourse"
register_literature(x, name, "HGF time-course glycopeptide reporter intensities in two cell lines",
  c("Complete SMMC-7721 and HepG2 TMT reporter experiments joined only on all ten exact author feature annotations.",
    "Cell-line and batch are explicit; six timepoints per cell line are six measured pools, each from three biological replicates.",
    "Structural NA denotes features absent from one source table; author zeros and missingness are independently retained.",
    "Original experiments, PSM counts, alternative processed columns and exact row/column maps remain available in metadata.",
    "Seven source annotation conflicts retain both source labels and unknown canonical composition; no topology is inferred.",
    "No interplex normalization, imputation, filtering or additional value transformation."))
retire_staged_experiments(old_names, name, names(experiments),
  "data-raw/PXD017033/merged-resource-map.json", selector_column = "cell_line",
  selector_values = c("SMMC-7721", "HepG2"))
jsonlite::write_json(list(dataset = name, dimensions = dim(x),
  identity_fields = names(identities[[1]]), source_cells_compared = 18936L,
  structural_missing = 8880L, source_values_exact = TRUE,
  source_zero = sum(md$processing_masks$source_zero),
  canonical_composition_unknown = 28L, source_annotation_conflicts = 7L,
  valid_object = methods::validObject(x)), "data-raw/PXD017033/merge-validation.json",
  pretty = TRUE, auto_unbox = TRUE)
