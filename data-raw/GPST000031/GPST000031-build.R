# Build the complete Table S2 intensity matrix, then attach distinct source scales.
source("data-raw/build-matrix-specs.R", local = TRUE)
path <- "data-raw/GPST000031/matrix-specs.json"
build_matrix_specs(path)
s <- jsonlite::fromJSON(path, simplifyVector = FALSE)[[1]]
e <- new.env()
file <- file.path("data", paste0(s$name, ".rda"))
load(file, e)
x <- e[[s$name]]
rd <- SummarizedExperiment::rowData(x)
rd$source_excel_row <- vapply(s$row_annotations, `[[`, 0L, "source_excel_row")
rd$source_number <- vapply(s$row_annotations, `[[`, 0L, "source_number")
rd$source_suffix <- vapply(s$row_annotations, `[[`, "", "source_suffix")
rd$source_composition <- vapply(s$row_annotations, `[[`, "", "source_composition")
rd$composition_status <- vapply(s$row_annotations, `[[`, "", "composition_status")
SummarizedExperiment::rowData(x) <- rd
m <- S4Vectors::metadata(x)
relative <- do.call(rbind, lapply(s$source_relative_abundance, unlist))
storage.mode(relative) <- "double"
dimnames(relative) <- dimnames(x)
denominator <- unlist(s$high_mannose_denominator)
names(denominator) <- colnames(x)
stopifnot(isTRUE(all.equal(
  relative,
  sweep(m$raw_abundance, 2L, denominator, "/") * 100,
  tolerance = 1e-12
)))
m$doi <- s$doi
m$source$sha256 <- s$source_sha256
m$source$supplement <- "Supplemental Table S2"
m$source_relative_abundance <- relative
m$source_relative_abundance_provenance <- list(
  unit = "percent relative to the source high-mannose intensity sum",
  source_columns = unlist(s$source_relative_column_indices),
  denominator_source_row = 292L,
  denominator_source_label = "SUM of Hign Man",
  denominator = denominator,
  formula = "100 * EIC peak intensity / sample-specific high-mannose intensity sum",
  source_values_preserved = TRUE,
  is_abundance_assay = FALSE,
  note = "Original source percentages, including zeros, are retained without total-glycome normalization. These provenance values are not a second assay."
)
m$source_identity <- jsonlite::fromJSON(
  "data-raw/GPST000031/source-identity.json",
  simplifyVector = FALSE
)
m$coverage_limitations <- c(
  "This workbook contains GPST000031 kidney data, not GPST000027 brain data.",
  "WT and KO source samples/runs are retained; independent biological replication and pairing are not established.",
  "Diagnostic MS/MS scan identifiers do not establish complete glycan topology."
)
S4Vectors::metadata(x) <- m
stopifnot(
  isTRUE(methods::validObject(x)),
  identical(dim(x), c(287L, 4L)),
  sum(is.na(rd$glycan_composition)) == 32L,
  !"glycan_structure" %in% names(rd),
  sum(m$processing_masks$zero_to_na) == 309L
)
assign(s$name, x)
save(list = s$name, file = file, compress = "xz", version = 3)
inventory <- utils::read.csv("data-raw/object-inventory.csv")
inventory$compressed_bytes[inventory$dataset == s$name] <- file.info(file)$size
utils::write.csv(inventory, "data-raw/object-inventory.csv", row.names = FALSE)
