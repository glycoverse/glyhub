# Run from the repository root with the current glyexp dependency.
library(testthat)
source("data-raw/_shared/scripts/noncptac/literature-scale.R")

find_constructors <- function(x) {
  if (missing(x)) {
    return(list())
  }
  found <- list()
  if (is.call(x) && identical(x[[1]], quote(glyexp::GlycoproteomicSE))) {
    found <- list(x)
  }
  if (is.call(x) || is.expression(x) || is.pairlist(x)) {
    for (part in as.list(x)) {
      found <- c(found, find_constructors(part))
    }
  }
  found
}

test_that("all direct literature constructors declare the reviewed scale", {
  files <- c(
    "MSV000097695/convert-site.R" = "raw",
    "PXD013627/convert.R" = "log2",
    "PXD047982/convert.R" = "raw",
    "PXD031071/build.R" = "logx",
    "PXD019914/build.R" = "raw",
    "PXD023980/convert.R" = "raw",
    "IPX0011099000/build-mouse-atlas.R" = "log2",
    "PXD036791/convert.R" = "raw",
    "PXD013893/build.R" = "raw"
  )
  for (path in names(files)) {
    calls <- find_constructors(parse(file.path("data-raw", path)))
    expect_length(calls, 1L)
    expect_identical(calls[[1]]$metadata$scale, files[[path]], info = path)
  }
})

test_that("shared protein converter sets scale before constructing the object", {
  source(
    "data-raw/_shared/scripts/noncptac/convert-protein-source.R",
    local = TRUE
  )
  local_mocked_bindings(
    read_excel = function(...) {
      data.frame(id = c("P1", "P2"), sample1 = c(0, 2), sample2 = c(NA, 4))
    },
    .package = "readxl"
  )
  datasets <- c(
    glyhub_PXD016713_O_ChromatinProteins = "raw",
    glyhub_MSV000088624_N_HeartSurfaceome = "log2",
    glyhub_PMC9287322_N_CellLineSurfaceome = "log2",
    glyhub_PMC9287322_N_DrugResistance = "log2",
    glyhub_PMC9287322_N_SmallMolecule = "log2",
    glyhub_PMC9287322_N_PrimaryMyelomaInputs = "logx",
    glyhub_PMC9287322_N_AMO1Inputs = "logx"
  )
  for (dataset in names(datasets)) {
    spec <- list(
      dataset = dataset,
      feature_count = 2L,
      header_row = 1L,
      measurement_columns = c("sample1", "sample2"),
      missing = 1L,
      protein_column = "id",
      accession = "fixture",
      glycan_type = "N",
      species = "fixture",
      sample_mapping = data.frame(group = c("A", "B")),
      assay_scale = "This text must not be parsed to guess scale"
    )
    x <- literature_protein_source("fixture.xlsx", spec)
    expect_identical(glyexp::metadata(x)$scale, datasets[[dataset]])
    expect_true(methods::validObject(x))
    expect_identical(
      as.numeric(SummarizedExperiment::assay(x)),
      c(0, 2, NA_real_, 4)
    )
  }
  spec$dataset <- "unreviewed_dataset"
  expect_error(
    literature_protein_source("fixture.xlsx", spec),
    "No reviewed literature"
  )
})

test_that("feature converters and embedded experiment IDs have explicit linear scale", {
  source(
    "data-raw/_shared/scripts/noncptac/convert-feature-source.R",
    local = TRUE
  )
  local_mocked_bindings(
    read_excel = function(...) {
      data.frame(id = c("P1", "P2"), sample1 = c(0, 2), sample2 = c(NA, 4))
    },
    .package = "readxl"
  )
  datasets <- c(
    "glyhub_PXD017033_N_SMMC7721",
    "glyhub_PXD017033_N_HepG2",
    "glyhub_PMC10983713_N_SerumDiseaseGroups",
    "glyhub_PMC9185890_N_AMLSurfaceome",
    "glyhub_THNO47066_N_UrineDeglycopeptides",
    "glyhub_PMC12945689_N_LiverMicrosomeRhythm",
    "glyhub_PMC9306173_O_C1GALT1Silencing"
  )
  for (dataset in datasets) {
    spec <- list(
      dataset = dataset,
      features = 2L,
      header_excel_row = 1L,
      measurement_columns_1based = 2:3,
      measurement_columns = c("sample1", "sample2"),
      missing = 1L,
      zeros = 1L,
      protein_column = "id",
      accession = "fixture",
      glycan_type = "N",
      mapping = data.frame(group = c("A", "B")),
      scale = "This text must not be parsed to guess scale"
    )
    x <- literature_feature_source("fixture.xlsx", spec)
    expect_identical(glyexp::metadata(x)$scale, "raw")
    expect_true(methods::validObject(x))
    expect_identical(
      as.numeric(SummarizedExperiment::assay(x)),
      c(0, 2, NA_real_, 4)
    )
  }
})

test_that("exact-key merges reject absent and mismatched source scales", {
  source("data-raw/_shared/scripts/noncptac/merge-experiments.R", local = TRUE)
  a <- matrix(c(0, 2), 1, dimnames = list("feature", c("sample1", "sample2")))
  rd <- S4Vectors::DataFrame(
    protein = "P1",
    protein_site = 1L,
    glycan_composition = glyrepr::glycan_composition(NA),
    source_row = 2L,
    row.names = "feature"
  )
  x <- glyexp::GlycoproteomicSE(
    a,
    rowData = rd,
    metadata = list(glycan_type = "N", scale = "raw")
  )
  y <- x
  glyexp::metadata(y)$scale <- "log2"
  identities <- list(
    A = data.frame(key = "feature"),
    B = data.frame(key = "feature")
  )
  expect_error(merge_literature_experiments(
    list(A = x, B = y),
    identities,
    "fixture"
  ))
  glyexp::metadata(y)$scale <- NULL
  expect_error(merge_literature_experiments(
    list(A = x, B = y),
    identities,
    "fixture"
  ))
  citations <- jsonlite::fromJSON(
    "data-raw/_shared/metadata/noncptac/literature-citations.json"
  )
  glyexp::metadata(x)$doi <- names(citations)[1]
  joined <- merge_literature_experiments(
    list(A = x, B = x),
    identities,
    "fixture"
  )
  expect_identical(glyexp::metadata(joined)$scale, "raw")
  expect_identical(
    as.numeric(SummarizedExperiment::assay(joined)),
    rep(c(0, 2), 2)
  )
  for (source in glyexp::metadata(joined)$source_experiments) {
    expect_identical(glyexp::metadata(source)$scale, "raw")
    expect_true(methods::validObject(source))
  }
})
