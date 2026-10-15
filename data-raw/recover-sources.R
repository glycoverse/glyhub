# Restore externally hosted source files without redistributing publisher archives.
# Run from the package root. No archive scripts or executable files are executed.
recover_sources <- function(manifest) {
  records <- jsonlite::fromJSON(manifest, simplifyVector = FALSE)
  sha256 <- function(path) {
    digest::digest(file = path, algo = 'sha256', serialize = FALSE)
  }
  old_timeout <- getOption('timeout')
  options(timeout = max(1800, old_timeout))
  on.exit(options(timeout = old_timeout), add = TRUE)
  archives <- new.env(parent = emptyenv())
  temp <- tempfile('glyhub-sources-')
  dir.create(temp)
  on.exit(unlink(temp, recursive = TRUE), add = TRUE)
  for (record in records) {
    target <- record$path
    stopifnot(
      startsWith(target, 'data-raw/'),
      !grepl('(^|/)\\.\\.(/|$)', target)
    )
    if (file.exists(target)) {
      stopifnot(identical(sha256(target), record$sha256))
      next
    }
    dir.create(dirname(target), recursive = TRUE, showWarnings = FALSE)
    chain <- if (!is.null(record$archive_members)) {
      unlist(record$archive_members)
    } else {
      record$archive_member
    }
    if (length(chain) > 0) {
      key <- if (!is.null(record$archive_url)) {
        record$archive_url
      } else {
        record$url
      }
      if (!exists(key, archives, inherits = FALSE)) {
        archive <- tempfile(tmpdir = temp, fileext = '.zip')
        download.file(key, archive, mode = 'wb', method = 'libcurl')
        if (!is.null(record$archive_sha256)) {
          stopifnot(identical(sha256(archive), record$archive_sha256))
        }
        assign(key, archive, archives)
      }
      archive <- get(key, archives, inherits = FALSE)
      for (member in chain) {
        members <- unzip(archive, list = TRUE)$Name
        stopifnot(
          member %in% members,
          !grepl('(^|/)\\.\\.(/|$)', member),
          !startsWith(member, '/')
        )
        destination <- tempfile(tmpdir = temp)
        dir.create(destination)
        unzip(archive, files = member, exdir = destination)
        downloaded <- file.path(destination, member)
        archive <- downloaded
      }
    } else {
      downloaded <- tempfile(tmpdir = temp)
      download.file(record$url, downloaded, mode = 'wb', method = 'libcurl')
    }
    stopifnot(identical(sha256(downloaded), record$sha256))
    stopifnot(file.copy(downloaded, target, overwrite = FALSE))
  }
  invisible(TRUE)
}
