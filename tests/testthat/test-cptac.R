test_that("catalog provides complete versioned and checksummed resources", {
  catalog <- glyhub_cptac_catalog()
  expect_equal(nrow(catalog), 16L)
  expect_setequal(
    catalog$cohort,
    c("CCRCC", "COAD", "HGSC", "HNSCC", "LSCC", "LUAD", "PDAC", "UCEC")
  )
  expect_equal(anyDuplicated(paste(catalog$cohort, catalog$kind)), 0L)
  expect_match(catalog$sha256, "^[a-f0-9]{64}$")
  expect_match(
    catalog$url,
    "^https://github.com/glycoverse/glyhub/releases/download/cptac-data-v1/"
  )
  expect_equal(catalog$storage[catalog$kind == "raw"], rep("release", 8L))
  curated <- subset(catalog, kind == "curated")
  expect_identical(
    curated$storage,
    ifelse(curated$bytes <= 2 * 1024^2, "bundled", "release")
  )
  for (name in unique(catalog$dataset)) {
    expect_type(getExportedValue("glyhub", name), "closure")
  }
})

test_that("download caches verified files and supports offline reads and refresh", {
  cache <- tempfile()
  dir.create(cache)
  on.exit(unlink(cache, recursive = TRUE))
  contents <- charToRaw("verified source bytes")
  entry <- glyhub_cptac_catalog()[1, , drop = FALSE]
  entry$storage <- "release"
  entry$bytes <- length(contents)
  entry$sha256 <- digest::digest(contents, algo = "sha256", serialize = FALSE)
  calls <- 0L
  local_mocked_bindings(
    glyhub_cptac_catalog = function() entry,
    .cptac_download_file = function(url, path) {
      calls <<- calls + 1L
      writeBin(contents, path)
    }
  )
  path <- glyhub_cptac_download(entry$cohort, entry$kind, cache)
  expect_identical(readBin(path, "raw", 100), contents)
  expect_identical(
    glyhub_cptac_download(entry$dataset, entry$kind, cache, offline = TRUE),
    path
  )
  expect_equal(calls, 1L)
  glyhub_cptac_download(entry$cohort, entry$kind, cache, refresh = TRUE)
  expect_equal(calls, 2L)
  writeBin(charToRaw("corrupt"), path)
  expect_snapshot(
    error = TRUE,
    glyhub_cptac_download(entry$cohort, entry$kind, cache, offline = TRUE)
  )
  glyhub_cptac_download(entry$cohort, entry$kind, cache)
  expect_equal(calls, 3L)
  expect_identical(readBin(path, "raw", 100), contents)
})

test_that("bad downloads never replace a valid cached file", {
  cache <- tempfile()
  dir.create(cache)
  on.exit(unlink(cache, recursive = TRUE))
  contents <- charToRaw("good")
  entry <- glyhub_cptac_catalog()[1, , drop = FALSE]
  entry$storage <- "release"
  entry$bytes <- length(contents)
  entry$sha256 <- digest::digest(contents, algo = "sha256", serialize = FALSE)
  local_mocked_bindings(
    glyhub_cptac_catalog = function() entry,
    .cptac_download_file = function(url, path) writeBin(contents, path)
  )
  path <- glyhub_cptac_download(entry$cohort, entry$kind, cache)
  local_mocked_bindings(.cptac_download_file = function(url, path) {
    writeBin(charToRaw("evil"), path)
  })
  expect_snapshot(
    error = TRUE,
    glyhub_cptac_download(entry$cohort, entry$kind, cache, refresh = TRUE)
  )
  expect_identical(readBin(path, "raw", 100), contents)
  expect_length(
    list.files(dirname(path), all.files = TRUE, pattern = "^\\.cptac-"),
    0L
  )
})

test_that("invalid requests fail before attempting network access", {
  expect_snapshot(error = TRUE, glyhub_cptac_download("unknown"))
  expect_snapshot(
    error = TRUE,
    glyhub_CPTAC_CCRCC(offline = TRUE, refresh = TRUE)
  )
  expect_snapshot(error = TRUE, glyhub_CPTAC_CCRCC(offline = NA))
})

test_that("bundled resources are verified offline without populating a cache", {
  cache <- tempfile()
  on.exit(unlink(cache, recursive = TRUE))
  path <- system.file("extdata", "CPTAC", "manifest.tsv", package = "glyhub")
  entry <- glyhub_cptac_catalog()[1, , drop = FALSE]
  entry$storage <- "bundled"
  entry$filename <- "manifest.tsv"
  entry$bytes <- file.info(path)$size
  entry$sha256 <- digest::digest(file = path, algo = "sha256")
  local_mocked_bindings(
    glyhub_cptac_catalog = function() entry,
    .cptac_download_file = function(...) stop("Unexpected network request")
  )
  expect_identical(
    glyhub_cptac_download(entry$cohort, entry$kind, cache, offline = TRUE),
    normalizePath(path)
  )
  expect_identical(dir.exists(cache), FALSE)
})

test_that("interrupted downloads leave no cache entry", {
  cache <- tempfile()
  dir.create(cache)
  on.exit(unlink(cache, recursive = TRUE))
  local_mocked_bindings(.cptac_download_file = function(url, path) {
    writeLines("partial", path)
    stop("Interrupted test transfer")
  })
  expect_snapshot(error = TRUE, glyhub_CPTAC_CCRCC(cache_dir = cache))
  expect_length(list.files(cache, recursive = TRUE, all.files = TRUE), 0L)
})
