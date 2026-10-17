noncptac_glycodia_serum <- function(paths, provenance) {
  selected <- c(
    'R.FileName',
    'EG.Library',
    'EG.PrecursorId',
    'EG.IsDecoy',
    'EG.StrippedSequence',
    'EG.ModifiedSequence',
    'PG.ProteinAccessions',
    'Glycopeptides',
    'FG.MS2TotalPeakArea',
    'FG.MS1PeakArea'
  )
  tables <- lapply(paths, function(p) {
    header <- names(read.csv(p, nrows = 0, check.names = FALSE))
    stopifnot(all(selected %in% header))
    classes <- rep('NULL', length(header))
    classes[match(selected, header)] <- 'character'
    d <- read.csv(
      p,
      check.names = FALSE,
      colClasses = classes,
      na.strings = c('', 'NA', 'NaN'),
      stringsAsFactors = FALSE
    )
    d$source_row <- seq_len(nrow(d)) + 1L
    d$source_csv <- basename(p)
    d
  })
  d <- do.call(rbind, tables)
  key <- paste(
    d[['EG.Library']],
    d[['EG.PrecursorId']],
    d[['EG.IsDecoy']],
    sep = '\t'
  )
  samplekey <- paste(d$source_csv, d[['R.FileName']], sep = '::')
  kk <- unique(key)
  ss <- unique(samplekey)
  ri <- match(key, kk)
  ci <- match(samplekey, ss)
  ms2 <- as.numeric(d[['FG.MS2TotalPeakArea']])
  ms1 <- as.numeric(d[['FG.MS1PeakArea']])
  stopifnot(
    all(is.na(ms2) == is.na(d[['FG.MS2TotalPeakArea']])),
    all(is.na(ms1) == is.na(d[['FG.MS1PeakArea']])),
    all(is.finite(ms2) | is.na(ms2)),
    all(is.finite(ms1) | is.na(ms1)),
    all(ms2 >= 0, na.rm = TRUE),
    all(ms1 >= 0, na.rm = TRUE)
  )
  ids <- sprintf('GlycoDIA_serum_precursor_%06d', seq_along(kk))
  samples <- sprintf('GlycoDIA_serum_run_%02d', seq_along(ss))
  a <- ms1a <- matrix(
    NA_real_,
    length(kk),
    length(ss),
    dimnames = list(ids, samples)
  )
  # Several source DDA associations can refer to one Spectronaut precursor/run.
  # Never average or choose between differing measurements: require exact equality.
  cell <- paste(ri, ci, sep = ':')
  groups <- split(seq_along(cell), cell)
  for (ix in groups) {
    stopifnot(length(unique(ms2[ix])) == 1L, length(unique(ms1[ix])) == 1L)
    a[ri[ix[1]], ci[ix[1]]] <- ms2[ix[1]]
    ms1a[ri[ix[1]], ci[ix[1]]] <- ms1[ix[1]]
  }
  first <- match(kk, key)
  ann <- d[first, ]
  rd <- S4Vectors::DataFrame(
    protein = ann[['PG.ProteinAccessions']],
    protein_site = rep(NA_integer_, length(kk)),
    peptide = ann[['EG.StrippedSequence']],
    source_modified_sequence = ann[['EG.ModifiedSequence']],
    source_precursor = ann[['EG.PrecursorId']],
    source_library = ann[['EG.Library']],
    source_is_decoy = ann[['EG.IsDecoy']],
    source_glycopeptide = ann$Glycopeptides,
    row.names = ids
  )
  rd$glycan_composition <- rep(glyrepr::glycan_composition(NA), length(kk))
  firsts <- match(ss, samplekey)
  cd <- S4Vectors::DataFrame(
    source_csv = d$source_csv[firsts],
    source_run = d[['R.FileName']][firsts],
    biological_sample_id = rep(NA_character_, length(ss)),
    row.names = samples
  )
  glyexp::GlycoproteomicSE(
    a,
    rowData = rd,
    colData = cd,
    metadata = list(
      glycan_type = 'O',
      doi = '10.1038/s41592-019-0504-x',
      accession = 'PXD011063',
      source = paste(basename(paths), collapse = ' and '),
      source_provenance = provenance,
      assay_scale = 'Source FG.MS2TotalPeakArea; untransformed MS2 chromatographic peak area',
      raw_abundance = a,
      raw_abundance_scale = 'source MS2 total peak area',
      source_ms1_peak_area = ms1a,
      source_associations = data.frame(
        feature = ids[ri],
        sample = samples[ci],
        source_file = d$source_csv,
        source_row = d$source_row,
        source_glycopeptide = d$Glycopeptides,
        source_protein = d[['PG.ProteinAccessions']]
      ),
      repeated_source_associations = nrow(d) - length(groups),
      source_selection = 'Original Spectronaut peak areas preferred over author-added Abundance and derived summary statistics',
      feature_grain = 'Library / precursor / decoy flag; all source row associations retained',
      processing = c(
        'No normalization, logarithm, imputation, zero conversion, confidence filtering or numerical aggregation',
        'Repeated DDA-association rows are represented by their shared quantitative cell only after exact MS1/MS2 equality is proven; no value averaging or conflict resolution',
        'Every source association remains linked by file and row; a missing precursor/run pair becomes structural NA',
        'Source decoy rows retained and flagged; biological independence of runs is not inferred from filenames',
        'Source modified sequence and glycopeptide label retained; no glycan composition inferred solely from rounded mass',
        'Upstream extraction and interference handling are not fully documented in these exports'
      ),
      license = 'Repository file redistribution terms not independently confirmed; local staging only'
    )
  )
}
