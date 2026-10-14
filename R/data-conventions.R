#' Measurement and annotation conventions for glyhub datasets
#'
#' Shared conventions for reading glyhub abundance matrices, molecular
#' annotations and source provenance. Each dataset's help page describes its
#' experimental design, units and specific limitations.
#'
#' @details
#' Zero-valued abundances are represented as `NA` in the distributed abundance
#' assay. This representation differs from the original source tables, which
#' remain available in metadata. Missing values are not imputed, and abundances
#' are not renormalized after this conversion. Zero-valued times and categorical
#' annotations are unchanged.
#'
#' For GPST000738, measurements with unresolved source-table conflicts are also
#' `NA`. `metadata(x)$processing_masks` distinguishes original missing entries,
#' source not-detected entries, conflicts and zero conversions. Masks may overlap.
#' For GPST000643, not-detected retention-time entries are recorded separately
#' from zero-valued quantitative measurements.
#'
#' `metadata(x)$raw_abundance` preserves the original numerical matrix.
#' `raw_text`, source tables and `processing_ledger` retain source notation,
#' cell coordinates and the explanation for each processed value. Original AUCs
#' and retention times are available for GPST000643. These provenance matrices
#' are not additional abundance assays and may use different units.
#'
#' `rowData(x)` retains source feature labels, typed glyrepr compositions and
#' structures where supported. A `glycan_structure` column is present only when
#' at least one feature has a valid structural annotation; unannotated features
#' in that column remain `NA`. If none has a structural annotation, the column
#' is absent. Putative assignments remain putative; ambiguous
#' linkages are not completed. Unconverted notation and annotation disagreements
#' are retained explicitly. Source mass/isomer labels are not universal IDs.
#' Consult individual feature annotations when an experiment includes more than
#' one glycan class.
#'
#' `colData(x)` contains source conditions and observation labels. A source label
#' such as Sample 1 or Replicate 1 does not by itself establish biological
#' replication, independence or pairing across tables. Each object's `source`,
#' `doi` and `license` metadata identify its references and source-data license.
#' Source-data licenses are separate from the package code license.
#'
#' @name glyhub_data_conventions
NULL
