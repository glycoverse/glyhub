#' Human organ atlas raw XIC matrix
#'
#' @details
#' 57,884 source feature rows across 219 reported measurement columns.
#'
#' Assay scale: Source Skyline extracted-ion chromatogram quantification; raw relative
#' signal
#'
#' Explicit source NA strings and blanks -> NA; no imputation, normalization,
#' filtering, zero conversion or aggregation
#'
#' Annotation joined only by exact ID: unmatched source rows retained with unknown
#' molecular annotation
#'
#' Source linkage notation retained, no unverified structure parser or inferred linkage
#'
#' S monosaccharide is unspecified sialic acid; sialylated typed compositions remain NA
#'
#' Source age/sex cells are cohort summaries, not person-level values; not propagated
#' to samples
#'
#' Use original measured columns, not the normalized or KNN/ComBat matrices
#'
#' Measurement columns are not automatically independent biological samples. Source row
#' identifiers, annotations and provenance are retained in metadata.
#'
#' The assay preserves source numeric values. The metadata field raw_abundance means
#' source numbers; it does not certify that the authors supplied unprocessed intensity.
#'
#' @section Availability and source license:
#' Downloaded from the existing data release through the verified cache.
#' Source-license scope for the complete object remains unresolved; no new license is granted.
#' See publication-decisions.tsv and object metadata for original sources and limitations.
#' @source <https://doi.org/10.1038/s41467-026-74631-7>.
#' @inheritParams glyhub_load
#' @return A [glyexp::GlycoproteomicSE].
#' @seealso [glyhub_catalog()], [glyhub_data_conventions]
#' @export
glyhub_PXD070547_N_HumanAtlas <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  glyhub_load(
    "glyhub_PXD070547_N_HumanAtlas",
    kind,
    cache_dir,
    refresh,
    offline
  )
}

#' DQGlyco mouse brain solubility reporter intensities
#'
#' @details
#' 89,115 source feature rows across 18 reported measurement columns.
#'
#' Assay scale: Deposited untransformed PSM-level TMT reporter intensities
#'
#' Feature grain: PSM; all deposited rows retained, including rows without glycan
#' annotation
#'
#' Source selection: Deposited reporter intensities preferred over normalized
#' supplementary glycopeptide matrices or ratios
#'
#' No normalization, logarithm, imputation, filtering, aggregation or zero conversion
#'
#' Source blanks are NA; numeric zero retained with no interpretation of its
#' missingness semantics
#'
#' All 18 deposited reporter channels retained; unmatched channel roles remain unknown
#'
#' PSM counts are not counts of unique glycopeptides; no peptide-level aggregation
#' performed
#'
#' Protein sites are not inferred from peptide coordinates; original search annotations
#' are retained
#'
#' Source search/FDR and reporter extraction precede this deposit; any undocumented
#' upstream correction remains unknown
#'
#' Measurement columns are not automatically independent biological samples. Source row
#' identifiers, annotations and provenance are retained in metadata.
#'
#' The assay preserves source numeric values. The metadata field raw_abundance means
#' source numbers; it does not certify that the authors supplied unprocessed intensity.
#'
#' All deposited PSM rows are retained, including rows without a glycan annotation. All
#' source reporter channels are retained; unmapped channels have unknown sample roles.
#' Consult sample_annotation_matched before comparing biological groups.
#'
#' @section Availability and source license:
#' Downloaded from the existing data release through the verified cache.
#' Deposited PRIDE source data are CC0-1.0, explicitly declared in the project API.
#' Cite the original authors and accession; see metadata redistribution and source provenance.
#' @source <https://doi.org/10.1038/s41594-025-01485-w>.
#' @inheritParams glyhub_load
#' @return A [glyexp::GlycoproteomicSE].
#' @seealso [glyhub_catalog()], [glyhub_data_conventions]
#' @export
glyhub_PXD052447_N_Solubility <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  glyhub_load(
    "glyhub_PXD052447_N_Solubility",
    kind,
    cache_dir,
    refresh,
    offline
  )
}

#' HCC study quality-control injections
#'
#' @details
#' 8,030 source feature rows across 30 reported measurement columns.
#'
#' Assay scale: Source linear MBR-derived glycosite/glycan quantities; upstream
#' normalization not independently established
#'
#' Source selection: Linear QC matrix chosen; clinical DE-selected log2 table is a
#' separate cohort dataset.
#'
#' All source cells preserved; no new normalization, imputation, filtering, inverse
#' transform or aggregation
#'
#' Source reports match-between-run quantification; source blank values retained as NA
#'
#' 30 QC injections (13 days, 3 repeated injections, 14 batch QC runs), not 30
#' independent people
#'
#' No exponentiation to claim recovered original intensity; unspecified upstream
#' settings remain unknown
#'
#' Measurement columns are not automatically independent biological samples. Source row
#' identifiers, annotations and provenance are retained in metadata.
#'
#' The assay preserves source numeric values. The metadata field raw_abundance means
#' source numbers; it does not certify that the authors supplied unprocessed intensity.
#'
#' @section Availability and source license:
#' Downloaded from the existing data release through the verified cache.
#' Source-license scope for the complete object remains unresolved; no new license is granted.
#' See publication-decisions.tsv and object metadata for original sources and limitations.
#' @source <https://doi.org/10.1002/advs.202516299>.
#' @inheritParams glyhub_load
#' @return A [glyexp::GlycoproteomicSE].
#' @seealso [glyhub_catalog()], [glyhub_data_conventions]
#' @export
glyhub_PXD065283_N_QC <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  glyhub_load("glyhub_PXD065283_N_QC", kind, cache_dir, refresh, offline)
}

#' HCC discovery cohort selected processed features
#'
#' @details
#' 1,038 source feature rows across 140 reported measurement columns.
#'
#' Assay scale: Source median-normalized, log2-transformed, normally imputed abundance;
#' DE-selected features
#'
#' Source selection: Only verified public individual clinical matrix; earliest
#' unnormalized clinical table unavailable through inspected sources. QC linear table
#' is a different experiment, not a substitute for clinical samples.
#'
#' All source cells preserved; no new normalization, imputation, filtering, inverse
#' transform or aggregation
#'
#' Source workflow: MBR, source missingness filtering, median normalization, log2,
#' normal-distribution interpolation, then differential-feature selection (p<=0.01 and
#' absolute log2FC>=1)
#'
#' 1038 selected features and 140 discovery samples; not the full 8902-feature matrix
#' or 60-person validation cohort. Feature selection uses case labels; unsuitable for
#' unbiased discovery or classifier performance estimates.
#'
#' No exponentiation to claim recovered original intensity; unspecified upstream
#' settings remain unknown
#'
#' Measurement columns are not automatically independent biological samples. Source row
#' identifiers, annotations and provenance are retained in metadata.
#'
#' The assay preserves source numeric values. The metadata field raw_abundance means
#' source numbers; it does not certify that the authors supplied unprocessed intensity.
#'
#' @section Availability and source license:
#' Downloaded from the existing data release through the verified cache.
#' Source-license scope for the complete object remains unresolved; no new license is granted.
#' See publication-decisions.tsv and object metadata for original sources and limitations.
#' @source <https://doi.org/10.1002/advs.202516299>.
#' @inheritParams glyhub_load
#' @return A [glyexp::GlycoproteomicSE].
#' @seealso [glyhub_catalog()], [glyhub_data_conventions]
#' @export
glyhub_PXD065283_N_DiscoverySelected <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  glyhub_load(
    "glyhub_PXD065283_N_DiscoverySelected",
    kind,
    cache_dir,
    refresh,
    offline
  )
}

#' DQGlyco 2-fluorofucose time course reporter intensities
#'
#' @details
#' 91,409 source feature rows across 18 reported measurement columns.
#'
#' Assay scale: Deposited untransformed PSM-level TMT reporter intensities
#'
#' Feature grain: PSM; all deposited rows retained, including rows without glycan
#' annotation
#'
#' Source selection: Deposited reporter intensities preferred over normalized
#' supplementary glycopeptide matrices or ratios
#'
#' No normalization, logarithm, imputation, filtering, aggregation or zero conversion
#'
#' Source blanks are NA; numeric zero retained with no interpretation of its
#' missingness semantics
#'
#' All 18 deposited reporter channels retained; unmatched channel roles remain unknown
#'
#' PSM counts are not counts of unique glycopeptides; no peptide-level aggregation
#' performed
#'
#' Protein sites are not inferred from peptide coordinates; original search annotations
#' are retained
#'
#' Source search/FDR and reporter extraction precede this deposit; any undocumented
#' upstream correction remains unknown
#'
#' Measurement columns are not automatically independent biological samples. Source row
#' identifiers, annotations and provenance are retained in metadata.
#'
#' The assay preserves source numeric values. The metadata field raw_abundance means
#' source numbers; it does not certify that the authors supplied unprocessed intensity.
#'
#' All deposited PSM rows are retained, including rows without a glycan annotation. All
#' source reporter channels are retained; unmapped channels have unknown sample roles.
#' Consult sample_annotation_matched before comparing biological groups.
#'
#' @section Availability and source license:
#' Downloaded from the existing data release through the verified cache.
#' Deposited PRIDE source data are CC0-1.0, explicitly declared in the project API.
#' Cite the original authors and accession; see metadata redistribution and source provenance.
#' @source <https://doi.org/10.1038/s41594-025-01485-w>.
#' @inheritParams glyhub_load
#' @return A [glyexp::GlycoproteomicSE].
#' @seealso [glyhub_catalog()], [glyhub_data_conventions]
#' @export
glyhub_PXD052447_N_TwoFF <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  glyhub_load("glyhub_PXD052447_N_TwoFF", kind, cache_dir, refresh, offline)
}

#' DQGlyco microbiome experiment reporter intensities
#'
#' @details
#' 160,699 source feature rows across 18 reported measurement columns.
#'
#' Assay scale: Deposited untransformed PSM-level TMT reporter intensities
#'
#' Feature grain: PSM; all deposited rows retained, including rows without glycan
#' annotation
#'
#' Source selection: Deposited reporter intensities preferred over normalized
#' supplementary glycopeptide matrices or ratios
#'
#' No normalization, logarithm, imputation, filtering, aggregation or zero conversion
#'
#' Source blanks are NA; numeric zero retained with no interpretation of its
#' missingness semantics
#'
#' All 18 deposited reporter channels retained; unmatched channel roles remain unknown
#'
#' PSM counts are not counts of unique glycopeptides; no peptide-level aggregation
#' performed
#'
#' Protein sites are not inferred from peptide coordinates; original search annotations
#' are retained
#'
#' Source search/FDR and reporter extraction precede this deposit; any undocumented
#' upstream correction remains unknown
#'
#' Measurement columns are not automatically independent biological samples. Source row
#' identifiers, annotations and provenance are retained in metadata.
#'
#' The assay preserves source numeric values. The metadata field raw_abundance means
#' source numbers; it does not certify that the authors supplied unprocessed intensity.
#'
#' All deposited PSM rows are retained, including rows without a glycan annotation. All
#' source reporter channels are retained; unmapped channels have unknown sample roles.
#' Consult sample_annotation_matched before comparing biological groups.
#'
#' @section Availability and source license:
#' Downloaded from the existing data release through the verified cache.
#' Deposited PRIDE source data are CC0-1.0, explicitly declared in the project API.
#' Cite the original authors and accession; see metadata redistribution and source provenance.
#' @source <https://doi.org/10.1038/s41594-025-01485-w>.
#' @inheritParams glyhub_load
#' @return A [glyexp::GlycoproteomicSE].
#' @seealso [glyhub_catalog()], [glyhub_data_conventions]
#' @export
glyhub_PXD052447_N_Microbiome <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  glyhub_load(
    "glyhub_PXD052447_N_Microbiome",
    kind,
    cache_dir,
    refresh,
    offline
  )
}

#' Glyco-DIA precursor peak areas in a dilution experiment
#'
#' @details
#' 15,890 source feature rows across 10 reported measurement columns.
#'
#' Assay scale: Source FG.MS2TotalPeakArea; untransformed summed MS2 fragment
#' chromatographic peak area
#'
#' Feature grain: Library-specific precursor and source decoy flag; source decoys
#' retained and explicitly flagged
#'
#' Source selection: MS2TotalPeakArea preferred over FG.Quantity, EG.TotalQuantity and
#' supplementary glycopeptide quantities; MS1PeakArea retained in metadata
#'
#' No normalization, log transform, imputation, zero conversion, confidence filtering
#' or aggregation
#'
#' Union of exact library/precursor/decoy keys; absent report rows become structural
#' NA, not zero
#'
#' Source decoy rows and unquantified or unidentified rows retained; use source flags
#' before biological inference
#'
#' Different libraries are alternative analyses, not independent biological samples
#'
#' No glycan composition inferred solely from rounded modification mass; source
#' modified sequence retained
#'
#' Spectronaut extraction, interference handling and upstream settings are not fully
#' recoverable from these exports
#'
#' Measurement columns are not automatically independent biological samples. Source row
#' identifiers, annotations and provenance are retained in metadata.
#'
#' The assay preserves source numeric values. The metadata field raw_abundance means
#' source numbers; it does not certify that the authors supplied unprocessed intensity.
#'
#' Source decoys are retained and flagged; this is an unfiltered source-report
#' representation, not a confidence-filtered biological feature set.
#'
#' @section Availability and source license:
#' Downloaded from the existing data release through the verified cache.
#' Deposited PRIDE source data are CC0-1.0, explicitly declared in the project API.
#' Cite the original authors and accession; see metadata redistribution and source provenance.
#' @source <https://doi.org/10.1038/s41592-019-0504-x>.
#' @inheritParams glyhub_load
#' @return A [glyexp::GlycoproteomicSE].
#' @seealso [glyhub_catalog()], [glyhub_data_conventions]
#' @export
glyhub_PXD011063_O_Dilution <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  glyhub_load("glyhub_PXD011063_O_Dilution", kind, cache_dir, refresh, offline)
}

#' DQGlyco mouse tissue reporter intensities
#'
#' @details
#' 205,904 source feature rows across 18 reported measurement columns.
#'
#' Assay scale: Deposited untransformed PSM-level TMT reporter intensities
#'
#' Feature grain: PSM; all deposited rows retained, including rows without glycan
#' annotation
#'
#' Source selection: Deposited reporter intensities preferred over normalized
#' supplementary glycopeptide matrices or ratios
#'
#' No normalization, logarithm, imputation, filtering, aggregation or zero conversion
#'
#' Source blanks are NA; numeric zero retained with no interpretation of its
#' missingness semantics
#'
#' All 18 deposited reporter channels retained; unmatched channel roles remain unknown
#'
#' PSM counts are not counts of unique glycopeptides; no peptide-level aggregation
#' performed
#'
#' Protein sites are not inferred from peptide coordinates; original search annotations
#' are retained
#'
#' Source search/FDR and reporter extraction precede this deposit; any undocumented
#' upstream correction remains unknown
#'
#' Measurement columns are not automatically independent biological samples. Source row
#' identifiers, annotations and provenance are retained in metadata.
#'
#' The assay preserves source numeric values. The metadata field raw_abundance means
#' source numbers; it does not certify that the authors supplied unprocessed intensity.
#'
#' All deposited PSM rows are retained, including rows without a glycan annotation. All
#' source reporter channels are retained; unmapped channels have unknown sample roles.
#' Consult sample_annotation_matched before comparing biological groups.
#'
#' @section Availability and source license:
#' Downloaded from the existing data release through the verified cache.
#' Deposited PRIDE source data are CC0-1.0, explicitly declared in the project API.
#' Cite the original authors and accession; see metadata redistribution and source provenance.
#' @source <https://doi.org/10.1038/s41594-025-01485-w>.
#' @inheritParams glyhub_load
#' @return A [glyexp::GlycoproteomicSE].
#' @seealso [glyhub_catalog()], [glyhub_data_conventions]
#' @export
glyhub_PXD052447_N_Tissues <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  glyhub_load("glyhub_PXD052447_N_Tissues", kind, cache_dir, refresh, offline)
}

#' DQGlyco PNGase accessibility reporter intensities
#'
#' @details
#' 118,216 source feature rows across 18 reported measurement columns.
#'
#' Assay scale: Deposited untransformed PSM-level TMT reporter intensities
#'
#' Feature grain: PSM; all deposited rows retained, including rows without glycan
#' annotation
#'
#' Source selection: Deposited reporter intensities preferred over normalized
#' supplementary glycopeptide matrices or ratios
#'
#' No normalization, logarithm, imputation, confidence filtering, aggregation or zero
#' conversion; acquisition partitions use explicit source Spectrum prefixes
#'
#' Source blanks are NA; numeric zero retained with no interpretation of its
#' missingness semantics
#'
#' All 18 deposited reporter channels retained; unmatched channel roles remain unknown
#'
#' PSM counts are not counts of unique glycopeptides; no peptide-level aggregation
#' performed
#'
#' Protein sites are not inferred from peptide coordinates; original search annotations
#' are retained
#'
#' Source search/FDR and reporter extraction precede this deposit; any undocumented
#' upstream correction remains unknown
#'
#' Measurement columns are not automatically independent biological samples. Source row
#' identifiers, annotations and provenance are retained in metadata.
#'
#' The assay preserves source numeric values. The metadata field raw_abundance means
#' source numbers; it does not certify that the authors supplied unprocessed intensity.
#'
#' All deposited PSM rows are retained, including rows without a glycan annotation. All
#' source reporter channels are retained; unmapped channels have unknown sample roles.
#' Consult sample_annotation_matched before comparing biological groups.
#'
#' @section Availability and source license:
#' Downloaded from the existing data release through the verified cache.
#' Deposited PRIDE source data are CC0-1.0, explicitly declared in the project API.
#' Cite the original authors and accession; see metadata redistribution and source provenance.
#' @source <https://doi.org/10.1038/s41594-025-01485-w>.
#' @inheritParams glyhub_load
#' @return A [glyexp::GlycoproteomicSE].
#' @seealso [glyhub_catalog()], [glyhub_data_conventions]
#' @export
glyhub_PXD052447_N_PNGase <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  glyhub_load("glyhub_PXD052447_N_PNGase", kind, cache_dir, refresh, offline)
}

#' DQGlyco proteinase K accessibility reporter intensities
#'
#' @details
#' 125,755 source feature rows across 18 reported measurement columns.
#'
#' Assay scale: Deposited untransformed PSM-level TMT reporter intensities
#'
#' Feature grain: PSM; all deposited rows retained, including rows without glycan
#' annotation
#'
#' Source selection: Deposited reporter intensities preferred over normalized
#' supplementary glycopeptide matrices or ratios
#'
#' No normalization, logarithm, imputation, confidence filtering, aggregation or zero
#' conversion; acquisition partitions use explicit source Spectrum prefixes
#'
#' Source blanks are NA; numeric zero retained with no interpretation of its
#' missingness semantics
#'
#' All 18 deposited reporter channels retained; unmatched channel roles remain unknown
#'
#' PSM counts are not counts of unique glycopeptides; no peptide-level aggregation
#' performed
#'
#' Protein sites are not inferred from peptide coordinates; original search annotations
#' are retained
#'
#' Source search/FDR and reporter extraction precede this deposit; any undocumented
#' upstream correction remains unknown
#'
#' Measurement columns are not automatically independent biological samples. Source row
#' identifiers, annotations and provenance are retained in metadata.
#'
#' The assay preserves source numeric values. The metadata field raw_abundance means
#' source numbers; it does not certify that the authors supplied unprocessed intensity.
#'
#' All deposited PSM rows are retained, including rows without a glycan annotation. All
#' source reporter channels are retained; unmapped channels have unknown sample roles.
#' Consult sample_annotation_matched before comparing biological groups.
#'
#' @section Availability and source license:
#' Downloaded from the existing data release through the verified cache.
#' Deposited PRIDE source data are CC0-1.0, explicitly declared in the project API.
#' Cite the original authors and accession; see metadata redistribution and source provenance.
#' @source <https://doi.org/10.1038/s41594-025-01485-w>.
#' @inheritParams glyhub_load
#' @return A [glyexp::GlycoproteomicSE].
#' @seealso [glyhub_catalog()], [glyhub_data_conventions]
#' @export
glyhub_PXD052447_N_ProteinaseK <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  glyhub_load(
    "glyhub_PXD052447_N_ProteinaseK",
    kind,
    cache_dir,
    refresh,
    offline
  )
}

#' Mouse brain Glyco-Decipher chromatographic areas
#'
#' @details
#' 20,191 source feature rows across 60 reported measurement columns.
#'
#' Assay scale: Source untransformed chromatographic Area
#'
#' Feature grain: Peptide / glycan / source sites / compensation voltage
#'
#' Source selection: Raw Area exports preferred over Supplementary Data6 processed
#' matrix
#'
#' No normalization, log transform, imputation, filtering, aggregation or zero
#' conversion
#'
#' Exact source identity union; a row absent from a run becomes structural NA; reported
#' zero remains zero
#'
#' Separate FAIMS compensation voltages retained as separate features
#'
#' Unambiguous single accession@position parsed; multiple site assignments retained
#' verbatim with canonical NA
#'
#' Run code and region code retained without guessing disease, age, or anatomical
#' mapping
#'
#' Source extraction and identification filtering precede these exports; unspecified
#' extraction settings remain unknown
#'
#' Measurement columns are not automatically independent biological samples. Source row
#' identifiers, annotations and provenance are retained in metadata.
#'
#' The assay preserves source numeric values. The metadata field raw_abundance means
#' source numbers; it does not certify that the authors supplied unprocessed intensity.
#'
#' @section Availability and source license:
#' Downloaded from the existing data release through the verified cache.
#' Source-license scope for the complete object remains unresolved; no new license is granted.
#' See publication-decisions.tsv and object metadata for original sources and limitations.
#' @source <https://doi.org/10.1038/s41467-025-60437-6>.
#' @inheritParams glyhub_load
#' @return A [glyexp::GlycoproteomicSE].
#' @seealso [glyhub_catalog()], [glyhub_data_conventions]
#' @export
glyhub_IPX0011099000_N_Brain <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  glyhub_load("glyhub_IPX0011099000_N_Brain", kind, cache_dir, refresh, offline)
}

#' Paired lung nodule glycoproteomics
#'
#' @details
#' 39,079 source feature rows across 165 reported measurement columns.
#'
#' Assay scale: Deposited untransformed ion-level TMT reporter intensities; author
#' software aggregated PSMs to ions
#'
#' Feature grain: Peptide Sequence / Modified Sequence / Charge / Observed
#' Modifications / Protein
#'
#' Source selection: Raw deposited ion reporter table preferred. Processed clinical
#' matrix retained as explicit alternative in metadata because original
#' channel-to-patient mapping was not supplied in the inspected files.
#'
#' No additional normalization, logarithm, imputation, zero conversion, confidence
#' filtering or intensity aggregation
#'
#' Exact molecular identity union across batches; an ion absent from a batch becomes
#' structural NA
#'
#' All source ion rows, including rows without glycan annotations, and all 11 channels
#' per batch retained
#'
#' 165 reporter channels are not 165 patients: reference/unused roles and linkage to
#' the 132 clinical specimens remain unresolved
#'
#' Source annotation.txt only repeats channel labels; clinical specimen labels are not
#' guessed
#'
#' Source PSM-to-ion summarization precedes this deposit; upstream correction settings
#' remain unverified
#'
#' Unambiguous composition text parsed after removing its explicit terminal mass;
#' ambiguous modifications retain full text and typed NA
#'
#' Measurement columns are not automatically independent biological samples. Source row
#' identifiers, annotations and provenance are retained in metadata.
#'
#' The assay preserves source numeric values. The metadata field raw_abundance means
#' source numbers; it does not certify that the authors supplied unprocessed intensity.
#'
#' @section Availability and source license:
#' Downloaded from the existing data release through the verified cache.
#' Source-license scope for the complete object remains unresolved; no new license is granted.
#' See publication-decisions.tsv and object metadata for original sources and limitations.
#' @source <https://doi.org/10.1038/s41467-025-57364-x>.
#' @inheritParams glyhub_load
#' @return A [glyexp::GlycoproteomicSE].
#' @seealso [glyhub_catalog()], [glyhub_data_conventions]
#' @export
glyhub_PXD046637_N_Lung <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  glyhub_load("glyhub_PXD046637_N_Lung", kind, cache_dir, refresh, offline)
}

#' Glyco-DIA SA serum source precursor peak areas
#'
#' @details
#' 93,442 source feature rows across 6 reported measurement columns.
#'
#' Assay scale: Source FG.MS2TotalPeakArea; untransformed MS2 chromatographic peak area
#'
#' Feature grain: Library / precursor / decoy flag; all source row associations
#' retained
#'
#' Source selection: Original Spectronaut peak areas preferred over author-added
#' Abundance and derived summary statistics
#'
#' No normalization, logarithm, imputation, zero conversion, confidence filtering or
#' numerical aggregation
#'
#' Repeated DDA-association rows are represented by their shared quantitative cell only
#' after exact MS1/MS2 equality is proven; no value averaging or conflict resolution
#'
#' Every source association remains linked by file and row; a missing precursor/run
#' pair becomes structural NA
#'
#' Source decoy rows retained and flagged; biological independence of runs is not
#' inferred from filenames
#'
#' Source modified sequence and glycopeptide label retained; no glycan composition
#' inferred solely from rounded mass
#'
#' Upstream extraction and interference handling are not fully documented in these
#' exports
#'
#' Measurement columns are not automatically independent biological samples. Source row
#' identifiers, annotations and provenance are retained in metadata.
#'
#' The assay preserves source numeric values. The metadata field raw_abundance means
#' source numbers; it does not certify that the authors supplied unprocessed intensity.
#'
#' Only the SA source file is included, across six reported runs. The deSA source CSV
#' contains independently confirmed embedded NUL bytes and an unparsable quantitative
#' record; it is excluded, not repaired or filtered. All source decoys are retained and
#' flagged. Biological independence and exact glycan compositions remain unassigned.
#'
#' @section Availability and source license:
#' Downloaded from the existing data release through the verified cache.
#' Deposited PRIDE source data are CC0-1.0, explicitly declared in the project API.
#' Cite the original authors and accession; see metadata redistribution and source provenance.
#' @source <https://doi.org/10.1038/s41592-019-0504-x>.
#' @inheritParams glyhub_load
#' @return A [glyexp::GlycoproteomicSE].
#' @seealso [glyhub_catalog()], [glyhub_data_conventions]
#' @export
glyhub_PXD011063_O_SerumSA <- function(
  kind = c("curated", "raw"),
  cache_dir = getOption(
    "glyhub.cache_dir",
    tools::R_user_dir("glyhub", "cache")
  ),
  refresh = FALSE,
  offline = FALSE
) {
  glyhub_load("glyhub_PXD011063_O_SerumSA", kind, cache_dir, refresh, offline)
}
