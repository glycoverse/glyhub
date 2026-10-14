test_that("unreviewed candidate is not publicly available", {
  name <- "glyhub_GPST000738_N_B4GalT1_75_A2"
  expect_error(getExportedValue("glyhub", name), "not an exported object")
  datasets <- utils::data(package = "glyhub")$results
  expect_false(name %in% datasets[, "Item"])
})
