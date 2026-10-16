mgat3_kidney_panel <- function() {
  study <- glyhub_GPST000027_031_N
  m <- S4Vectors::metadata(study)
  name <- "glyhub_GPST000031_N_Kidney"
  map <- m$panel_maps[[name]]
  a <- SummarizedExperiment::assay(study)[map$rows, map$columns, drop = FALSE]
  dimnames(a) <- map$original_dimnames
  glyexp::GlycomicSE(a, rowData = m$panel_row_data[[name]],
    colData = m$panel_col_data[[name]], metadata = m$panels[[name]])
}

test_that("Mgat3 kidney keeps every source feature and unresolved candidate", {
  x <- mgat3_kidney_panel()
  m <- S4Vectors::metadata(x)
  rd <- SummarizedExperiment::rowData(x)
  cd <- SummarizedExperiment::colData(x)
  a <- SummarizedExperiment::assay(x)
  expect_true(methods::validObject(x))
  expect_identical(dim(x), c(287L, 4L))
  expect_identical(length(SummarizedExperiment::assays(x)), 1L)
  expect_identical(m$accession, "GPST000031")
  expect_identical(m$source$sha256,
    "854f238cc3507723d095d810bb6b8e40f6d21c98ebb8a1d51c2f08429e2e7ad2")
  expect_identical(cd$source_run_id, as.character(19060303:19060306))
  expect_identical(colnames(x), c("WT1K_TMT", "KO3K_TMT", "WT2K_TMT", "KO4K_TMT"))
  expect_identical(cd$condition, c("WT", "KO", "WT", "KO"))
  expect_identical(cd$tissue, rep("kidney", 4))
  expect_true(all(is.na(cd$replicate_type)))
  expect_identical(rd$source_excel_row, 5:291)
  expect_identical(length(unique(rd$source_number)), 89L)
  expect_false(anyDuplicated(rownames(x)) > 0)
  expect_identical(sum(is.na(rd$glycan_composition)), 32L)
  expect_identical(sum(!is.na(rd$glycan_composition)), 255L)
  expect_false("glycan_structure" %in% names(rd))
  ambiguous <- rd$composition_status == "multiple_source_candidates"
  expect_identical(is.na(rd$glycan_composition), unname(ambiguous))
  expect_true(all(vapply(rd$source_annotations[ambiguous],
    function(z) length(z$candidate_compositions) > 1L, logical(1))))
  first <- as.list(rd$glycan_composition[1])[[1]]
  expect_equal(unname(first[c("Hex", "Man", "GlcNAc")]), c(3, 3, 2))
  expect_identical(as.integer(colSums(m$raw_abundance == 0)), c(28L, 123L, 29L, 129L))
  expect_identical(sum(rowSums(m$raw_abundance == 0) == 4L), 5L)
  expect_identical(sum(is.na(a)), 309L)
  expect_true(all(m$source_coverage))
  expected <- m$raw_abundance
  expected[expected == 0] <- NA_real_
  expect_identical(a, expected)
  expect_equal(unname(colSums(m$raw_abundance)), c(24329090, 12195700, 20617010, 2123207))
  from_source <- matrix(as.numeric(m$source_table[5:291, 10:13]), 287, 4)
  expect_equal(unname(m$raw_abundance), from_source, tolerance = 1e-12)
})

test_that("Mgat3 kidney percentages retain their high-mannose denominator", {
  x <- mgat3_kidney_panel()
  m <- S4Vectors::metadata(x)
  p <- m$source_relative_abundance_provenance
  expect_identical(p$is_abundance_assay, FALSE)
  expect_identical(p$source_values_preserved, TRUE)
  expect_identical(p$denominator_source_row, 292L)
  expect_equal(unname(p$denominator), c(5061000, 3184000, 4116000, 542800))
  expect_equal(m$source_relative_abundance,
    sweep(m$raw_abundance, 2L, p$denominator, "/") * 100,
    tolerance = 1e-12)
  from_source <- matrix(as.numeric(m$source_table[5:291, 14:17]), 287, 4)
  expect_equal(unname(m$source_relative_abundance), from_source, tolerance = 1e-12)
  expect_identical(sum(m$source_relative_abundance == 0), 309L)
  expect_true(all(colSums(m$source_relative_abundance) > 100))
})
