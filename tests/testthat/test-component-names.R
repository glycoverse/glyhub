test_that("loading synchronizes historical assay names after scale verification", {
  x <- make_test_object()
  before <- SummarizedExperiment::assay(x)
  historical <- SummarizedExperiment::SummarizedExperiment(
    assays = list(abundance = unname(before))
  )
  # Reproduce a serialized pre-contract object without invoking modern setters.
  methods::slot(x, "assays", check = FALSE) <- methods::slot(
    historical,
    "assays"
  )
  entry <- glyhub_catalog()[1, , drop = FALSE]
  path <- tempfile(fileext = ".rds")
  on.exit(unlink(path))
  saveRDS(x, path)
  entry$format <- "rds"
  entry$bytes <- file.info(path)$size
  entry$sha256 <- digest::digest(file = path, algo = "sha256")
  original_hash <- entry$sha256
  local_mocked_bindings(
    glyhub_catalog = function(...) entry,
    .glyhub_resource_file = function(...) path
  )
  actual <- glyhub_load(entry$dataset, offline = TRUE)
  expect_identical(SummarizedExperiment::assay(actual), before)
  expect_identical(
    dimnames(SummarizedExperiment::assay(actual, withDimnames = FALSE)),
    dimnames(actual)
  )
  expect_identical(
    SummarizedExperiment::rowData(actual),
    SummarizedExperiment::rowData(x)
  )
  expect_identical(
    SummarizedExperiment::colData(actual),
    SummarizedExperiment::colData(x)
  )
  expect_identical(S4Vectors::metadata(actual), S4Vectors::metadata(x))
  expect_identical(digest::digest(file = path, algo = "sha256"), original_hash)
  expect_true(methods::validObject(actual))

  # An unreviewed missing scale must fail before public conversion can default it.
  S4Vectors::metadata(x)$scale <- NULL
  saveRDS(x, path)
  expect_error(
    glyhub_load(entry$dataset, offline = TRUE),
    "No verified abundance scale"
  )
})
