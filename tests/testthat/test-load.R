test_that("catalog returns a tibble for every resource kind", {
  expect_s3_class(glyhub_catalog(), "tbl_df")
  for (kind in c("curated", "raw", "all")) {
    catalog <- glyhub_catalog(kind)
    expect_s3_class(catalog, "tbl_df")
    expect_length(intersect(names(catalog), c("n_samples", "n_variables")), 0L)
  }
})

test_that("all datasets and their convenience functions use external storage", {
  x <- glyhub_catalog()
  expect_equal(nrow(x), 144L)
  expect_equal(anyDuplicated(x$dataset), 0L)
  expect_equal(sum(x$storage == "bundled"), 0L)
  expect_equal(sum(x$storage == "release"), 97L)
  expect_equal(nrow(glyhub_catalog("raw")), 40L)
  expect_equal(nrow(glyhub_catalog("all")), 184L)
  expect_match(x$sha256, "^[a-f0-9]{64}$")
  expect_setequal(
    getNamespaceExports("glyhub"),
    c("glyhub_load", "glyhub_catalog", x$dataset)
  )
  expect_equal(nrow(utils::data(package = "glyhub")$results), 0L)
  for (name in x$dataset) {
    expect_type(getExportedValue("glyhub", name), "closure")
  }
  expect_setequal(
    list.files(system.file("extdata", package = "glyhub"), recursive = TRUE),
    c("manifest.tsv", "catalog-metadata.tsv", "literature-source-metadata.json")
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


test_that("catalog metadata describes every curated dataset without loading assets", {
  local_mocked_bindings(.glyhub_download_file = function(...) {
    stop("No downloads")
  })
  x <- glyhub_catalog()
  expect_setequal(unique(x$exp_type), c("glycomics", "glycoproteomics"))
  expect_equal(anyNA(x$glycan_type), FALSE)
  expect_type(x$has_glycan_structures, "logical")
  expect_equal(anyNA(x$has_glycan_structures), FALSE)
  expect_equal(anyNA(x$quant_method), FALSE)
  expect_equal(all(nzchar(x$quant_method)), TRUE)
  raw <- glyhub_catalog("raw")
  expect_equal(raw$exp_type, rep("glycoproteomics", nrow(raw)))
  expect_true(all(is.na(raw$glycan_type) | raw$glycan_type %in% c("N", "O")))
  expect_equal(all(is.na(raw$has_glycan_structures)), TRUE)
  expect_equal(all(is.na(raw$quant_method)), TRUE)
  expect_equal(
    glyhub_catalog("all")$dataset,
    read.delim(system.file(
      "extdata",
      "manifest.tsv",
      package = "glyhub"
    ))$dataset
  )
})

test_that("catalog annotations agree with representative scientific assets", {
  for (name in c(
    "glyhub_GPST000009_O",
    "glyhub_GPST000671_N_Glycoproteomics"
  )) {
    x <- load_test_dataset(name)
    entry <- subset(glyhub_catalog(), dataset == name)
    expect_identical(entry$measurements, ncol(x))
    expect_identical(entry$features, nrow(x))
    expect_identical(entry$glycan_type, S4Vectors::metadata(x)$glycan_type)
    expect_identical(
      entry$exp_type,
      if (methods::is(x, "GlycoproteomicSE")) {
        "glycoproteomics"
      } else {
        "glycomics"
      }
    )
    rd <- SummarizedExperiment::rowData(x)
    expect_identical(
      entry$has_glycan_structures,
      "glycan_structure" %in% names(rd) && any(!is.na(rd$glycan_structure))
    )
    expect_identical(entry$quant_method, S4Vectors::metadata(x)$unit)
  }
})

test_that("catalog metadata stays synchronized with curated asset hashes", {
  manifest <- read.delim(system.file(
    "extdata",
    "manifest.tsv",
    package = "glyhub"
  ))
  curated <- manifest[manifest$kind == "curated", ]
  metadata <- read.delim(system.file(
    "extdata",
    "catalog-metadata.tsv",
    package = "glyhub"
  ))
  expect_equal(anyDuplicated(metadata$dataset), 0L)
  raw <- glyhub_catalog("raw")
  expect_setequal(metadata$dataset, union(curated$dataset, raw$dataset))
  metadata <- metadata[metadata$dataset %in% curated$dataset, , drop = FALSE]
  expect_identical(
    metadata$sha256[match(curated$dataset, metadata$dataset)],
    curated$sha256
  )
})
