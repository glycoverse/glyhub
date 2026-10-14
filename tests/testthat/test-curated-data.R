original_panel <- function(name) {
  if (!grepl("GPST000643", name)) return(getExportedValue("glyhub", name))
  type <- if (grepl("_N_", name)) "N" else "O"
  x <- getExportedValue("glyhub", paste0("glyhub_GPST000643_", type))
  m <- S4Vectors::metadata(x); map <- m$panel_maps[[name]]
  a <- SummarizedExperiment::assay(x)[map$rows, map$columns, drop = FALSE]
  dimnames(a) <- map$original_dimnames
  glyexp::GlycomicSE(a, rowData=m$panel_row_data[[name]], colData=m$panel_col_data[[name]], metadata=m$panels[[name]])
}
test_that("curated data preserve measurements and explain every changed cell", {
  names <- c(
    "glyhub_GPST000738_N_B4GalT1",
    "glyhub_GPST000738_N_ST6GAL1",
    "glyhub_GPST000643_O_S5",
    "glyhub_GPST000643_O_S7",
    "glyhub_GPST000643_O_S9B",
    "glyhub_GPST000643_O_S10B",
    "glyhub_GPST000643_N_S10B",
    "glyhub_GPST000643_O_S10C",
    "glyhub_GPST000643_N_S10C",
    "glyhub_GPST000643_O_S11B",
    "glyhub_GPST000643_O_S12"
  )
  sizes <- list(
    c(9L, 18L),
    c(10L, 28L),
    c(108L, 22L),
    c(77L, 6L),
    c(56L, 7L),
    c(9L, 8L),
    c(3L, 8L),
    c(3L, 15L),
    c(2L, 15L),
    c(60L, 9L),
    c(140L, 4L)
  )
  for (i in seq_along(names)) {
    x <- original_panel(names[i])
    m <- S4Vectors::metadata(x)
    a <- SummarizedExperiment::assay(x)
    expect_identical(methods::validObject(x), TRUE)
    expect_identical(dim(x), sizes[[i]])
    expect_identical(rownames(x), rownames(SummarizedExperiment::rowData(x)))
    expect_identical(colnames(x), rownames(SummarizedExperiment::colData(x)))
    expect_identical(any(a == 0, na.rm = TRUE), FALSE)
    expect_identical(
      m$processing_masks$zero_to_na,
      !is.na(m$raw_abundance) & m$raw_abundance == 0
    )
    mask <- m$processing_masks$zero_to_na | is.na(m$raw_abundance)
    if (!is.null(m$processing_masks$conflict)) {
      mask <- mask | m$processing_masks$conflict
    }
    expected <- m$raw_abundance
    expected[mask] <- NA_real_
    expect_identical(a, expected)
    expect_identical(nrow(m$processing_ledger), length(a))
    expect_identical(as.vector(a), m$processing_ledger$curated_value)
    expect_identical(m$zero_to_na, TRUE)
    expect_identical(
      glyrepr::is_glycan_composition(
        SummarizedExperiment::rowData(x)$glycan_composition
      ),
      TRUE
    )
    expect_identical(
      glyrepr::is_glycan_structure(
        SummarizedExperiment::rowData(x)$glycan_structure
      ),
      TRUE
    )
    # Structure completeness follows available evidence, not a minimum quota.
  }
})

test_that("GPST000738 retains source scale, time zero and unresolved provenance", {
  x <- glyhub_GPST000738_N_B4GalT1
  m <- S4Vectors::metadata(x)
  expect_equal(m$raw_abundance["A2", 1], 70.66)
  expect_equal(SummarizedExperiment::assay(x)["A2", 1], 70.66)
  expect_identical(all(m$processing_masks$conflict[1:2, 5:10]), TRUE)
  expect_identical(all(is.na(SummarizedExperiment::assay(x)[1:2, 5:10])), TRUE)
  expect_equal(
    sum(SummarizedExperiment::colData(x)$time_hours == 0, na.rm = TRUE),
    2
  )
  expect_equal(
    sum(SummarizedExperiment::colData(x)$condition == "substrate_control"),
    4
  )
  expect_identical(m$unit, "percent within glycan family")
  y <- glyhub_GPST000738_N_ST6GAL1
  n <- S4Vectors::metadata(y)
  expect_identical(n$unit, "fraction within glycan family")
  expect_equal(n$processing_counts[["source_nd"]], 13)
  expect_equal(nrow(n$unmatched_processed_observations), 6)
  expect_equal(n$raw_abundance["A3G3", 1], 0.618442)
})

test_that("GPST000643 keeps source annotation zeros and distinct N/O spaces", {
  x <- original_panel("glyhub_GPST000643_O_S5")
  m <- S4Vectors::metadata(x)
  expect_equal(m$raw_abundance[1, 1], 0)
  expect_identical(is.na(SummarizedExperiment::assay(x)[1, 1]), TRUE)
  expect_identical(m$processing_masks$source_rt_not_detected[1, 1], TRUE)
  expect_equal(m$raw_abundance[2, 1], 0.4512076161890915)
  expect_identical(
    "0" %in% unlist(SummarizedExperiment::rowData(x)$source_annotations[[1]]),
    TRUE
  )
  expect_identical(
    S4Vectors::metadata(original_panel("glyhub_GPST000643_N_S10B"))$glycan_type,
    "N"
  )
  expect_identical(
    S4Vectors::metadata(original_panel("glyhub_GPST000643_O_S10B"))$glycan_type,
    "O"
  )
  expect_identical(
    m$license$name,
    "Creative Commons Attribution-NoDerivatives 4.0 International"
  )
})

test_that("S10C partitions conserve its complete source measurements", {
  o <- original_panel("glyhub_GPST000643_O_S10C")
  n <- original_panel("glyhub_GPST000643_N_S10C")
  expect_identical(
    SummarizedExperiment::colData(o),
    SummarizedExperiment::colData(n)
  )
  expect_identical(SummarizedExperiment::rowData(o)$source_row, 8:10)
  expect_identical(SummarizedExperiment::rowData(n)$source_row, 11:12)
  om <- S4Vectors::metadata(o)
  nm <- S4Vectors::metadata(n)
  expect_identical(om$glycan_type, "O")
  expect_identical(nm$glycan_type, "N")
  expect_identical(om$source_table, nm$source_table)
  raw <- om$source_table[8:12, seq(8, 50, 3)]
  expected <- matrix(as.numeric(raw), 5, 15)
  expect_equal(unname(rbind(om$raw_abundance, nm$raw_abundance)), expected)
  expected[expected == 0] <- NA_real_
  expect_equal(
    unname(rbind(
      SummarizedExperiment::assay(o),
      SummarizedExperiment::assay(n)
    )),
    expected
  )
  expect_identical(sum(om$processing_counts + nm$processing_counts), 40L)
})
