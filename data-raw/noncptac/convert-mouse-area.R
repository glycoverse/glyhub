noncptac_mouse_area <- function(paths, provenance, sample_workbook) {
  tables <- lapply(paths, function(p) {
    read.delim(p, check.names = FALSE, stringsAsFactors = FALSE)
  })
  key <- function(d) {
    do.call(
      paste,
      c(d[c('Peptide', 'Glycan', 'Site', 'CompensationVoltage')], sep = '\t')
    )
  }
  keys <- lapply(tables, key)
  stopifnot(all(vapply(keys, function(k) !anyDuplicated(k), logical(1))))
  kk <- unique(unlist(keys, use.names = FALSE))
  ids <- sprintf('IPX0011099004_%06d', seq_along(kk))
  samples <- sub('_GlycoPeptideQuantificationArea.txt$', '', basename(paths))
  a <- rows <- matrix(
    NA_real_,
    length(kk),
    length(paths),
    dimnames = list(ids, samples)
  )
  annotation <- do.call(rbind, lapply(tables, function(d) d[1:4]))
  annotation <- annotation[
    match(kk, unlist(keys, use.names = FALSE)),
    ,
    drop = FALSE
  ]
  for (i in seq_along(tables)) {
    ix <- match(keys[[i]], kk)
    a[ix, i] <- tables[[i]]$Area
    rows[ix, i] <- seq_len(nrow(tables[[i]])) + 1L
  }
  stopifnot(all(a >= 0, na.rm = TRUE))
  site <- sub(';$', '', annotation$Site)
  single <- grepl('^[A-Za-z0-9-]+@[0-9]+$', site)
  position <- rep(NA_integer_, length(site))
  position[single] <- as.integer(sub(".*@", "", site[single]))
  rd <- S4Vectors::DataFrame(
    peptide = annotation$Peptide,
    protein = ifelse(single, sub('@.*', '', site), NA_character_),
    protein_site = ifelse(
      single,
      as.integer(sub('.*@', '', site)),
      NA_integer_
    ),
    source_sites = annotation$Site,
    source_composition = annotation$Glycan,
    source_compensation_voltage = annotation$CompensationVoltage,
    row.names = ids
  )
  supported <- !is.na(annotation$Glycan) &
    grepl("^([A-Za-z]+\\([0-9]+\\))+$", annotation$Glycan)
  rd$glycan_composition <- rep(
    glyrepr::glycan_composition(NA),
    nrow(annotation)
  )
  rd$glycan_composition[supported] <- noncptac_compositions(annotation$Glycan[
    supported
  ])
  cd <- S4Vectors::DataFrame(
    source_run = samples,
    source_file = basename(paths),
    source_subject_code = sub('_[A-Z]$', '', samples),
    source_region_code = sub('.*_', '', samples),
    disease = rep(NA_character_, length(samples)),
    brain_region = rep(NA_character_, length(samples)),
    species = 'Mus musculus',
    row.names = samples
  )
  sm <- as.data.frame(readxl::read_excel(
    sample_workbook,
    sheet = "Diseases",
    col_names = FALSE,
    .name_repair = "minimal"
  ))
  groups <- as.character(sm[2, 2:17])
  for (j in seq_along(groups)) {
    if (is.na(groups[j])) groups[j] <- groups[j - 1L]
  }
  regions <- as.character(sm[3, 2:17])
  raw_names <- as.character(sm[-(1:3), 1])
  stopifnot(!anyDuplicated(raw_names))
  flags <- as.matrix(sm[-(1:3), 2:17]) == "+"
  flags[is.na(flags)] <- FALSE
  stopifnot(all(rowSums(flags) == 1L))
  source_group <- groups[max.col(flags, ties.method = "first")]
  source_region <- regions[max.col(flags, ties.method = "first")]
  ix <- match(samples, raw_names)
  cd$disease <- source_group[ix]
  cd$brain_region <- source_region[ix]
  cd$sample_annotation_matched <- !is.na(ix)
  glyexp::GlycoproteomicSE(
    a,
    rowData = rd,
    colData = cd,
    metadata = list(
      glycan_type = 'N',
      doi = '10.1038/s41467-025-60437-6',
      accession = 'IPX0011099000',
      subproject = 'IPX0011099004',
      source = 'Deposited Glyco-Decipher GlycoPeptideQuantificationArea tables',
      source_provenance = provenance,
      assay_scale = 'Source untransformed chromatographic Area',
      raw_abundance = a,
      raw_abundance_scale = 'source XIC area',
      source_row = rows,
      feature_grain = 'Peptide / glycan / source sites / compensation voltage',
      source_selection = 'Raw Area exports preferred over Supplementary Data6 processed matrix',
      processing = c(
        'No normalization, log transform, imputation, filtering, aggregation or zero conversion',
        'Exact source identity union; a row absent from a run becomes structural NA; reported zero remains zero',
        'Separate FAIMS compensation voltages retained as separate features',
        'Unambiguous single accession@position parsed; multiple site assignments retained verbatim with canonical NA',
        'Run code and region code retained without guessing disease, age, or anatomical mapping',
        'Source extraction and identification filtering precede these exports; unspecified extraction settings remain unknown'
      ),
      license = 'Article CC BY-NC-ND4.0; repository attachment applicability unconfirmed; local staging only'
    )
  )
}
