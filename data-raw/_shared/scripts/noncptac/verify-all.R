args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) == 2L)
evidence <- normalizePath(args[1], mustWork = TRUE)
cache <- args[2]
devtools::load_all(quiet = TRUE)
ids <- read.delim('data-raw/_shared/metadata/noncptac/manifest.tsv')$dataset
m <- subset(glyhub_catalog(), dataset %in% ids)
results <- list()
prior <- jsonlite::fromJSON(
  "data-raw/_shared/reports/noncptac/completed-source-checks.json",
  simplifyVector = FALSE
)
for (i in seq_len(nrow(m))) {
  e <- m[i, ]
  x <- glyhub_load(e$dataset, cache_dir = cache, offline = TRUE)
  stopifnot(
    methods::validObject(x),
    identical(dim(x), as.integer(c(e$features, e$measurements)))
  )
  a <- SummarizedExperiment::assay(x)
  md <- S4Vectors::metadata(x)
  stopifnot(
    if (e$dataset == "glyhub_MSV000089484_N_HCC") {
      expected <- md$raw_abundance
      expected[expected == -1] <- NA_real_
      identical(a, expected)
    } else {
      identical(a, md$raw_abundance)
    },
    all(is.finite(a) | is.na(a)),
    all(a >= 0, na.rm = TRUE)
  )
  checked <- 0L
  reused <- !is.null(prior[[e$dataset]]) &&
    identical(prior[[e$dataset]]$sha256, e$sha256)
  if (reused) {
    checked <- prior[[e$dataset]]$compared_cells
  } else if (e$dataset == 'glyhub_MSV000089484_N_HCC') {
    d <- readxl::read_excel(
      file.path(evidence, '41467_2022_35172_MOESM6_ESM.xlsx'),
      sheet = 'Intact glycopeptides-original'
    )
    raw <- as.matrix(d[4:15])
    stopifnot(
      identical(as.numeric(raw), as.numeric(md$raw_abundance)),
      sum(raw == -1) == 40338L,
      sum(raw == 0) == 2137L
    )
    raw[raw == -1] <- NA_real_
    stopifnot(identical(as.numeric(raw), as.numeric(a)))
    checked <- length(a)
  } else if (grepl('^glyhub_PXD052447', e$dataset)) {
    p <- file.path(evidence, 'range-downloads', md$source)
    d <- read.delim(
      p,
      check.names = FALSE,
      quote = '',
      comment.char = '',
      na.strings = ''
    )
    src <- as.matrix(d[
      md$source_row - 1L,
      md$source_measurement_columns,
      drop = FALSE
    ])
    stopifnot(identical(as.numeric(src), as.numeric(a)))
    checked <- length(a)
  } else if (e$dataset == 'glyhub_IPX0011099000_N_Brain') {
    for (j in seq_len(ncol(a))) {
      p <- file.path(
        evidence,
        'mouse-glycodecipher/glycodecipher-full',
        SummarizedExperiment::colData(x)$source_file[j]
      )
      d <- read.delim(p, check.names = FALSE)
      idx <- which(!is.na(md$source_row[, j]))
      rows <- md$source_row[idx, j] - 1L
      stopifnot(identical(unname(a[idx, j]), d$Area[rows]))
      checked <- checked + length(idx)
    }
  } else if (grepl('^glyhub_PXD065283', e$dataset)) {
    d <- readxl::read_excel(
      file.path(evidence, 'hcc-epmc-supp', md$source_provenance$workbook),
      sheet = md$source_provenance$sheet
    )
    stopifnot(identical(
      as.numeric(as.matrix(d[md$source_measurement_columns])),
      as.numeric(a)
    ))
    checked <- length(a)
  } else if (e$dataset == 'glyhub_PXD011063_O_SerumSA') {
    links <- md$source_associations
    for (name in unique(links$source_file)) {
      p <- file.path(evidence, 'glycodia-csv', name)
      header <- names(read.csv(p, nrows = 0, check.names = FALSE))
      cl <- rep('NULL', length(header))
      cl[match(c('FG.MS2TotalPeakArea', 'FG.MS1PeakArea'), header)] <- 'numeric'
      d <- read.csv(
        p,
        check.names = FALSE,
        colClasses = cl,
        na.strings = c('', 'NA', 'NaN')
      )
      l <- links[links$source_file == name, ]
      stopifnot(identical(l$source_row, seq_len(nrow(d)) + 1L))
      ix <- cbind(match(l$feature, rownames(a)), match(l$sample, colnames(a)))
      stopifnot(
        !anyNA(ix),
        identical(unname(a[ix]), d[['FG.MS2TotalPeakArea']]),
        identical(unname(md$source_ms1_peak_area[ix]), d[['FG.MS1PeakArea']])
      )
      checked <- checked + nrow(d)
    }
  } else if (e$dataset == 'glyhub_PXD011063_O_Dilution') {
    rd <- SummarizedExperiment::rowData(x)
    keys <- paste(
      rd$source_library,
      rd$source_precursor,
      rd$source_is_decoy,
      sep = '\t'
    )
    for (j in seq_len(ncol(a))) {
      d <- read.delim(
        file.path(evidence, 'glycodia-reports', colnames(a)[j]),
        check.names = FALSE,
        quote = '',
        comment.char = '',
        na.strings = c('', 'NaN')
      )
      idx <- match(
        paste(
          d[['EG.Library']],
          d[['EG.PrecursorId']],
          d[['EG.IsDecoy']],
          sep = '\t'
        ),
        keys
      )
      stopifnot(
        !anyNA(idx),
        identical(unname(a[idx, j]), d[['FG.MS2TotalPeakArea']]),
        identical(
          unname(md$source_ms1_peak_area[idx, j]),
          d[['FG.MS1PeakArea']]
        )
      )
      checked <- checked + nrow(d)
    }
  } else if (e$dataset == 'glyhub_PXD070547_N_HumanAtlas') {
    d <- readxl::read_excel(
      file.path(evidence, 'human-atlas/Supplementary Data 2.xlsx'),
      sheet = 'Raw expression matrix',
      na = 'NA'
    )
    stopifnot(identical(as.numeric(as.matrix(d[-1])), as.numeric(a)))
    checked <- length(a)
  } else if (e$dataset == 'glyhub_PXD046637_N_Lung') {
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
    for (j in seq_len(ncol(md$source_row))) {
      batch <- colnames(md$source_row)[j]
      d <- read.delim(
        file.path(evidence, 'lung-glyco-results', batch, 'ion.tsv'),
        check.names = FALSE,
        quote = '',
        comment.char = '',
        na.strings = ''
      )
      ix <- which(!is.na(md$source_row[, j]))
      sr <- md$source_row[ix, j] - 1L
      cols <- seq.int((j - 1L) * 11L + 1L, j * 11L)
      stopifnot(identical(
        as.numeric(as.matrix(d[sr, channels])),
        as.numeric(a[ix, cols])
      ))
      checked <- checked + length(ix) * 11L
    }
  } else {
    stop('No independent source verifier for ', e$dataset)
  }
  results[[e$dataset]] <- list(
    dimensions = dim(x),
    source_cells_compared = checked,
    matrix_cells = length(a),
    source_values_exact = e$dataset != "glyhub_MSV000089484_N_HCC",
    source_values_exact_in_metadata = TRUE,
    reused_completed_check = reused,
    reused_evidence = if (reused) prior[[e$dataset]]$evidence else NULL,
    missing = sum(is.na(a)),
    zero = sum(a == 0, na.rm = TRUE),
    typed_composition_missing = sum(is.na(
      SummarizedExperiment::rowData(x)$glycan_composition
    )),
    source_scale = md$assay_scale,
    sha256 = e$sha256
  )
  cat(e$dataset, checked, 'source cells verified\n')
  rm(x, a)
  gc()
}
jsonlite::write_json(
  results,
  'data-raw/_shared/reports/noncptac/validation-all.json',
  pretty = TRUE,
  auto_unbox = TRUE
)
