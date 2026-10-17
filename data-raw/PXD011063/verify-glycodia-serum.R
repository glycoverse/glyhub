args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) == 2L)
evidence <- normalizePath(args[1], mustWork = TRUE)
devtools::load_all(quiet = TRUE)
x <- glyhub_load(
  'glyhub_PXD011063_O_SerumSA',
  cache_dir = args[2],
  offline = TRUE
)
stopifnot(methods::validObject(x))
a <- SummarizedExperiment::assay(x)
md <- S4Vectors::metadata(x)
stopifnot(identical(a, md$raw_abundance))
links <- md$source_associations
checked <- 0L
for (name in unique(links$source_file)) {
  p <- file.path(evidence, 'glycodia-csv', name)
  header <- names(read.csv(p, nrows = 0, check.names = FALSE))
  selected <- c('FG.MS2TotalPeakArea', 'FG.MS1PeakArea')
  classes <- rep('NULL', length(header))
  classes[match(selected, header)] <- 'numeric'
  d <- read.csv(
    p,
    check.names = FALSE,
    colClasses = classes,
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
e <- subset(glyhub_catalog(), dataset == 'glyhub_PXD011063_O_SerumSA')
result <- list(
  dataset = e$dataset,
  sha256 = e$sha256,
  features = nrow(a),
  measurements = ncol(a),
  compared_source_rows = checked,
  ms2_and_ms1_match = TRUE,
  repeated_associations = md$repeated_source_associations
)
jsonlite::write_json(
  result,
  'data-raw/PXD011063/serum-source-validation.json',
  pretty = TRUE,
  auto_unbox = TRUE
)
print(result)
