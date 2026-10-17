args <- commandArgs(trailingOnly = TRUE)
evidence <- normalizePath(args[1], mustWork = TRUE)
cache <- args[2]
source("data-raw/_shared/scripts/noncptac/register.R")
source("data-raw/PXD011063/convert-glycodia-reports.R")
paths <- sort(list.files(
  file.path(evidence, 'glycodia-reports'),
  pattern = '^20180330_.*xls$',
  full.names = TRUE
))
stopifnot(length(paths) == 10L)
x <- noncptac_glycodia_reports(
  paths,
  list(
    source_url = 'https://ftp.pride.ebi.ac.uk/pride/data/archive/2019/11/PXD011063/',
    file_sha256 = setNames(
      vapply(
        paths,
        function(p) digest::digest(file = p, algo = 'sha256'),
        character(1)
      ),
      basename(paths)
    ),
    retrieved = '2026-10-17'
  )
)
register(x, 'glyhub_PXD011063_O_Dilution', compression = 'gzip')
