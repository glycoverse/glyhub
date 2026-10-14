test_that("all documented datasets satisfy measurement and annotation contracts", {
  entries <- utils::data(package = "glyhub")$results[, "Item"]
  expect_gt(length(entries), 11L)
  expect_false(anyDuplicated(entries) > 0)
  for (name in entries) {
    x <- getExportedValue("glyhub", name)
    expect_true(methods::is(x, "GlycomicSE") || methods::is(x, "GlycoproteomicSE"), info = name)
    expect_true(methods::validObject(x), info = name)
    a <- SummarizedExperiment::assay(x)
    m <- S4Vectors::metadata(x)
    rd <- SummarizedExperiment::rowData(x)
    expect_false(any(a == 0, na.rm = TRUE), info = name)
    expect_false(anyDuplicated(rownames(x)) > 0, info = name)
    expect_false(anyDuplicated(colnames(x)) > 0, info = name)
    expect_true(glyrepr::is_glycan_composition(rd$glycan_composition), info = name)
    if ("glycan_structure" %in% names(rd)) expect_true(glyrepr::is_glycan_structure(rd$glycan_structure), info = name)
    expected <- m$raw_abundance
    changed <- !is.na(expected) & expected == 0
    if (!is.null(m$processing_masks$conflict)) changed <- changed | m$processing_masks$conflict
    expected[changed] <- NA_real_
    expect_identical(a, expected, info = name)
    expect_identical(as.vector(a), m$processing_ledger$curated_value, info = name)
    package_path <- getNamespaceInfo(asNamespace("glyhub"), "path")
    if (dir.exists(file.path(package_path, "man"))) {
      expect_true(file.exists(file.path(package_path, "man", paste0(name, ".Rd"))), info = name)
    } else expect_length(utils::help(name, package = "glyhub", lib.loc = dirname(package_path)), 1L)
  }
})
