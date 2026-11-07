# Run from the repository root. These source receipts are excluded from the package.
library(testthat)
manifest <- read.delim("inst/extdata/manifest.tsv", stringsAsFactors = FALSE)
staged <- manifest[manifest$storage == "staged", ]
receipt_paths <- list.files(
  "data-raw",
  "receipt[.]json$",
  recursive = TRUE,
  full.names = TRUE
)
test_that("all staged receipts identify the registered bytes", {
  for (i in seq_len(nrow(staged))) {
    entry <- staged[i, ]
    suffix <- if (entry$kind == "raw") {
      "-source-receipt.json"
    } else {
      "-receipt.json"
    }
    path <- receipt_paths[
      basename(receipt_paths) == paste0(entry$dataset, suffix)
    ]
    expect_length(path, 1L)
    receipt <- jsonlite::fromJSON(path, simplifyVector = FALSE)
    registered <- receipt$manifest[[1]]
    expect_identical(registered$dataset, entry$dataset)
    expect_identical(registered$sha256, entry$sha256)
    expect_equal(registered$bytes, entry$bytes)
    if (entry$kind == "raw") {
      expect_identical(receipt$source_provenance$sha256, entry$sha256)
    }
  }
})
