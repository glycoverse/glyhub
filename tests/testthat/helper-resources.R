# Scientific regression tests use maintainer staging files when available.
# Installed-package checks exercise the same loader with synthetic fixtures.
load_test_dataset <- function(dataset) {
  path <- testthat::test_path(
    "..",
    "..",
    "data-raw",
    "bundled-build",
    paste0(dataset, ".rda")
  )
  if (!file.exists(path)) {
    testthat::skip("Scientific regression requires maintainer source assets")
  }
  catalog <- glyhub_catalog()
  entry <- catalog[catalog$dataset == dataset, , drop = FALSE]
  cache <- tempfile()
  on.exit(unlink(cache, recursive = TRUE))
  directory <- file.path(cache, entry$version)
  dir.create(directory, recursive = TRUE)
  file.copy(
    path,
    file.path(directory, paste0(entry$sha256, "-", entry$filename))
  )
  glyhub_load(dataset, cache_dir = cache, offline = TRUE)
}

make_test_object <- function() {
  rd <- S4Vectors::DataFrame(row.names = c("a", "b"))
  rd$glycan_composition <- rep(
    glyrepr::glycan_composition(c(Hex = 3, HexNAc = 2)),
    2
  )
  glyexp::GlycomicSE(
    matrix(c(1, NA, 3, 4), 2, dimnames = list(c("a", "b"), c("s1", "s2"))),
    rowData = rd,
    metadata = list(glycan_type = "N")
  )
}
