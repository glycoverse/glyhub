m <- read.delim(
  'data-raw/_shared/noncptac/manifest.tsv',
  stringsAsFactors = FALSE
)
titles <- c(
  glyhub_MSV000089484_N_HCC = "pGlycoQuant HCC cell-line source intensities",
  glyhub_PXD052447_N_Tissues = 'DQGlyco mouse tissue reporter intensities',
  glyhub_PXD052447_N_Solubility = 'DQGlyco mouse brain solubility reporter intensities',
  glyhub_PXD052447_N_TwoFF = 'DQGlyco 2-fluorofucose time course reporter intensities',
  glyhub_PXD052447_N_Microbiome = 'DQGlyco microbiome experiment reporter intensities',
  glyhub_PXD052447_N_PNGase = 'DQGlyco PNGase accessibility reporter intensities',
  glyhub_PXD052447_N_ProteinaseK = 'DQGlyco proteinase K accessibility reporter intensities',
  glyhub_IPX0011099000_N_Brain = 'Mouse brain Glyco-Decipher chromatographic areas',
  glyhub_PXD065283_N_QC = 'HCC study quality-control injections',
  glyhub_PXD065283_N_DiscoverySelected = 'HCC discovery cohort selected processed features',
  glyhub_PXD011063_O_SerumSA = 'Glyco-DIA SA serum source precursor peak areas',
  glyhub_PXD011063_O_Dilution = 'Glyco-DIA precursor peak areas in a dilution experiment',
  glyhub_PXD070547_N_HumanAtlas = 'Human organ atlas raw XIC matrix',
  glyhub_PXD046637_N_Lung = 'Paired lung nodule glycoproteomics'
)
text <- character()
audit <- list()
for (i in seq_len(nrow(m))) {
  e <- m[i, ]
  x <- readRDS(file.path('data-raw/_shared/noncptac/assets', e$filename))
  md <- S4Vectors::metadata(x)
  title <- titles[[e$dataset]]
  detail <- c(
    sprintf(
      '%s source feature rows across %s reported measurement columns.',
      format(nrow(x), big.mark = ','),
      ncol(x)
    ),
    paste('Assay scale:', md$assay_scale),
    if (!is.null(md$feature_grain)) paste('Feature grain:', md$feature_grain),
    if (!is.null(md$source_selection)) {
      paste('Source selection:', md$source_selection)
    },
    md$processing,
    'Measurement columns are not automatically independent biological samples. Source row identifiers, annotations and provenance are retained in metadata.',
    if (e$dataset == 'glyhub_MSV000089484_N_HCC') {
      'The assay maps source -1 to NA by user-confirmed convention, not an author-confirmed definition. All source values, including -1, remain in metadata raw_abundance; zeros and positive values are unchanged.'
    } else {
      'The assay preserves source numeric values. The metadata field raw_abundance means source numbers; it does not certify that the authors supplied unprocessed intensity.'
    }
  )
  if (grepl('PXD052447', e$dataset)) {
    detail <- c(
      detail,
      'All deposited PSM rows are retained, including rows without a glycan annotation. All source reporter channels are retained; unmapped channels have unknown sample roles. Consult sample_annotation_matched before comparing biological groups.'
    )
  }
  if (e$dataset == 'glyhub_PXD011063_O_Dilution') {
    detail <- c(
      detail,
      'Source decoys are retained and flagged; this is an unfiltered source-report representation, not a confidence-filtered biological feature set.'
    )
  }
  if (e$dataset == 'glyhub_PXD011063_O_SerumSA') {
    detail <- c(
      detail,
      'Only the SA source file is included, across six reported runs. The deSA source CSV contains independently confirmed embedded NUL bytes and an unparsable quantitative record; it is excluded, not repaired or filtered. All source decoys are retained and flagged. Biological independence and exact glycan compositions remain unassigned.'
    )
  }
  roxy <- c(
    paste0("#' ", title),
    "#'",
    "#' @details",
    unlist(lapply(detail, function(t) {
      c(paste0("#' ", strwrap(t, width = 85)), "#'")
    })),
    if (e$storage == "release" && grepl("CC0-1.0", md$license, fixed = TRUE)) {
      c(
        "#' @section Availability and source license:",
        "#' Downloaded from the existing data release through the verified cache.",
        "#' Deposited PRIDE source data are CC0-1.0, explicitly declared in the project API.",
        "#' Cite the original authors and accession; see metadata redistribution and source provenance."
      )
    } else {
      c(
        "#' @section Availability and source license:",
        "#' Downloaded from the existing data release through the verified cache.",
        "#' Source-license scope for the complete object remains unresolved; no new license is granted.",
        "#' See publication-decisions.tsv and object metadata for original sources and limitations."
      )
    },
    paste0("#' @source <https://doi.org/", md$doi, ">."),
    "#' @inheritParams glyhub_load",
    "#' @return A [glyexp::GlycoproteomicSE].",
    "#' @seealso [glyhub_catalog()], [glyhub_data_conventions]",
    "#' @export"
  )
  body <- c(
    paste0(e$dataset, ' <- function(kind = c("curated", "raw"),'),
    '  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),',
    '  refresh = FALSE, offline = FALSE) {',
    paste0(
      '  glyhub_load("',
      e$dataset,
      '", kind, cache_dir, refresh, offline)'
    ),
    '}',
    ''
  )
  text <- c(text, roxy, body)
  audit[[e$dataset]] <- list(
    dataset = e$dataset,
    features = nrow(x),
    measurements = ncol(x),
    assay_scale = md$assay_scale,
    raw_abundance_scale = md$raw_abundance_scale,
    source_selection = md$source_selection,
    processing = md$processing,
    source_provenance = md$source_provenance,
    source = md$source,
    doi = md$doi,
    missing_typed_compositions = sum(is.na(
      SummarizedExperiment::rowData(x)$glycan_composition
    )),
    sample_annotation_matched = if (
      'sample_annotation_matched' %in% names(SummarizedExperiment::colData(x))
    ) {
      sum(SummarizedExperiment::colData(x)$sample_annotation_matched)
    } else {
      NULL
    },
    license = md$license,
    asset_sha256 = e$sha256
  )
  rm(x)
  gc()
}
writeLines(text, 'R/noncptac.R')
if (file.exists('R/noncptac-additional.R')) {
  unlink('R/noncptac-additional.R')
}
jsonlite::write_json(
  audit,
  'data-raw/_shared/noncptac/source-selection.json',
  pretty = TRUE,
  auto_unbox = TRUE
)
table <- do.call(
  rbind,
  lapply(audit, function(a) {
    data.frame(
      dataset = a$dataset,
      features = a$features,
      measurements = a$measurements,
      assay_scale = a$assay_scale,
      source_selection = if (is.null(a$source_selection)) {
        'See source methods and candidate audit'
      } else {
        a$source_selection
      },
      source_url = a$source_provenance$source_url,
      asset_sha256 = a$asset_sha256
    )
  })
)
write.table(
  table,
  'data-raw/_shared/noncptac/source-selection.tsv',
  sep = '\t',
  quote = TRUE,
  row.names = FALSE
)
pkg <- readLines('_pkgdown.yml')
i <- which(
  pkg %in%
    c(
      '- title: DQGlyco mouse tissues',
      '- title: Non-CPTAC local candidates',
      '- title: Non-CPTAC datasets'
    )
)[1]
stopifnot(length(i) == 1L, !is.na(i))
pkg <- c(
  pkg[seq_len(i - 1)],
  '- title: Non-CPTAC datasets',
  '  contents:',
  paste0('  - ', m$dataset)
)
writeLines(pkg, '_pkgdown.yml')
