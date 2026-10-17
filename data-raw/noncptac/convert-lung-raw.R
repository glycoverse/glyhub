noncptac_lung_raw <- function(paths, processed_path, provenance) {
  d <- lapply(paths, function(p) {
    read.delim(
      p,
      check.names = FALSE,
      stringsAsFactors = FALSE,
      quote = '',
      comment.char = '',
      na.strings = ''
    )
  })
  channels <- c(
    '126',
    '127N',
    '127C',
    '128N',
    '128C',
    '129N',
    '129C',
    '130N',
    '130C',
    '131N',
    '131C'
  )
  keycols <- c(
    'Peptide Sequence',
    'Modified Sequence',
    'Charge',
    'Observed Modifications',
    'Protein'
  )
  key <- function(x) do.call(paste, c(x[keycols], sep = '\t'))
  keys <- lapply(d, key)
  stopifnot(all(vapply(keys, function(k) !anyDuplicated(k), logical(1))))
  kk <- unique(unlist(keys, use.names = FALSE))
  ids <- sprintf('PXD046637_ion_%06d', seq_along(kk))
  batches <- basename(dirname(paths))
  samples <- unlist(
    lapply(batches, function(b) paste(b, channels, sep = '_')),
    use.names = FALSE
  )
  a <- matrix(
    NA_real_,
    length(kk),
    length(samples),
    dimnames = list(ids, samples)
  )
  rows <- matrix(
    NA_integer_,
    length(kk),
    length(paths),
    dimnames = list(ids, batches)
  )
  ann <- do.call(rbind, lapply(d, function(x) x[keycols]))
  ann <- ann[match(kk, unlist(keys, use.names = FALSE)), , drop = FALSE]
  for (i in seq_along(d)) {
    ix <- match(keys[[i]], kk)
    cols <- seq.int((i - 1L) * length(channels) + 1L, i * length(channels))
    a[ix, cols] <- as.matrix(d[[i]][channels])
    rows[ix, i] <- seq_len(nrow(d[[i]])) + 1L
  }
  stopifnot(all(a >= 0, na.rm = TRUE))
  comp <- sub('\\([0-9]+\\.[0-9]+\\)$', '', ann[['Observed Modifications']])
  supported <- !is.na(comp) & grepl('^([A-Za-z]+\\([0-9]+\\))+$', comp)
  rd <- S4Vectors::DataFrame(
    protein = ann$Protein,
    protein_site = rep(NA_integer_, length(kk)),
    peptide = ann[['Peptide Sequence']],
    source_modified_sequence = ann[['Modified Sequence']],
    source_charge = ann$Charge,
    source_modification = ann[['Observed Modifications']],
    source_composition = comp,
    source_composition_recognized = supported,
    row.names = ids
  )
  rd$glycan_composition <- rep(glyrepr::glycan_composition(NA), length(kk))
  rd$glycan_composition[supported] <- noncptac_compositions(comp[supported])
  cd <- S4Vectors::DataFrame(
    source_batch = rep(batches, each = length(channels)),
    source_reporter_channel = rep(channels, length(batches)),
    tissue = NA_character_,
    patient = NA_character_,
    sample_annotation_matched = FALSE,
    row.names = samples
  )
  alt <- as.data.frame(readxl::read_excel(
    processed_path,
    sheet = 'glycoproteomics'
  ))
  glyexp::GlycoproteomicSE(
    a,
    rowData = rd,
    colData = cd,
    metadata = list(
      glycan_type = 'N',
      doi = '10.1038/s41467-025-57364-x',
      accession = 'PXD046637',
      source = 'Deposited MSFragger/Philosopher ion.tsv reporter intensities',
      source_provenance = provenance,
      assay_scale = 'Deposited untransformed ion-level TMT reporter intensities; author software aggregated PSMs to ions',
      raw_abundance = a,
      raw_abundance_scale = 'source reporter intensity',
      feature_grain = paste(keycols, collapse = ' / '),
      source_row = rows,
      source_files = setNames(basename(paths), batches),
      source_tables = setNames(d, batches),
      processed_clinical_alternative = list(
        assay = as.matrix(alt[7:138]),
        row_annotation = alt[1:6],
        sample_labels = names(alt)[7:138],
        scale = 'Author protein-abundance-corrected relative TMT signal, 12480 features x 132 tissues',
        source_url = 'https://media.springernature.com/original/springer-static/esm/art%3A10.1038%2Fs41467-025-57364-x/MediaObjects/41467_2025_57364_MOESM4_ESM.xlsx',
        caution = 'No verified raw-channel/patient or raw-ion/processed-row mapping; do not align these matrices by order'
      ),
      source_selection = 'Raw deposited ion reporter table preferred. Processed clinical matrix retained as explicit alternative in metadata because original channel-to-patient mapping was not supplied in the inspected files.',
      processing = c(
        'No additional normalization, logarithm, imputation, zero conversion, confidence filtering or intensity aggregation',
        'Exact molecular identity union across batches; an ion absent from a batch becomes structural NA',
        'All source ion rows, including rows without glycan annotations, and all 11 channels per batch retained',
        '165 reporter channels are not 165 patients: reference/unused roles and linkage to the 132 clinical specimens remain unresolved',
        'Source annotation.txt only repeats channel labels; clinical specimen labels are not guessed',
        'Source PSM-to-ion summarization precedes this deposit; upstream correction settings remain unverified',
        'Unambiguous composition text parsed after removing its explicit terminal mass; ambiguous modifications retain full text and typed NA'
      ),
      license = 'Article CC BY-NC-ND4.0; attachment applicability unconfirmed; local staging only'
    )
  )
}
