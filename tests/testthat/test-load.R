test_that("all datasets and their convenience functions use external storage", {
  x <- glyhub_catalog()
  expect_equal(nrow(x), 96L)
  expect_equal(anyDuplicated(x$dataset), 0L)
  expect_equal(sum(x$storage == "bundled"), 0L)
  expect_equal(sum(x$storage == "release"), 91L)
  expect_equal(nrow(glyhub_catalog("raw")), 8L)
  expect_equal(nrow(glyhub_catalog("all")), 104L)
  expect_match(x$sha256, "^[a-f0-9]{64}$")
  expect_setequal(
    getNamespaceExports("glyhub"),
    c("glyhub_load", "glyhub_catalog", x$dataset)
  )
  expect_equal(nrow(utils::data(package = "glyhub")$results), 0L)
  for (name in x$dataset) {
    expect_type(getExportedValue("glyhub", name), "closure")
  }
  expect_identical(
    list.files(system.file("extdata", package = "glyhub"), recursive = TRUE),
    "manifest.tsv"
  )
  released <- x[x$storage == "release", ]
  expect_identical(
    released$url,
    paste0(
      "https://github.com/glycoverse/glyhub/releases/download/",
      released$version,
      "/",
      released$filename
    )
  )
})

test_that("raw resources download once and support offline cache and refresh", {
  cache <- tempfile()
  on.exit(unlink(cache, recursive = TRUE))
  contents <- charToRaw("source bytes")
  entry <- glyhub_catalog("raw")[1, , drop = FALSE]
  entry$bytes <- length(contents)
  entry$sha256 <- digest::digest(contents, algo = "sha256", serialize = FALSE)
  calls <- 0L
  local_mocked_bindings(
    glyhub_catalog = function(...) entry,
    .glyhub_download_file = function(url, path) {
      calls <<- calls + 1L
      writeBin(contents, path)
    }
  )
  p <- glyhub_load(entry$dataset, "raw", cache_dir = cache)
  expect_identical(readBin(p, "raw", 100), contents)
  expect_identical(
    glyhub_load(entry$dataset, "raw", cache_dir = cache, offline = TRUE),
    p
  )
  expect_equal(calls, 1L)
  glyhub_load(entry$dataset, "raw", cache_dir = cache, refresh = TRUE)
  expect_equal(calls, 2L)
  writeBin(charToRaw("bad"), p)
  expect_snapshot(
    error = TRUE,
    glyhub_load(entry$dataset, "raw", cache_dir = cache, offline = TRUE)
  )
  glyhub_load(entry$dataset, "raw", cache_dir = cache)
  expect_equal(calls, 3L)
})

test_that("invalid downloads never replace a valid cache entry", {
  cache <- tempfile()
  on.exit(unlink(cache, recursive = TRUE))
  contents <- charToRaw("good")
  entry <- glyhub_catalog("raw")[1, , drop = FALSE]
  entry$bytes <- length(contents)
  entry$sha256 <- digest::digest(contents, algo = "sha256", serialize = FALSE)
  local_mocked_bindings(
    glyhub_catalog = function(...) entry,
    .glyhub_download_file = function(url, path) writeBin(contents, path)
  )
  p <- glyhub_load(entry$dataset, "raw", cache_dir = cache)
  local_mocked_bindings(.glyhub_download_file = function(url, path) {
    writeBin(charToRaw("evil"), path)
  })
  expect_snapshot(
    error = TRUE,
    glyhub_load(entry$dataset, "raw", cache_dir = cache, refresh = TRUE)
  )
  expect_identical(readBin(p, "raw", 100), contents)
  expect_length(
    list.files(dirname(p), all.files = TRUE, pattern = "^\\.glyhub-"),
    0L
  )
})

test_that("interrupted downloads are cleaned up", {
  cache <- tempfile()
  on.exit(unlink(cache, recursive = TRUE))
  local_mocked_bindings(.glyhub_download_file = function(url, path) {
    writeLines("partial", path)
    stop("Interrupted test transfer")
  })
  expect_snapshot(
    error = TRUE,
    glyhub_load("glyhub_CPTAC_CCRCC", cache_dir = cache)
  )
  expect_length(list.files(cache, recursive = TRUE, all.files = TRUE), 0L)
})

test_that("unknown identifiers and invalid options fail before downloads", {
  expect_snapshot(error = TRUE, glyhub_load("unknown"))
  expect_snapshot(
    error = TRUE,
    glyhub_load("glyhub_GPST000738_N_B4GalT1", kind = "raw")
  )
  expect_snapshot(
    error = TRUE,
    glyhub_load("glyhub_CPTAC_CCRCC", refresh = TRUE, offline = TRUE)
  )
  expect_snapshot(error = TRUE, glyhub_load("glyhub_CPTAC_CCRCC", offline = NA))
})

test_that("external rda and rds use the same object-loading interface", {
  x <- make_test_object()
  for (format in c("rda", "rds")) {
    cache <- tempfile()
    on.exit(unlink(cache, recursive = TRUE), add = TRUE)
    f <- tempfile()
    on.exit(unlink(f), add = TRUE)
    entry <- subset(glyhub_catalog(), storage == "release")[1, , drop = FALSE]
    entry$format <- format
    if (format == "rds") {
      saveRDS(x, f)
    } else {
      e <- new.env()
      e[[entry$dataset]] <- x
      save(list = entry$dataset, file = f, envir = e)
    }
    entry$bytes <- file.info(f)$size
    entry$sha256 <- digest::digest(file = f, algo = "sha256")
    local_mocked_bindings(
      glyhub_catalog = function(...) entry,
      .glyhub_download_file = function(url, path) file.copy(f, path)
    )
    y <- glyhub_load(entry$dataset, cache_dir = cache)
    expect_identical(y, x)
    expect_identical(
      getExportedValue("glyhub", entry$dataset)(
        cache_dir = cache,
        offline = TRUE
      ),
      x
    )
    expect_identical(
      glyhub_load(entry$dataset, cache_dir = cache, offline = TRUE),
      x
    )
  }
})
