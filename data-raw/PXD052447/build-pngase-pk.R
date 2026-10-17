args <- commandArgs(trailingOnly = TRUE)
evidence <- normalizePath(args[1], mustWork = TRUE)
cache <- args[2]
source('data-raw/_shared/noncptac/convert.R')
source('data-raw/PXD052447/convert-raw-psm.R')
source('data-raw/_shared/noncptac/register.R')
p <- file.path(evidence, 'range-downloads/PNGase_PK_glyco_psm.tsv')
stopifnot(file.info(p)$size == 169058291)
ref <- read.delim(
  p,
  check.names = FALSE,
  quote = '',
  comment.char = '',
  na.strings = ''
)
patterns <- c(PNGase = '_Glyco_PNGase_', ProteinaseK = '_Glyco_ProteinaseK_')
partition <- lapply(patterns, function(x) grepl(x, ref$Spectrum, fixed = TRUE))
stopifnot(all(Reduce(`+`, partition) == 1L))
for (ex in names(patterns)) {
  ann <- data.frame(
    source_sample = sprintf('sample-%02d', 1:8),
    treatment = c(rep('ctl', 4), rep(ex, 4)),
    replicate = rep(paste0('rep', 1:4), 2)
  )
  prov <- list(
    source_url = 'https://ftp.pride.ebi.ac.uk/pride/data/archive/2025/02/PXD052447/PNGase_PK_glyco_psm.tsv',
    file_sha256 = digest::digest(file = p, algo = 'sha256'),
    retrieved = '2026-10-17',
    sample_annotation_source = 'https://github.com/miralea/DQGlyco/blob/7330542fe6f2668993c21dcc6b9cde8a3b2bddad/analysis/data_analysis/04_surfaceacc_glycoproteomics_HEK.Rmd',
    acquisition_partition = patterns[[ex]],
    partition_exhaustive_and_exclusive = TRUE
  )
  x <- noncptac_raw_psm(
    p,
    ann,
    'PXD052447',
    ex,
    prov,
    spectrum_pattern = patterns[[ex]]
  )
  a <- as.matrix(ref[
    partition[[ex]],
    grep('^sample-[0-9]{2}$', names(ref)),
    drop = FALSE
  ])
  stopifnot(identical(
    as.numeric(a),
    as.numeric(SummarizedExperiment::assay(x))
  ))
  register(x, paste0('glyhub_PXD052447_N_', ex), compression = 'gzip')
  rm(x, a)
  gc()
}
