# Recover the unchanged supplementary workbook from its public archive.
ensure_gpst000599_source <- function() {
  target <- 'data-raw/GPST000599/mmc4.xlsx'
  expected <- '30931f27058092c02d531a8ae1650b5c81181b79e3ac3cf35904b23ee937f910'
  url <- 'https://www.ebi.ac.uk/europepmc/webservices/rest/PMC12794580/supplementaryFiles'
  if (!requireNamespace('digest', quietly=TRUE)) {
    stop('The CRAN package digest is required to verify the retained source SHA-256.')
  }
  sha <- function(path) digest::digest(file=path, algo='sha256', serialize=FALSE)
  if (file.exists(target)) {
    if (!identical(sha(target), expected)) stop('Existing GPST000599 mmc4.xlsx checksum mismatch; file left unchanged.')
    return(invisible(target))
  }
  work <- tempfile('glyhub-source-599-')
  dir.create(work)
  on.exit(unlink(work, recursive=TRUE), add=TRUE)
  zip <- file.path(work,'supplementary.zip')
  old_timeout <- getOption('timeout')
  options(timeout=max(1800, old_timeout))
  on.exit(options(timeout=old_timeout), add=TRUE)
  status <- utils::download.file(url, zip, mode='wb', quiet=FALSE)
  if (!identical(status,0L)) stop('Public supplementary-file download failed; source remains unavailable.')
  members <- utils::unzip(zip, list=TRUE)$Name
  member <- members[basename(members)=='mmc4.xlsx']
  if (length(member)!=1L || grepl('(^/|(^|/)\\.\\.(/|$))',member)) stop('Unexpected supplementary archive layout.')
  utils::unzip(zip, files=member, exdir=work)
  original <- file.path(work,member)
  if (!identical(sha(original),expected)) stop('Downloaded GPST000599 source SHA-256 mismatch; no source was installed.')
  stopifnot(file.copy(original,target,overwrite=FALSE))
  stopifnot(identical(sha(target),expected))
  message('Recovered unchanged GPST000599/mmc4.xlsx and verified SHA-256.')
  invisible(target)
}
ensure_gpst000599_source()
