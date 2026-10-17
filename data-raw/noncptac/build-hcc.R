args <- commandArgs(trailingOnly = TRUE)
evidence <- normalizePath(args[1], mustWork = TRUE)
cache <- args[2]
source('data-raw/noncptac/convert.R')
source('data-raw/noncptac/register.R')
source('data-raw/noncptac/convert-hcc.R')
p <- file.path(evidence, 'hcc-epmc-supp/ADVS-13-e16299-s002.xlsx')
prov <- list(
  source_url = 'https://www.ebi.ac.uk/europepmc/webservices/rest/PMC13088319/supplementaryFiles',
  workbook = 'ADVS-13-e16299-s002.xlsx',
  workbook_sha256 = digest::digest(file = p, algo = 'sha256'),
  archive_sha256 = digest::digest(
    file = file.path(evidence, 'hcc-epmc-supplementary.zip'),
    algo = 'sha256'
  ),
  retrieved = '2026-10-17'
)
for (sheet in c('Supplementary Data1', 'Supplementary Data3')) {
  x <- noncptac_hcc(p, sheet, c(prov, list(sheet = sheet)))
  name <- if (sheet == 'Supplementary Data1') {
    'glyhub_PXD065283_N_QC'
  } else {
    'glyhub_PXD065283_N_DiscoverySelected'
  }
  register(x, name)
  rm(x)
  gc()
}
