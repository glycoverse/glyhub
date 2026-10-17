noncptac_hcc <- function(path, sheet, provenance) {
  d <- as.data.frame(readxl::read_excel(path, sheet = sheet))
  clinical <- identical(sheet, 'Supplementary Data3')
  cols <- if (clinical) grep('^(CD_|TD_)', names(d)) else seq.int(2, ncol(d))
  a <- as.matrix(d[cols])
  stopifnot(is.numeric(a), all(a >= 0, na.rm = TRUE))
  ids <- sprintf(
    'PXD065283_%s_%05d',
    if (clinical) 'DiscoverySelected' else 'QC',
    seq_len(nrow(d))
  )
  rownames(a) <- ids
  label <- d[[1]]
  parts <- strsplit(label, '\t', fixed = TRUE)
  stopifnot(all(lengths(parts) == 2L), !anyDuplicated(label))
  comp <- vapply(parts, `[`, character(1), 1)
  site <- vapply(parts, `[`, character(1), 2)
  single <- grepl('^[A-Za-z0-9-]+@[0-9]+$', site)
  position <- rep(NA_integer_, length(site))
  position[single] <- as.integer(sub('.*@', '', site[single]))
  rd <- S4Vectors::DataFrame(
    protein = ifelse(single, sub('@.*', '', site), NA_character_),
    protein_site = position,
    source_site = site,
    source_composition = comp,
    source_feature = label,
    row.names = ids
  )
  supported <- !is.na(comp) & grepl("^([A-Za-z]+\\([0-9]+\\))+$", comp)
  rd$glycan_composition <- rep(glyrepr::glycan_composition(NA), length(comp))
  rd$glycan_composition[supported] <- noncptac_compositions(comp[supported])
  samples <- colnames(a)
  if (clinical) {
    subjects <- as.data.frame(readxl::read_excel(
      path,
      sheet = 'Supplementary Data2'
    ))
    stopifnot(!anyDuplicated(subjects[['LC-MS/MS ID']]))
    si <- match(samples, subjects[['LC-MS/MS ID']])
    stopifnot(!anyNA(si))
    cd <- subjects[si, , drop = FALSE]
    cd$source_sample <- samples
  } else {
    subjects <- NULL
    cd <- data.frame(
      source_sample = samples,
      sample_type = ifelse(grepl('^B', samples), 'batch QC', 'MS QC'),
      biological_sample = FALSE
    )
  }
  rownames(cd) <- samples
  glyexp::GlycoproteomicSE(
    a,
    rowData = rd,
    colData = S4Vectors::DataFrame(cd),
    metadata = list(
      glycan_type = 'N',
      doi = '10.1002/advs.202516299',
      accession = 'PXD065283',
      secondary_accession = 'JPST003880',
      source = paste('Liu et al. (2026),', sheet),
      source_provenance = provenance,
      assay_scale = if (clinical) {
        'Source median-normalized, log2-transformed, normally imputed abundance; DE-selected features'
      } else {
        'Source linear MBR-derived glycosite/glycan quantities; upstream normalization not independently established'
      },
      raw_abundance = a,
      raw_abundance_scale = if (clinical) {
        'source processed log2 abundance, NOT raw intensity'
      } else {
        'source linear MBR quantity; not certified unnormalized'
      },
      source_row = seq_len(nrow(d)) + 1L,
      source_measurement_columns = cols,
      source_statistics = if (clinical) d[2:4] else NULL,
      source_subject_table = subjects,
      source_selection = if (clinical) {
        'Only verified public individual clinical matrix; earliest unnormalized clinical table unavailable through inspected sources. QC linear table is a different experiment, not a substitute for clinical samples.'
      } else {
        'Linear QC matrix chosen; clinical DE-selected log2 table is a separate cohort dataset.'
      },
      processing = c(
        'All source cells preserved; no new normalization, imputation, filtering, inverse transform or aggregation',
        if (clinical) {
          'Source workflow: MBR, source missingness filtering, median normalization, log2, normal-distribution interpolation, then differential-feature selection (p<=0.01 and absolute log2FC>=1)'
        } else {
          'Source reports match-between-run quantification; source blank values retained as NA'
        },
        if (clinical) {
          '1038 selected features and 140 discovery samples; not the full 8902-feature matrix or 60-person validation cohort. Feature selection uses case labels; unsuitable for unbiased discovery or classifier performance estimates.'
        } else {
          '30 QC injections (13 days, 3 repeated injections, 14 batch QC runs), not 30 independent people'
        },
        'No exponentiation to claim recovered original intensity; unspecified upstream settings remain unknown'
      ),
      license = 'Article and attachment terms require separate redistribution review; local staging only'
    )
  )
}
