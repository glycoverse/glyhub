test_that("Mgat3 study combines source panels without invented feature alignment", {
  x <- glyhub_GPST000027_031_N
  m <- S4Vectors::metadata(x)
  rd <- SummarizedExperiment::rowData(x)
  cd <- SummarizedExperiment::colData(x)
  expect_identical(dim(x), c(338L, 6L))
  expect_true(methods::validObject(x))
  expect_identical(m$accessions, c("GPST000027", "GPST000031"))
  expect_identical(sum(m$source_coverage), 1250L)
  expect_identical(sum(m$processing_masks$not_measured), 778L)
  expect_identical(sum(m$processing_masks$zero_to_na), 324L)
  expect_identical(sum(is.na(SummarizedExperiment::assay(x))), 1102L)
  expect_true(all(m$source_coverage[1:51, 1:2]))
  expect_true(all(m$source_coverage[52:338, 3:6]))
  expect_false(any(m$source_coverage[1:51, 3:6]))
  expect_false(any(m$source_coverage[52:338, 1:2]))
  expect_identical(m$processing_masks$not_measured, !m$source_coverage)
  expect_true(all(is.na(m$raw_abundance[!m$source_coverage])))
  expect_identical(sum(!is.na(rd$glycan_composition)), 306L)
  expect_identical(sum(is.na(rd$glycan_composition)), 32L)
  expect_false("glycan_structure" %in% names(rd))
  expect_false(anyDuplicated(rownames(x)) > 0)
  expect_false(anyDuplicated(colnames(x)) > 0)
  expect_identical(cd$tissue, c(rep("brain", 2), rep("kidney", 4)))
  expect_true(all(is.na(cd$source_run_id[1:2])))
  expect_true(all(is.na(cd$source_raw_file[1:2])))
  expect_identical(cd$source_run_id_candidate[1:2], c("15071834", "15071835"))
  expect_identical(
    cd$raw_file_mapping_status,
    c(rep("inferred_candidate", 2), rep("exact_source_id_match", 4))
  )
  for (name in names(m$panel_maps)) {
    map <- m$panel_maps[[name]]
    raw <- m$raw_abundance[map$rows, map$columns, drop = FALSE]
    percent <- m$source_relative_abundance[map$rows, map$columns, drop = FALSE]
    dimnames(raw) <- dimnames(percent) <- map$original_dimnames
    expect_identical(raw, m$panels[[name]]$raw_abundance)
    expect_identical(percent, m$panels[[name]]$source_relative_abundance)
    expect_equal(
      as.character(rd$glycan_composition[map$rows]),
      as.character(m$panel_row_data[[name]]$glycan_composition)
    )
  }
})

test_that("brain table retains printed precision and source coverage limitations", {
  x <- glyhub_GPST000027_031_N
  m <- S4Vectors::metadata(x)
  p <- m$panels$glyhub_GPST000027_N_Brain
  expect_identical(dim(p$raw_abundance), c(51L, 2L))
  expect_equal(unname(colSums(p$raw_abundance)), c(1887230, 1762838))
  expect_identical(as.integer(colSums(p$raw_abundance == 0)), c(3L, 12L))
  denominator <- p$source_relative_abundance_provenance$denominator
  expect_equal(unname(denominator), c(979000, 745500))
  expect_true(all(
    abs(
      p$source_relative_abundance -
        sweep(p$raw_abundance, 2L, denominator, "/") * 100
    ) <=
      0.05000000001
  ))
  expect_identical(
    p$source_relative_abundance_provenance$printed_decimal_places,
    1L
  )
  expect_identical(
    p$source_relative_abundance_provenance$is_abundance_assay,
    FALSE
  )
  expect_equal(
    p$source_relative_abundance["1", ],
    c("Mgat3+/+" = 39.0, "Mgat3-/-" = 37.8)
  )
  expect_identical(
    p$transcription_validation$independent$independent_numeric_cells_compared,
    204L
  )
  expect_length(p$transcription_validation$independent$differences, 0L)
  expect_true(
    p$source_identity$public_quantitative_columns_do_not_establish_biological_n
  )
})
