test_that("prosaposin profiles use the source expression-block labels", {
  x <- load_test_dataset("glyhub_GPST000381_N_Prosaposin")
  m <- S4Vectors::metadata(x)
  expect_identical(dim(x), c(36L, 2L))
  expect_identical(colnames(x), c("pSAP65", "pSAP75"))
  expect_equal(
    colSums(m$raw_abundance, na.rm = TRUE),
    c(pSAP65 = 1, pSAP75 = 1),
    tolerance = 1e-12
  )
  expect_identical(sum(!is.na(m$raw_abundance)), 48L)
  expect_identical(unname(m$source_table[2, 9:10]), c("pSAP 65", "pSAP 75"))
  expect_identical(
    as.character(
      SummarizedExperiment::colData(x)$conflicting_intensity_block_label
    ),
    c("PSAP 75 glycans", "pSAP 65 glycans")
  )
  expect_identical(
    sum(!is.na(SummarizedExperiment::rowData(x)$glycan_composition)),
    36L
  )
})

test_that("schistosome sheets retain annotated source peaks without invented alignment", {
  expected <- c(
    Sh_GSL = 566L,
    Sm_GSL = 183L,
    Sh_N = 489L,
    Sm_N = 247L,
    Sh_O = 122L
  )
  observations <- c(11L, 3L, 10L, 4L, 4L)
  total <- 0L
  for (i in seq_along(expected)) {
    x <- load_test_dataset(paste0("glyhub_GPST000602_", names(expected)[i]))
    m <- S4Vectors::metadata(x)
    a <- SummarizedExperiment::assay(x)
    expect_identical(dim(x), c(unname(expected[i]), observations[i]))
    expect_true(all(rowSums(m$source_coverage) == 1L))
    expect_identical(m$processing_masks$not_measured, !m$source_coverage)
    expect_true(all(is.na(a[!m$source_coverage])))
    expect_identical(sum(m$source_coverage), unname(expected[i]))
    expect_identical(
      sum(!is.na(SummarizedExperiment::rowData(x)$glycan_composition)),
      unname(expected[i])
    )
    expect_true(all(
      m$processing_ledger$reason[!as.vector(m$source_coverage)] ==
        "not_measured_in_source_panel"
    ))
    total <- total + sum(m$source_coverage)
  }
  expect_identical(total, 1607L)
})


test_that("BIFF worksheet measurements cannot regress to embedded chart caches", {
  x <- load_test_dataset("glyhub_GPST000578_N_source_repeatability_intensity")
  m <- S4Vectors::metadata(x)
  panel <- "glyhub_GPST000578_N_Ovalbumin_Repeatability"
  original <- m$panels[[panel]]
  map <- m$panel_maps[[panel]]
  expect_identical(original$source$md5, "2c37c080e75ca95e5a1e90ff3d92300f")
  expected <- c(
    3003315.25,
    973123.75,
    830038.625,
    303121.59375,
    313947.625,
    143620.734375,
    142857.09375,
    70499.765625,
    73248.6953125,
    34506.57421875
  )
  expect_equal(
    unname(original$raw_abundance[1:10, 1]),
    expected,
    tolerance = 1e-12
  )
  expect_equal(
    unname(SummarizedExperiment::assay(x)[map$rows[1:10], map$columns[1]]),
    expected,
    tolerance = 1e-12
  )
  expect_equal(
    as.numeric(original$source_table[3:12, 3]),
    expected,
    tolerance = 1e-12
  )
  expect_true(!is.null(original$reviewed_mapping$validated_source_table_file))
  expect_identical(
    original$reviewed_mapping$validated_source_table_sha256,
    "13dff7c82886b317d3704cc732771f80f7cfb807d74372aa8300dd73eb5a6a8c"
  )
})

test_that("HEK293 source workbook preserves all observations and unresolved annotations", {
  objects <- list(
    load_test_dataset("glyhub_GPST000125_N_HEK293"),
    load_test_dataset("glyhub_GPST000125_O_HEK293"),
    load_test_dataset("glyhub_GPST000125_GSL_HEK293")
  )
  nr <- c(41L, 14L, 12L)
  nz <- c(242L, 30L, 32L)
  nc <- c(40L, 14L, 12L)
  ns <- c(13L, 8L, 4L)
  for (i in seq_along(objects)) {
    x <- objects[[i]]
    m <- S4Vectors::metadata(x)
    expect_identical(dim(x), c(nr[i], 16L))
    expect_identical(sum(m$raw_abundance == 0, na.rm = TRUE), nz[i])
    expect_identical(sum(is.na(SummarizedExperiment::assay(x))), nz[i])
    expect_equal(
      unname(colSums(m$raw_abundance)),
      rep(100, 16),
      tolerance = 1e-10
    )
    expect_identical(
      sum(!is.na(SummarizedExperiment::rowData(x)$glycan_composition)),
      nc[i]
    )
    expect_identical(
      sum(!is.na(SummarizedExperiment::rowData(x)$glycan_structure)),
      ns[i]
    )
  }
  expect_true(is.na(SummarizedExperiment::rowData(objects[[
    1
  ]])$glycan_composition[17]))
})
