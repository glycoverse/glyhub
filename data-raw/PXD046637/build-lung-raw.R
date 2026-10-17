args <- commandArgs(trailingOnly = TRUE)
evidence <- normalizePath(args[1], mustWork = TRUE)
cache <- args[2]
source('data-raw/_shared/scripts/noncptac/convert.R')
source('data-raw/_shared/scripts/noncptac/register.R')
source('data-raw/PXD046637/convert-lung-raw.R')
paths <- sort(list.files(
  file.path(evidence, 'lung-glyco-results'),
  pattern = '^ion.tsv$',
  recursive = TRUE,
  full.names = TRUE
))
stopifnot(length(paths) == 15L)
p <- file.path(evidence, '41467_2025_57364_MOESM4_ESM.xlsx')
x <- noncptac_lung_raw(
  paths,
  p,
  list(
    source_url = 'https://ftp.pride.ebi.ac.uk/pride/data/archive/2025/02/PXD046637/search.zip',
    archive_member = 'WA269TPNgB3.zip',
    archive_member_crc32 = 2550954298,
    archive_member_bytes = 428799239,
    member_sha256 = digest::digest(
      file = file.path(evidence, 'lung-glyco-results.zip'),
      algo = 'sha256'
    ),
    ion_file_sha256 = setNames(
      vapply(
        paths,
        function(p) digest::digest(file = p, algo = 'sha256'),
        character(1)
      ),
      basename(dirname(paths))
    ),
    processed_alternative_sha256 = digest::digest(file = p, algo = 'sha256'),
    retrieved = '2026-10-17'
  )
)
register(x, 'glyhub_PXD046637_N_Lung', compression = 'gzip')
