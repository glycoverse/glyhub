args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) == 2L)
evidence <- normalizePath(args[1], mustWork = TRUE)
cache <- args[2]
source('data-raw/_shared/scripts/noncptac/convert.R')
source('data-raw/_shared/scripts/noncptac/register.R')
source('data-raw/IPX0011099000/convert-mouse-area.R')
source('data-raw/PXD065283/convert-hcc.R')
source('data-raw/PXD011063/convert-glycodia-reports.R')
paths <- sort(list.files(
  file.path(evidence, 'mouse-glycodecipher'),
  pattern = 'QuantificationArea.txt$',
  recursive = TRUE,
  full.names = TRUE
))
stopifnot(length(paths) == 60L)
archive <- file.path(evidence, 'PD-AD-glycodecipher.rar')
index <- jsonlite::fromJSON(file.path(
  evidence,
  'IPX0011099004-files.json'
))$subdatafilesInfo
expected <- index$sha1[index$fileName == basename(archive)]
stopifnot(digest::digest(file = archive, algo = 'sha1') == expected)
x <- noncptac_mouse_area(
  paths,
  list(
    source_url = 'https://download.iprox.cn/IPX0011099000/IPX0011099004/PD-AD-glycodecipher.rar',
    archive_sha1 = expected,
    archive_sha256 = digest::digest(file = archive, algo = 'sha256'),
    file_sha256 = setNames(
      vapply(
        paths,
        function(p) digest::digest(file = p, algo = 'sha256'),
        character(1)
      ),
      basename(paths)
    ),
    retrieved = '2026-10-17',
    sample_workbook_sha256 = digest::digest(
      file = file.path(evidence, '41467_2025_60437_MOESM3_ESM.xlsx'),
      algo = 'sha256'
    )
  ),
  sample_workbook = file.path(evidence, '41467_2025_60437_MOESM3_ESM.xlsx')
)
register(x, 'glyhub_IPX0011099000_N_Brain', compression = 'gzip')
rm(x)
gc()
