# Rscript data-raw/PXD036791/build.R /path/to/supplements /path/to/cache
args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) == 2L)
evidence <- normalizePath(args[1], mustWork = TRUE)
cache <- args[2]
source("data-raw/PXD036791/convert.R")
source("data-raw/_shared/scripts/noncptac/register-literature.R")
source("data-raw/_shared/scripts/noncptac/merge-experiments.R")
specs <- jsonlite::fromJSON(
  "data-raw/PXD036791/sources.json",
  simplifyVector = FALSE
)
specs <- lapply(specs, function(s) {
  for (key in c("measurement_columns", "annotation_columns")) {
    s[[key]] <- unlist(s[[key]])
  }
  s
})
path <- file.path(evidence, specs[[1]]$archive_member)
stopifnot(identical(
  digest::digest(file = path, algo = "sha256"),
  specs[[1]]$sha256
))
groups <- lapply(
  specs[!vapply(specs, function(s) grepl("secretome", s$sheet), logical(1))],
  list
)
groups[[length(groups) + 1L]] <- specs[vapply(
  specs,
  function(s) grepl("secretome", s$sheet),
  logical(1)
)]
validation <- list()
experiments <- identities <- list()
identity_fields <- c(
  "Identifier",
  "Accessions",
  "GlycoSite",
  "GlyNum",
  "GlycanType",
  "Sequence",
  "Modi",
  "Theo MHplus in Da"
)
for (group in groups) {
  secretome <- length(group) == 2L
  x <- pxd036791_convert(path, group, secretome)
  id <- if (secretome) {
    "Secretome_GALNT1_GALNT2"
  } else {
    sub("^∆", "", sub("_Glycoproteome$", "", group[[1]]$sheet))
  }
  name <- paste0("glyhub_PXD036791_O_", id)
  # Independent re-read of every original assay cell; no converter objects reused.
  aa <- lapply(seq_along(group), function(i) {
    d <- as.data.frame(readxl::read_excel(
      path,
      sheet = group[[i]]$sheet,
      na = c("", "NA"),
      .name_repair = "minimal"
    ))
    columns <- group[[i]]$measurement_columns
    if (i == 2L) {
      columns <- columns[3:4]
    }
    as.matrix(d[columns])
  })
  original <- do.call(cbind, aa)
  stopifnot(identical(
    as.numeric(original),
    as.numeric(SummarizedExperiment::assay(x))
  ))
  if (!secretome) {
    experiments[[id]] <- x
    identities[[id]] <- S4Vectors::metadata(x)$source_tables[[1]][
      identity_fields
    ]
    next
  }
  register_literature(
    x,
    name,
    paste("N/TERT-1", id, "O-glycopeptide reporter abundance"),
    c(
      "Author site-associated glycopeptide rows, with full source TMT6plex measurements.",
      "A multisite peptide's signal is copied by the authors to its constituent sites;",
      "those rows are not independent quantified sites. Source T/Tn labels are retained.",
      if (secretome) {
        "One shared GALNT1/GALNT2 secretome experiment, with WT channels retained only once."
      } else {
        "One independent total-cell-lysate experiment. WT technical replicates and distinct KO clones have different replicate roles."
      }
    )
  )
  validation[[name]] <- list(
    dimensions = dim(x),
    source_sha256 = group[[1]]$sha256,
    source_cells_compared = length(original),
    source_values_exact = TRUE,
    missing = sum(is.na(original)),
    zero = sum(original == 0, na.rm = TRUE),
    valid_object = methods::validObject(x),
    shared_wt_retained_once = secretome
  )
}
x <- merge_literature_experiments(
  experiments,
  identities,
  "PXD036791_GALNT_TCL"
)
rd <- SummarizedExperiment::rowData(x)
md <- S4Vectors::metadata(x)
rd$source_theoretical_mhplus <- md$alignment_identity_table[[
  "Theo MHplus in Da"
]]
rd$source_gene_conflict <- grepl(
  "(^|;)source_gene(;|$)",
  rd$source_annotation_conflict_fields
)
source_identifiers <- md$alignment_identity_table$Identifier
counts <- table(source_identifiers)
rd$source_identifier_variant_count <- as.integer(counts[source_identifiers])
SummarizedExperiment::rowData(x) <- rd
SummarizedExperiment::colData(x)$knockout <- ifelse(
  SummarizedExperiment::colData(x)$source_group == "WT",
  "none",
  sub("_KO$", "", SummarizedExperiment::colData(x)$source_group)
)
md$source <- "Supplementary Data 2; nine total-cell-lysate GALNT experiments"
md$feature_grain <- "Exact author site-associated peptide/modification/theoretical-mass annotation group; not an inferred unique glycan isomer"
md$processing <- c(
  md$processing,
  "Theoretical MH+ distinguishes reported mass variants; no mass-tolerance matching or chemical modification inferred",
  "Original gene conflicts are retained per experiment; merged source_gene is unknown where labels disagree",
  "Multisite peptide signals copied by authors to several sites remain separate flagged records"
)
S4Vectors::metadata(x) <- md
stopifnot(
  identical(dim(x), c(6789L, 54L)),
  sum(md$processing_masks$source_coverage) == 121872L,
  sum(md$processing_masks$structural_missing) == 244734L,
  sum(rd$source_gene_conflict) == 23L
)
name <- "glyhub_PXD036791_O_GALNT_TCL"
register_literature(
  x,
  name,
  "GALNT knockout total-cell-lysate O-glycopeptide experiments",
  c(
    "Nine source TMT sixplex experiments form a conservative feature union with 54 measurements.",
    "Exact peptide, site, glycan-label, modification and theoretical-mass identity is required; no mass-tolerance merging.",
    "Absent feature/experiment combinations are structural NA, not author missing values.",
    "Original experiments and row/column maps allow exact source round trips.",
    "Retain separate WT measurements, KO clones, experiment and batch; no new interplex normalization.",
    "Gene-label conflicts become unknown in the shared row annotation, with all original labels retained.",
    "Multisite signals copied by the authors are not independent site quantifications; secretome remains separate."
  )
)
retire_staged_experiments(
  paste0("glyhub_PXD036791_O_", names(experiments)),
  name,
  names(experiments),
  "data-raw/PXD036791/merged-resource-map.json"
)
validation[[name]] <- list(
  dimensions = dim(x),
  identity_fields = identity_fields,
  source_cells_compared = 121872L,
  structural_missing = 244734L,
  gene_annotation_conflicts = 23L,
  source_values_exact = TRUE,
  source_missing = sum(md$processing_masks$source_missing),
  source_zero = sum(md$processing_masks$source_zero),
  valid_object = methods::validObject(x)
)
jsonlite::write_json(
  validation,
  "data-raw/PXD036791/validation.json",
  pretty = TRUE,
  auto_unbox = TRUE
)
