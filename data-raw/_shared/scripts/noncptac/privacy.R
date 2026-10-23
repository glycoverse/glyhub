# Public human-subject representations: retain quantitative values, not clinical identifiers.
literature_private_subject_datasets <- c(
  'glyhub_THNO47066_N_UrineDeglycopeptides',
  'glyhub_PXD019914_N_Intact_RelativeRatios',
  'glyhub_PXD019914_N_SPEG_RelativeRatios',
  'glyhub_PMC10983713_N_SerumDiseaseGroups',
  'glyhub_PMC9185890_N_AMLSurfaceome',
  'glyhub_PMC9287322_N_PrimaryMyelomaInputs',
  'glyhub_MSV000088624_N_HeartSurfaceome'
)

redact_literature_subjects <- function(x, dataset) {
  if (!dataset %in% literature_private_subject_datasets) {
    return(x)
  }
  md <- S4Vectors::metadata(x)
  if (isTRUE(md$privacy_redacted)) {
    return(x)
  }
  original <- SummarizedExperiment::assay(x)
  old_cd <- SummarizedExperiment::colData(x)
  prefix <- strsplit(dataset, '_', fixed = TRUE)[[1]][2]
  anonymous <- sprintf('%s_sample_%03d', prefix, seq_len(ncol(x)))
  # Only scientifically necessary design fields are retained. No original subject mapping.
  allowed <- c(
    'condition',
    'sample_role',
    'species',
    'tissue',
    'source_cohort',
    'sample_material',
    'material',
    'replicate_type',
    'replication',
    'input_label',
    'source_replication_description',
    'anonymous_subject'
  )
  cd <- old_cd[, intersect(allowed, names(old_cd)), drop = FALSE]
  if ('source_PCa_type' %in% names(old_cd)) {
    cd$condition <- old_cd$source_PCa_type
  }
  subject <- if ('patient' %in% names(old_cd)) {
    old_cd$patient
  } else if ('subject_id' %in% names(old_cd)) {
    old_cd$subject_id
  } else {
    NULL
  }
  if (!is.null(subject)) {
    valid <- !is.na(subject) & nzchar(as.character(subject))
    cd$anonymous_subject <- rep(NA_character_, ncol(x))
    cd$anonymous_subject[valid] <- sprintf(
      '%s_subject_%03d',
      prefix,
      match(as.character(subject[valid]), unique(as.character(subject[valid])))
    )
  }
  substitutions <- stats::setNames(anonymous, colnames(x))
  if (!is.null(subject)) {
    valid <- !is.na(subject) & nzchar(as.character(subject))
    substitutions <- c(
      substitutions,
      stats::setNames(cd$anonymous_subject[valid], as.character(subject[valid]))
    )
  }
  substitutions <- substitutions[!duplicated(names(substitutions))]
  for (field in names(cd)) {
    if (is.character(cd[[field]])) {
      for (token in names(substitutions)[order(
        nchar(names(substitutions)),
        decreasing = TRUE
      )]) {
        cd[[field]] <- gsub(
          token,
          substitutions[[token]],
          cd[[field]],
          fixed = TRUE
        )
      }
    }
  }
  if (identical(dataset, 'glyhub_PMC9185890_N_AMLSurfaceome')) {
    rd <- SummarizedExperiment::rowData(x)
    # Excluded non-glyco protocol quantifications are not feature annotations.
    original_fields <- names(md$source_table)[seq_len(4L)]
    standard_fields <- c(
      'source_protein_annotation',
      'protein',
      'protein_site',
      'glycan_composition',
      'source_row'
    )
    SummarizedExperiment::rowData(x) <- rd[,
      intersect(c(original_fields, standard_fields), names(rd)),
      drop = FALSE
    ]
  }
  if (identical(dataset, 'glyhub_PMC9287322_N_PrimaryMyelomaInputs')) {
    # Additional source statistics name individual subjects; preserve values without identifiers.
    rd <- SummarizedExperiment::rowData(x)
    names(rd)[13:15] <- paste0('source_summary_', seq_len(3L))
    SummarizedExperiment::rowData(x) <- rd
    names(md$source_annotation)[13:15] <- paste0('source_summary_', seq_len(3L))
  }
  cd$anonymous_sample <- anonymous
  rownames(cd) <- anonymous
  SummarizedExperiment::colData(x) <- cd
  colnames(x) <- anonymous
  if (!is.null(md$raw_abundance)) {
    colnames(md$raw_abundance) <- anonymous
  }
  if (!is.null(md$processing_masks)) {
    for (k in names(md$processing_masks)) {
      if (
        is.matrix(md$processing_masks[[k]]) &&
          ncol(md$processing_masks[[k]]) == ncol(x)
      ) {
        colnames(md$processing_masks[[k]]) <- anonymous
      }
    }
  }
  # Reconstruct selected source table: biological feature annotations and unchanged values only.
  if (!is.null(md$source_table)) {
    nanno <- min(md$source_measurement_columns) - 1L
    annotation <- md$source_table[seq_len(nanno)]
    md$source_table <- cbind(
      annotation,
      as.data.frame(md$raw_abundance, check.names = FALSE)
    )
    md$source_measurement_columns <- nanno + seq_len(ncol(x))
  }
  provenance <- md$source_provenance
  keep <- c(
    'accession',
    'doi',
    'repository',
    'source_url',
    'publisher_url',
    'source_workbook_url',
    'sha256',
    'source_workbook_sha256',
    'local_file',
    'sheet',
    'source_sheet',
    'header_excel_row',
    'header_row',
    'features',
    'measurements',
    'feature_count',
    'sample_count',
    'license',
    'license_url',
    'license_evidence_url',
    'assay_scale',
    'scale',
    'assay_semantics'
  )
  md$source_provenance <- provenance[intersect(keep, names(provenance))]
  md$source_provenance$privacy <- 'Public derivative: study-local anonymous sample/subject labels; no original patient-ID correspondence or individual clinical covariates'
  md$processing <- c(
    'Preserve every selected quantitative value, zero and missing value; no new normalization or imputation',
    'Replace original human subject/sample labels with study-local anonymous labels and remove individual clinical covariates',
    'Retain necessary disease/control grouping, quality-control roles and repeated-subject design; do not publish a reverse correspondence',
    if (!is.null(md$assay_transformation)) {
      'Study-specific 2^source-log2 ratio transformation remains unchanged; original log2 values retained'
    }
  )
  md$privacy_redacted <- TRUE
  md$privacy_representation <- 'deidentified derivative; not an exact-original metadata copy'
  S4Vectors::metadata(x) <- md
  stopifnot(
    identical(as.numeric(original), as.numeric(SummarizedExperiment::assay(x))),
    identical(
      is.na(unname(original)),
      is.na(unname(SummarizedExperiment::assay(x)))
    ),
    methods::validObject(x)
  )
  x
}
