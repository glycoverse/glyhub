# Recover the unchanged public quantitative workbook and verify before installation.
ensure_gpst000671_source <- function() {
  target <- "data-raw/GPST000671/Supplementary File_4_Glycomics.xlsx"
  expected <- "c2888eafe6e1f7f7d8c80fcf09179e7376546eb389bcbbec37e6d43a01a5286b"
  sha <- function(path) {
    digest::digest(file = path, algo = "sha256", serialize = FALSE)
  }
  if (file.exists(target)) {
    stopifnot(identical(sha(target), expected))
    return(invisible(target))
  }
  temporary <- tempfile(fileext = ".xlsx")
  on.exit(unlink(temporary), add = TRUE)
  old_timeout <- getOption("timeout")
  options(timeout = max(1800, old_timeout))
  on.exit(options(timeout = old_timeout), add = TRUE)
  download.file(
    "https://glycopost.glycosmos.org/data/GPST000671.0/Supplementary%20File_4_Glycomics.xlsx",
    temporary,
    mode = "wb",
    method = "libcurl"
  )
  stopifnot(identical(sha(temporary), expected))
  stopifnot(file.copy(temporary, target, overwrite = FALSE))
  invisible(target)
}
ensure_gpst000671_source()
