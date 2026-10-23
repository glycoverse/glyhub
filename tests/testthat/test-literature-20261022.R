literature_names <- c(
  "glyhub_PXD013893_N_EVEnrichmentMethods",
  "glyhub_MSV000097695_N_AdultWorm",
  "glyhub_PXD013627_N_HumanCellLines",
  "glyhub_PXD013627_N_MouseBCells",
  "glyhub_PXD047982_O_24d_VVA_Run2",
  "glyhub_PXD047982_O_24d_VVA_Run3",
  "glyhub_PXD047982_O_24d_VVA_Run4",
  "glyhub_PXD047982_O_24d_PNA_Run1",
  "glyhub_PXD047982_O_24d_PNA_Run2",
  "glyhub_PXD047982_O_24d_PNA_Run3",
  "glyhub_PXD047982_O_24d_PNA_Run4",
  "glyhub_PXD047982_O_24d_VVA_Run1",
  "glyhub_PXD047982_O_12w_VVA_Run2",
  "glyhub_PXD047982_O_12w_VVA_Run3",
  "glyhub_PXD047982_O_12w_VVA_Run4",
  "glyhub_PXD047982_O_12w_PNA_Run1",
  "glyhub_PXD047982_O_12w_VVA_Run1",
  "glyhub_PXD047982_O_12w_PNA_Run2",
  "glyhub_PXD047982_O_12w_PNA_Run3",
  "glyhub_PXD047982_O_12w_PNA_Run4",
  "glyhub_PXD031071_N_Surfaceome",
  "glyhub_PXD016713_O_ChromatinProteins",
  "glyhub_MSV000088624_N_HeartSurfaceome",
  "glyhub_PMC9287322_N_CellLineSurfaceome",
  "glyhub_PMC9287322_N_DrugResistance",
  "glyhub_PMC9287322_N_SmallMolecule",
  "glyhub_PMC9287322_N_PrimaryMyelomaInputs",
  "glyhub_PMC9287322_N_AMO1Inputs",
  "glyhub_PXD019914_N_Intact_RelativeRatios",
  "glyhub_PXD019914_N_SPEG_RelativeRatios",
  "glyhub_PMC12945689_N_LiverMicrosomeRhythm",
  "glyhub_PMC9306173_O_C1GALT1Silencing",
  "glyhub_PMC9185890_N_AMLSurfaceome",
  "glyhub_PXD023980_N_FissionYeast_DDA1h",
  "glyhub_PXD023980_N_FissionYeast_DDA6h",
  "glyhub_PXD023980_N_FissionYeast_DIA_SSL",
  "glyhub_PXD023980_N_BuddingYeast_DIA",
  "glyhub_PXD023980_N_Serum_DDA",
  "glyhub_PXD023980_N_Serum_DIA_SSL",
  "glyhub_PXD023980_N_Mixture_DDA",
  "glyhub_PXD023980_N_Mixture_DIA_SSL",
  "glyhub_IPX0011099000_N_MouseTissueAtlas",
  "glyhub_THNO47066_N_UrineDeglycopeptides",
  "glyhub_PMC10983713_N_SerumDiseaseGroups",
  "glyhub_PXD036791_O_Secretome_GALNT1_GALNT2",
  "glyhub_PXD036791_O_GALNT_TCL",
  "glyhub_PXD017033_N_HGFTimecourse"
)

test_that("existing release entries and their scientific metadata are unchanged", {
  for (name in c("manifest.tsv", "catalog-metadata.tsv")) {
    before <- read.delim(test_path("fixtures", paste0("baseline-", name)),
      colClasses = "character", check.names = FALSE)
    after <- read.delim(system.file("extdata", name, package = "glyhub"),
      colClasses = "character", check.names = FALSE)
    key <- if (name == "manifest.tsv") paste(before$dataset, before$kind) else before$dataset
    after_key <- if (name == "manifest.tsv") paste(after$dataset, after$kind) else after$dataset
    selected <- after[match(key, after_key), , drop = FALSE]
    rownames(selected) <- NULL
    rownames(before) <- NULL
    expect_identical(selected, before)
  }
})

test_that("literature additions are honest locally staged catalog entries", {
  m <- glyhub_catalog()
  i <- match(literature_names, m$dataset)
  expect_false(anyNA(i))
  e <- m[i, ]
  expect_true(all(e$storage == "staged"))
  expect_true(all(is.na(e$url) | e$url == ""))
  expect_true(all(e$exp_type == "glycoproteomics"))
  expect_true(all(!e$has_glycan_structures))
  expect_true(all(!is.na(e$quant_method)))
  expect_equal(e$features[match(c("glyhub_MSV000097695_N_AdultWorm", "glyhub_PXD013627_N_HumanCellLines", "glyhub_PXD013627_N_MouseBCells"), e$dataset)], c(3274L, 892L, 147L))
  expect_equal(e$measurements[match(c("glyhub_MSV000097695_N_AdultWorm", "glyhub_PXD013627_N_HumanCellLines", "glyhub_PXD013627_N_MouseBCells"), e$dataset)], c(6L, 33L, 28L))
  expect_equal(e$features[match("glyhub_PXD036791_O_Secretome_GALNT1_GALNT2", e$dataset)], 987L)
  expect_equal(e$measurements[match("glyhub_PXD036791_O_Secretome_GALNT1_GALNT2", e$dataset)], 6L)
  for (name in literature_names) {
    expect_true(is.function(getExportedValue("glyhub", name)))
  }
})

test_that("verified literature assets retain complete source matrices", {
  cache <- Sys.getenv("GLYHUB_LITERATURE_CACHE")
  if (!nzchar(cache) || !dir.exists(cache)) {
    skip("Scientific source validation requires the explicit maintainer literature cache")
  }
  for (name in literature_names) {
    x <- glyhub_load(name, cache_dir = cache, offline = TRUE)
    expect_true(methods::validObject(x), info = name)
    a <- SummarizedExperiment::assay(x)
    md <- S4Vectors::metadata(x)
    rd <- SummarizedExperiment::rowData(x)
    if (grepl("PXD019914.*RelativeRatios", name)) {
      expect_identical(a, 2^md$raw_abundance, info = name)
      expect_match(md$assay_scale, "relative ratio")
      expect_equal(sum(SummarizedExperiment::colData(x)$sample_role == "quality_control"), 10L)
      expect_true(all(a[!is.na(md$raw_abundance) & md$raw_abundance == 0] == 1))
    } else {
      expect_identical(a, md$raw_abundance, info = name)
    }
    structural <- md$processing_masks$structural_missing
    if (is.null(structural)) structural <- matrix(FALSE, nrow(a), ncol(a), dimnames = dimnames(a))
    expect_identical(is.na(a), md$processing_masks$source_missing | structural, info = name)
    expect_identical(!is.na(md$raw_abundance) & md$raw_abundance == 0, md$processing_masks$source_zero, info = name)
    expect_false(anyDuplicated(rownames(x)) > 0L, info = name)
    expect_false(anyDuplicated(colnames(x)) > 0L, info = name)
    expect_false("glycan_structure" %in% names(rd), info = name)
    expect_true(all(is.finite(a) | is.na(a)), info = name)
    if (grepl("PXD017033", name)) {
      expect_equal(sum(rd$source_structure_composition_conflict), 7L)
      expect_equal(sum(is.na(rd$glycan_composition)), 28L)
      expect_equal(sum(structural), 8880L)
      expect_true(all(is.na(rd$glycan_composition[rd$source_structure_composition_conflict])))
    }

    if (grepl("PXD013893", name)) {
      expect_equal(sum(a == 0), 2485L)
      expect_equal(sum(rd$source_reverse), 15L)
      expect_equal(sum(rd$source_potential_contaminant), 19L)
      controls <- rd$source_reverse | rd$source_potential_contaminant
      expect_true(all(is.na(rd$protein[controls])))
      expect_true(all(is.na(rd$protein_site[controls])))
      expect_true(all(SummarizedExperiment::colData(x)$replicate_type == "technical"))
      expect_identical(as.numeric(a), as.numeric(as.matrix(md$source_table[md$source_measurement_columns])))
    }
    if (grepl("PXD013627", name)) {
      expect_true(all(is.na(rd$protein_site)))
      expect_true(all(is.na(rd$glycan_composition)))
      expect_match(md$assay_scale, "log2")
    }
    if (grepl("MSV000097695", name)) {
      expect_equal(sum(a == 0), 1129L)
      expect_equal(sum(rd$source_protein_site_group), 585L)
      expect_true(all(is.na(rd$protein_site[rd$source_protein_site_group])))
      expect_equal(sum(is.na(rd$glycan_composition)), 16L)
    }
    if (grepl("Secretome", name)) {
      expect_equal(sum(is.na(a)), 2L)
      expect_equal(sum(SummarizedExperiment::colData(x)$source_group == "WT"), 2L)
      expect_identical(SummarizedExperiment::colData(x)$replicate_type,
        c(rep("technical", 2L), rep("biological", 4L)))
    }
    if (grepl("PXD047982", name)) {
      expect_equal(ncol(a), 1L)
      expect_identical(as.numeric(a), md$source_table$MonoArea)
      expect_identical(rd$IsotopeArea, md$source_table$IsotopeArea)
      expect_identical(rd$GlySpec, md$source_table$GlySpec)
      expect_identical(rd$Scan, md$source_table$Scan)
      expect_identical(md$source_repository, "iProX")
      expect_match(SummarizedExperiment::colData(x)$replicate_type, "biological")
      expect_match(md$feature_grain, "PSM")
    }
  }
})

test_that("source representations use the existing verified file path", {
  m <- glyhub_catalog("raw")
  e <- m[m$storage == "staged", ]
  expect_equal(nrow(e), 32L)
  expect_true(all(is.na(e$url) | e$url == ""))
  expect_true(all(is.na(e$quant_method)))
  cache <- Sys.getenv("GLYHUB_LITERATURE_CACHE")
  if (!nzchar(cache) || !dir.exists(cache)) {
    skip("Source asset validation requires the explicit maintainer literature cache")
  }
  for (i in seq_len(nrow(e))) {
    path <- glyhub_load(e$dataset[i], kind = "raw", cache_dir = cache, offline = TRUE)
    expect_identical(digest::digest(file = path, algo = "sha256"), e$sha256[i])
    expect_equal(file.info(path)$size, e$bytes[i])
    expect_error(glyhub_load(e$dataset[i], cache_dir = cache, offline = TRUE),
      "Unknown dataset or unavailable resource kind")
  }
})

test_that("merged experiments roundtrip without inventing observations", {
  cache <- Sys.getenv("GLYHUB_LITERATURE_CACHE")
  if (!nzchar(cache) || !dir.exists(cache)) skip("Requires verified literature cache")
  for (id in c("glyhub_PXD036791_O_GALNT_TCL", "glyhub_PXD017033_N_HGFTimecourse")) {
    x <- glyhub_load(id, cache_dir = cache, offline = TRUE)
    md <- S4Vectors::metadata(x)
    a <- SummarizedExperiment::assay(x)
    masks <- md$processing_masks
    expect_identical(!masks$source_coverage, masks$structural_missing)
    expect_true(all(is.na(a[masks$structural_missing])))
    expect_false(any(masks$source_missing & masks$structural_missing))
    for (experiment in names(md$source_experiments)) {
      original <- md$source_experiments[[experiment]]
      rows <- md$source_experiment_row_maps[[experiment]]$merged_row_index
      cols <- md$source_experiment_column_maps[[experiment]]$merged_column_index
      expect_identical(unname(a[rows, cols, drop = FALSE]),
        unname(SummarizedExperiment::assay(original)))
      expect_true(all(masks$source_coverage[rows, cols]))
    }
    if (grepl("GALNT", id)) {
      expect_identical(dim(x), c(6789L, 54L))
      expect_equal(sum(masks$structural_missing), 244734L)
      expect_equal(sum(SummarizedExperiment::rowData(x)$source_gene_conflict), 23L)
      expect_true("Theo MHplus in Da" %in% md$alignment_key_fields)
    } else {
      expect_identical(dim(x), c(2318L, 12L))
      expect_equal(sum(masks$structural_missing), 8880L)
    }
  }
})

test_that("superseded unpublished panel IDs are not silent aliases", {
  retired <- c(paste0("glyhub_PXD036791_O_GALNT", c(1, 2, 3, 6, 7, 10, 11, 14, 18)),
    "glyhub_PXD017033_N_SMMC7721", "glyhub_PXD017033_N_HepG2")
  expect_false(any(retired %in% glyhub_catalog("all")$dataset))
  for (id in retired) {
    expect_error(glyhub_load(id, offline = TRUE), "Unknown dataset or unavailable resource kind")
    expect_false(id %in% getNamespaceExports("glyhub"))
  }
})

test_that("public human source representations are explicit derivatives and held originals are absent", {
  p <- system.file("extdata", "literature-source-metadata.json", package="glyhub")
  sources <- jsonlite::fromJSON(p, simplifyVector=FALSE)
  expect_length(sources, 32L)
  derived <- Filter(function(z) isTRUE(z$privacy_derivative), sources)
  expect_length(derived, 8L)
  expect_true(all(vapply(derived, function(z) identical(z$format, "rds"), logical(1))))
  expect_false(any(grepl("PXD057512", vapply(sources, `[[`, character(1), "dataset"))))
})
