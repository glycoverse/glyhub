test_that("staged datasets have no invented download URL", {
  entry <- subset(
    glyhub_catalog(),
    dataset == "glyhub_PXD065283_N_DiscoverySelected"
  )
  expect_equal(nrow(entry), 1L)
  entry$storage <- "staged"
  entry$url <- ""
  local_mocked_bindings(glyhub_catalog = function(...) entry)
  expect_equal(entry$features, 1038L)
  expect_equal(entry$measurements, 140L)
  cache <- tempfile()
  local_mocked_bindings(.glyhub_download_file = function(...) {
    stop("Download attempted")
  })
  expect_error(
    glyhub_PXD065283_N_DiscoverySelected(cache_dir = cache),
    "locally staged"
  )
  expect_false(dir.exists(cache))
})

test_that("staged assets use the ordinary verified cache", {
  entry <- subset(
    glyhub_catalog(),
    dataset == "glyhub_PXD065283_N_DiscoverySelected"
  )
  entry$storage <- "staged"
  entry$url <- ""
  cache <- tempfile()
  on.exit(unlink(cache, recursive = TRUE))
  directory <- file.path(cache, entry$version)
  dir.create(directory, recursive = TRUE)
  x <- make_test_object()
  file <- tempfile(tmpdir = directory, fileext = ".rds")
  saveRDS(x, file)
  entry$bytes <- file.info(file)$size
  entry$sha256 <- digest::digest(file = file, algo = "sha256")
  file.rename(
    file,
    file.path(directory, paste0(entry$sha256, "-", entry$filename))
  )
  local_mocked_bindings(glyhub_catalog = function(...) entry)
  expect_identical(
    glyhub_PXD065283_N_DiscoverySelected(cache_dir = cache, offline = TRUE),
    x
  )
  expect_error(
    glyhub_PXD065283_N_DiscoverySelected(cache_dir = cache, refresh = TRUE),
    "locally staged"
  )
})

test_that("pGlycoQuant original table is a single released dataset", {
  entry <- subset(glyhub_catalog(), dataset == "glyhub_MSV000089484_N_HCC")
  expect_equal(nrow(entry), 1L)
  expect_equal(entry$features, 11001L)
  expect_equal(entry$measurements, 12L)
  expect_identical(entry$storage, "release")
  expect_identical(entry$version, "data-v0.1.0")
})
