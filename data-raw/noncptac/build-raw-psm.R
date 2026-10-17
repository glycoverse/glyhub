# Build only requested completed downloads; do not consume partial files.
args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) >= 2L)
evidence <- normalizePath(args[1], mustWork = TRUE)
cache <- args[2]
source('data-raw/noncptac/convert.R')
source('data-raw/noncptac/convert-raw-psm.R')
source('data-raw/noncptac/register.R')
specs <- data.frame(
  experiment = c('Tissues', 'Solubility', 'TwoFF', 'Microbiome'),
  file = c(
    'Mouse_tissues_N_glyco_psm.tsv',
    'Mouse_brain_SPP_glyco_psm.tsv',
    '2FF_timecourse_glyco_psm.tsv',
    'Microbiome_N_glyco_psm.tsv'
  ),
  annotation = c(
    'TMT_layout_tissue.csv',
    'SPP_TMT_annotation.tsv',
    '2FF_TMT_annotation.tsv',
    'TMT_brain_microbiome_annotation.tsv'
  ),
  bytes = c(158216266, 63730317, 67259668, 125084522)
)
if (length(args) > 2) {
  specs <- specs[specs$experiment %in% args[-c(1, 2)], , drop = FALSE]
}
for (i in seq_len(nrow(specs))) {
  s <- specs[i, ]
  path <- file.path(evidence, 'range-downloads', s$file)
  stopifnot(file.exists(path), file.info(path)$size == s$bytes)
  ap <- file.path(evidence, 'range-downloads', s$annotation)
  if (grepl('csv$', ap)) {
    ann <- read.csv(ap, stringsAsFactors = FALSE)
  } else {
    ann <- read.delim(ap, stringsAsFactors = FALSE)
  }
  names(ann)[1] <- 'source_sample'
  if (s$experiment == 'Solubility') {
    ann$source_sample <- gsub('-', '', ann$source_sample, fixed = TRUE)
  }
  stopifnot(!anyDuplicated(ann$source_sample))
  provenance <- list(
    source_url = paste0(
      'https://ftp.pride.ebi.ac.uk/pride/data/archive/2025/02/PXD052447/',
      s$file
    ),
    file_sha256 = digest::digest(file = path, algo = 'sha256'),
    file_bytes = s$bytes,
    annotation_url = paste0(
      'https://ftp.pride.ebi.ac.uk/pride/data/archive/2025/02/PXD052447/',
      s$annotation
    ),
    annotation_sha256 = digest::digest(file = ap, algo = 'sha256'),
    retrieved = '2026-10-17',
    remote_checksum = 'PRIDE checksum field empty; exact HTTP ranges and total file size verified; SHA256 recorded locally'
  )
  x <- noncptac_raw_psm(path, ann, 'PXD052447', s$experiment, provenance)
  name <- paste0('glyhub_PXD052447_N_', s$experiment)
  # Independently re-read numeric source columns and compare every serialized cell.
  ref <- read.delim(
    path,
    check.names = FALSE,
    quote = '',
    comment.char = '',
    na.strings = ''
  )
  cols <- grep('^sample-?[0-9]{2}$', names(ref))
  stopifnot(identical(
    as.numeric(as.matrix(ref[cols])),
    as.numeric(SummarizedExperiment::assay(x))
  ))
  register(x, name, compression = 'gzip')
  reloaded <- readRDS(file.path(
    'data-raw/noncptac/assets',
    paste0(name, '.rds')
  ))
  stopifnot(identical(
    SummarizedExperiment::assay(reloaded),
    SummarizedExperiment::assay(x)
  ))
  rm(x, ref, reloaded)
  gc()
}
