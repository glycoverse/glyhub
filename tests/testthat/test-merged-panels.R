test_that("merged panels conserve every source measurement and its missingness", {
  entries <- utils::data(package = "glyhub")$results[, "Item"]
  for (name in entries) {
    x <- getExportedValue("glyhub", name)
    m <- S4Vectors::metadata(x)
    if (is.null(m$panel_maps)) {
      next
    }
    a <- SummarizedExperiment::assay(x)
    expect_identical(m$processing_masks$not_measured, !m$source_coverage)
    expect_true(all(is.na(a[!m$source_coverage])))
    expect_identical(
      m$processing_masks$source_missing,
      m$source_coverage & is.na(m$raw_abundance)
    )
    covered <- matrix(FALSE, nrow(x), ncol(x))
    for (panel in names(m$panel_maps)) {
      map <- m$panel_maps[[panel]]
      p <- m$panels[[panel]]
      expect_false(anyDuplicated(map$rows) > 0)
      expect_false(anyDuplicated(map$columns) > 0)
      expect_false(any(covered[map$rows, map$columns, drop = FALSE]))
      covered[map$rows, map$columns] <- TRUE
      raw <- m$raw_abundance[map$rows, map$columns, drop = FALSE]
      dimnames(raw) <- map$original_dimnames
      expect_identical(raw, p$raw_abundance, info = panel)
      expected <- p$raw_abundance
      change <- !is.na(expected) & expected == 0
      if (!is.null(p$processing_masks$conflict)) {
        change <- change | p$processing_masks$conflict
      }
      expected[change] <- NA_real_
      actual <- a[map$rows, map$columns, drop = FALSE]
      dimnames(actual) <- map$original_dimnames
      expect_identical(actual, expected, info = panel)
      expect_identical(nrow(m$panel_row_data[[panel]]), nrow(raw))
      expect_identical(nrow(m$panel_col_data[[panel]]), ncol(raw))
    }
    expect_identical(unname(covered), unname(m$source_coverage))
  }
})
