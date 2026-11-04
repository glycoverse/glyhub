test_that("legacy scales are tied to reviewed dataset hashes", {
  catalog <- glyhub_catalog()
  raw <- subset(catalog, dataset == "glyhub_GPST000738_N_B4GalT1")
  log2 <- subset(catalog, dataset == "glyhub_PXD065283_N_DiscoverySelected")

  expect_identical(.glyhub_legacy_scale(raw), "raw")
  expect_identical(.glyhub_legacy_scale(log2), "log2")
  raw$sha256 <- paste(rep("0", 64), collapse = "")
  expect_error(.glyhub_legacy_scale(raw), "No verified abundance scale")
  for (dataset in c(
    "glyhub_GPST000601_N_glycopeptides",
    "glyhub_GPST000667_N"
  )) {
    unknown <- catalog[catalog$dataset == dataset, , drop = FALSE]
    expect_error(.glyhub_legacy_scale(unknown), "No verified abundance scale")
  }
  log2$dataset <- "unknown_dataset"
  expect_error(.glyhub_legacy_scale(log2), "No verified abundance scale")
})

test_that("legacy metadata upgrades preserve existing and explicit scales", {
  entry <- glyhub_catalog()[1, , drop = FALSE]
  x <- make_test_object()
  local_mocked_bindings(.glyhub_legacy_scale = function(...) {
    stop("Existing scale must not be inferred")
  })
  for (scale in c("raw", "log2", "logx")) {
    glyexp::metadata(x)$scale <- scale
    expect_identical(.glyhub_upgrade_metadata(x, entry), x)
  }
  metadata <- glyexp::metadata(x)
  metadata["scale"] <- list(NULL)
  glyexp::metadata(x) <- metadata
  expect_identical(.glyhub_upgrade_metadata(x, entry), x)
})

test_that("legacy rda and rds load with reviewed scales without changing bytes", {
  for (format in c("rda", "rds")) {
    for (scale in c("raw", "log2", "logx")) {
      x <- make_test_object()
      glyexp::metadata(x)$scale <- NULL
      glyexp::metadata(x)$source_note <- "preserve provenance"
      expected <- x
      glyexp::metadata(expected)$scale <- scale
      cache <- tempfile()
      on.exit(unlink(cache, recursive = TRUE), add = TRUE)
      f <- tempfile()
      on.exit(unlink(f), add = TRUE)
      entry <- glyhub_catalog()[1, , drop = FALSE]
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
        .glyhub_download_file = function(url, path) file.copy(f, path),
        .glyhub_legacy_scale = function(...) scale
      )
      actual <- glyhub_load(entry$dataset, cache_dir = cache)
      expect_identical(actual, expected)
      expect_true(methods::validObject(actual))
      expect_identical(
        glyhub_load(entry$dataset, cache_dir = cache, offline = TRUE),
        expected
      )
      cached <- .glyhub_resource_file(entry, cache, FALSE, TRUE)
      expect_identical(
        digest::digest(file = cached, algo = "sha256"),
        entry$sha256
      )
    }
  }
})

test_that("legacy glycoproteomic metadata is upgraded without reclassification", {
  base <- make_test_object()
  rows <- SummarizedExperiment::rowData(base)
  rows$protein <- c("P1", "P2")
  rows$protein_site <- c(1L, 2L)
  x <- glyexp::GlycoproteomicSE(
    SummarizedExperiment::assay(base),
    rowData = rows,
    metadata = list(glycan_type = "N", scale = "raw")
  )
  glyexp::metadata(x)$scale <- NULL
  expected <- x
  glyexp::metadata(expected)$scale <- "raw"
  entry <- glyhub_catalog()[1, , drop = FALSE]
  local_mocked_bindings(.glyhub_legacy_scale = function(...) "raw")

  result <- .glyhub_upgrade_metadata(x, entry)
  expect_identical(result, expected)
  expect_s4_class(result, "GlycoproteomicSE")
  expect_true(methods::validObject(result))
})
