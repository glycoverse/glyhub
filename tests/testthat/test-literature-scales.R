reviewed_literature_scales <- function() {
  utils::read.delim(
    test_path("fixtures", "literature-scales.tsv"),
    stringsAsFactors = FALSE
  )
}

make_legacy_literature_object <- function(scale = "raw") {
  x <- make_test_object()
  rows <- SummarizedExperiment::rowData(x)
  rows$protein <- c("P1", "P2")
  rows$protein_site <- c(1L, 2L)
  a <- SummarizedExperiment::assay(x)
  a[1, 1] <- 0
  a[2, 1] <- NA_real_
  if (scale != "raw" && utils::packageVersion("glyexp") >= "0.19.0") {
    a[1, 2] <- -2
  }
  x <- glyexp::GlycoproteomicSE(
    a,
    rowData = rows,
    metadata = list(
      glycan_type = "N",
      scale = scale,
      assay_scale = "original source description",
      raw_abundance = a,
      processing_masks = list(
        source_missing = is.na(a),
        source_zero = !is.na(a) & a == 0
      )
    )
  )
  glyexp::metadata(x)$scale <- NULL
  x
}

strip_literature_scales <- function(x) {
  md <- glyexp::metadata(x)
  md$scale <- NULL
  if (!is.null(md$source_experiments)) {
    md$source_experiments <- lapply(
      md$source_experiments,
      strip_literature_scales
    )
  }
  glyexp::metadata(x) <- md
  x
}

test_that("all 47 released literature scales match independent source decisions and hashes", {
  expected <- reviewed_literature_scales()
  approved <- .glyhub_literature_scales()
  root <- approved[approved$parent_dataset == "", c("dataset", "scale")]
  rownames(root) <- NULL
  expect_identical(root, expected)
  expect_identical(
    as.integer(table(expected$scale)[c("raw", "log2", "logx")]),
    c(37L, 7L, 3L)
  )
  catalog <- glyhub_catalog()
  staged <- catalog[catalog$version == "data-v0.2.0", ]
  expect_setequal(staged$dataset, expected$dataset)
  root <- approved[approved$parent_dataset == "", ]
  expect_identical(
    root$sha256,
    staged$sha256[match(root$dataset, staged$dataset)]
  )
  expect_identical(sum(approved$parent_dataset != ""), 11L)
  children <- approved[approved$parent_dataset != "", ]
  expect_true(all(children$scale == "raw"))
  expect_identical(
    children$sha256,
    staged$sha256[match(children$parent_dataset, staged$dataset)]
  )
  expect_false(anyDuplicated(approved$dataset) > 0L)

  for (i in seq_len(nrow(expected))) {
    entry <- staged[staged$dataset == expected$dataset[i], ]
    expect_identical(
      .glyhub_legacy_scale(entry),
      expected$scale[i],
      info = entry$dataset
    )
    entry$sha256 <- paste(rep("0", 64), collapse = "")
    expect_error(.glyhub_legacy_scale(entry), "No verified abundance scale")
  }
})

test_that("literature metadata migration preserves all values and embedded experiments", {
  expected <- reviewed_literature_scales()
  approved <- .glyhub_literature_scales()
  catalog <- glyhub_catalog()
  for (i in seq_len(nrow(expected))) {
    entry <- catalog[catalog$dataset == expected$dataset[i], ]
    original <- make_legacy_literature_object(expected$scale[i])
    children <- approved[approved$parent_dataset == entry$dataset, ]
    if (nrow(children)) {
      glyexp::metadata(original)$source_experiments <- stats::setNames(
        lapply(seq_len(nrow(children)), function(i) {
          make_legacy_literature_object()
        }),
        children$source_experiment
      )
    }
    actual <- .glyhub_upgrade_metadata(original, entry)
    expect_identical(
      glyexp::metadata(actual)$scale,
      expected$scale[i],
      info = entry$dataset
    )
    expect_true(methods::validObject(actual))
    expect_identical(strip_literature_scales(actual), original)
    for (source in glyexp::metadata(actual)$source_experiments) {
      expect_identical(glyexp::metadata(source)$scale, "raw")
      expect_true(methods::validObject(source))
    }
    expect_identical(.glyhub_upgrade_metadata(actual, entry), actual)
  }
})

test_that("source scale migration is parent-hash and experiment-name specific", {
  catalog <- glyhub_catalog()
  entry <- catalog[catalog$dataset == "glyhub_PXD017033_N_HGFTimecourse", ]
  x <- make_legacy_literature_object()
  glyexp::metadata(x)$scale <- "raw"
  glyexp::metadata(x)$source_experiments <- list(
    SMMC7721 = make_legacy_literature_object(),
    HepG2 = make_legacy_literature_object()
  )
  bad <- entry
  bad$sha256 <- paste(rep("0", 64), collapse = "")
  expect_identical(.glyhub_upgrade_metadata(x, bad), x)
  renamed <- x
  names(glyexp::metadata(renamed)$source_experiments)[
    1
  ] <- "unexpected_experiment"
  expect_error(
    .glyhub_upgrade_metadata(renamed, entry),
    "source experiments do not match"
  )
  glyexp::metadata(glyexp::metadata(x)$source_experiments$HepG2)$scale <- "logx"
  actual <- .glyhub_upgrade_metadata(x, entry)
  expect_identical(
    glyexp::metadata(glyexp::metadata(actual)$source_experiments$HepG2)$scale,
    "logx"
  )
})

test_that("reviewed literature scales load offline without changing cache bytes", {
  for (scale in c("raw", "log2", "logx")) {
    original <- make_legacy_literature_object(scale)
    source <- tempfile(fileext = ".rds")
    cache <- tempfile()
    on.exit(unlink(c(source, cache), recursive = TRUE), add = TRUE)
    saveRDS(original, source)
    entry <- glyhub_catalog()[1, , drop = FALSE]
    entry$dataset <- paste0("fixture_literature_", scale)
    entry$format <- "rds"
    entry$storage <- "staged"
    entry$url <- ""
    entry$bytes <- file.info(source)$size
    entry$sha256 <- digest::digest(file = source, algo = "sha256")
    reviewed <- data.frame(
      dataset = entry$dataset,
      sha256 = entry$sha256,
      scale = scale,
      parent_dataset = "",
      source_experiment = ""
    )
    target <- file.path(
      cache,
      entry$version,
      paste0(entry$sha256, "-", entry$filename)
    )
    dir.create(dirname(target), recursive = TRUE)
    file.copy(source, target)
    local_mocked_bindings(
      glyhub_catalog = function(...) entry,
      .glyhub_literature_scales = function() reviewed
    )
    actual <- glyhub_load(entry$dataset, cache_dir = cache, offline = TRUE)
    expect_identical(glyexp::metadata(actual)$scale, scale)
    expect_identical(strip_literature_scales(actual), original)
    expect_identical(
      digest::digest(file = target, algo = "sha256"),
      entry$sha256
    )
    expect_identical(readRDS(target), original)
  }
})
