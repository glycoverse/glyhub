noncptac_glycodia_reports <- function(paths, provenance) {
  tables <- lapply(paths, function(p) {
    read.delim(
      p,
      check.names = FALSE,
      stringsAsFactors = FALSE,
      quote = '',
      comment.char = '',
      na.strings = c('', 'NaN')
    )
  })
  names(tables) <- basename(paths)
  key <- function(d) {
    paste(
      d[['EG.Library']],
      d[['EG.PrecursorId']],
      d[['EG.IsDecoy']],
      sep = '\t'
    )
  }
  keys <- lapply(tables, key)
  stopifnot(all(vapply(keys, function(k) !anyDuplicated(k), logical(1))))
  all_keys <- unique(unlist(keys, use.names = FALSE))
  ids <- sprintf('GlycoDIA_precursor_%06d', seq_along(all_keys))
  a <- ms1 <- rows <- matrix(
    NA_real_,
    length(ids),
    length(paths),
    dimnames = list(ids, names(tables))
  )
  annotation <- do.call(
    rbind,
    lapply(tables, function(d) {
      d[c(
        'PG.ProteinAccessions',
        'EG.StrippedSequence',
        'EG.ModifiedSequence',
        'EG.PrecursorId',
        'EG.Library',
        'EG.IsDecoy'
      )]
    })
  )
  annotation <- annotation[
    match(all_keys, unlist(keys, use.names = FALSE)),
    ,
    drop = FALSE
  ]
  sample_rows <- list()
  source_flags <- list()
  for (i in seq_along(tables)) {
    d <- tables[[i]]
    ix <- match(keys[[i]], all_keys)
    stopifnot(length(unique(d[['R.FileName']])) == 1L)
    a[ix, i] <- d[['FG.MS2TotalPeakArea']]
    ms1[ix, i] <- d[['FG.MS1PeakArea']]
    rows[ix, i] <- seq_len(nrow(d)) + 1L
    sample_rows[[i]] <- data.frame(
      source_report = names(tables)[i],
      source_run = unique(d[['R.FileName']]),
      source_library = paste(unique(d[['EG.Library']]), collapse = ';'),
      source_condition = paste(unique(d[['R.Condition']]), collapse = ';'),
      source_replicate = paste(unique(d[['R.Replicate']]), collapse = ';')
    )
    source_flags[[i]] <- d
  }
  stopifnot(all(a >= 0, na.rm = TRUE), all(ms1 >= 0, na.rm = TRUE))
  rd <- S4Vectors::DataFrame(
    protein = annotation[['PG.ProteinAccessions']],
    peptide = annotation[['EG.StrippedSequence']],
    protein_site = rep(NA_integer_, length(ids)),
    source_modified_sequence = annotation[['EG.ModifiedSequence']],
    source_precursor = annotation[['EG.PrecursorId']],
    source_library = annotation[['EG.Library']],
    source_is_decoy = annotation[['EG.IsDecoy']],
    row.names = ids
  )
  # Author code defines T=Hex(1)HexNAc(1), Tn=HexNAc(1).
  # Preserve modifications verbatim; do not infer glycan identity from rounded mass alone.
  rd$glycan_composition <- rep(glyrepr::glycan_composition(NA), length(ids))
  cd <- do.call(rbind, sample_rows)
  rownames(cd) <- colnames(a)
  x <- glyexp::GlycoproteomicSE(
    a,
    rowData = rd,
    colData = S4Vectors::DataFrame(cd),
    metadata = list(
      glycan_type = 'O',
      doi = '10.1038/s41592-019-0504-x',
      accession = 'PXD011063',
      source = 'Deposited Spectronaut reports',
      source_provenance = provenance,
      assay_scale = 'Source FG.MS2TotalPeakArea; untransformed summed MS2 fragment chromatographic peak area',
      raw_abundance = a,
      raw_abundance_scale = 'source MS2 total peak area',
      feature_grain = 'Library-specific precursor and source decoy flag; source decoys retained and explicitly flagged',
      source_row = rows,
      source_reports = source_flags,
      source_selection = 'MS2TotalPeakArea preferred over FG.Quantity, EG.TotalQuantity and supplementary glycopeptide quantities; MS1PeakArea retained in metadata',
      processing = c(
        'No normalization, log transform, imputation, zero conversion, confidence filtering or aggregation',
        'Union of exact library/precursor/decoy keys; absent report rows become structural NA, not zero',
        'Source decoy rows and unquantified or unidentified rows retained; use source flags before biological inference',
        'Different libraries are alternative analyses, not independent biological samples',
        'No glycan composition inferred solely from rounded modification mass; source modified sequence retained',
        'Spectronaut extraction, interference handling and upstream settings are not fully recoverable from these exports'
      ),
      license = 'Repository attachment redistribution terms not independently confirmed; local staging only'
    )
  )
  S4Vectors::metadata(x)$source_ms1_peak_area <- ms1
  x
}
