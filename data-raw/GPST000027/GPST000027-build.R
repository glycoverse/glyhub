# One study-level N-glycan object, with source-specific unaligned feature spaces.
source("data-raw/build-matrix-specs.R", local = TRUE)
build_matrix_specs("data-raw/GPST000027/matrix-specs.json")
source("data-raw/GPST000031/GPST000031-build.R", local = new.env())
panel_names <- c("glyhub_GPST000027_N_Brain", "glyhub_GPST000031_N_Kidney")
panels <- lapply(panel_names, function(name) {
  e <- new.env()
  load(file.path("data", paste0(name, ".rda")), e)
  e[[name]]
})
names(panels) <- panel_names
# Attach the brain percentage scale without adding a second assay.
brain <- panels[[1]]
bm <- S4Vectors::metadata(brain)
bs <- bm$reviewed_mapping
relative <- do.call(rbind, lapply(bs$source_relative_abundance, unlist))
storage.mode(relative) <- "double"
dimnames(relative) <- dimnames(brain)
denominator <- unlist(bs$high_mannose_denominator)
names(denominator) <- colnames(brain)
stopifnot(all(abs(relative - sweep(bm$raw_abundance, 2L, denominator, "/") * 100) <= 0.05000000001))
bm$doi <- bs$doi
bm$source$sha256 <- bs$source_sha256
bm$source$pdf_page <- 4L
bm$source$figure <- "S2C"
bm$source_relative_abundance <- relative
bm$source_relative_abundance_provenance <- list(
  unit = "percent relative to the source high-mannose intensity sum",
  denominator = denominator,
  denominator_source_label = "SUM of Hign Man",
  printed_decimal_places = 1L,
  source_values_preserved = TRUE,
  is_abundance_assay = FALSE,
  formula = "100 * EIC peak intensity / sample-specific high-mannose intensity sum; printed to one decimal place"
)
bm$transcription_validation <- bs$transcription_validation
bm$source_identity <- jsonlite::fromJSON("data-raw/GPST000027/provenance_license_snapshot.json", simplifyVector = FALSE)
S4Vectors::metadata(brain) <- bm
panels[[1]] <- brain

md <- lapply(panels, S4Vectors::metadata)
rds <- lapply(panels, SummarizedExperiment::rowData)
cds <- lapply(panels, SummarizedExperiment::colData)
rows <- list(seq_len(51L), 51L + seq_len(287L))
columns <- list(1:2, 3:6)
feature_ids <- c(paste0("GPST000027::", rownames(brain)),
                 paste0("GPST000031::", rownames(panels[[2]])))
sample_ids <- c("brain_WT", "brain_KO", paste0("kidney_", colnames(panels[[2]])))
dn <- list(feature_ids, sample_ids)
raw <- matrix(NA_real_, 338L, 6L, dimnames = dn)
percentage <- raw
coverage <- zero <- matrix(FALSE, 338L, 6L, dimnames = dn)
maps <- list()
for (i in seq_along(panels)) {
  raw[rows[[i]], columns[[i]]] <- md[[i]]$raw_abundance
  percentage[rows[[i]], columns[[i]]] <- md[[i]]$source_relative_abundance
  coverage[rows[[i]], columns[[i]]] <- TRUE
  zero[rows[[i]], columns[[i]]] <- md[[i]]$processing_masks$zero_to_na
  maps[[panel_names[i]]] <- list(rows = rows[[i]], columns = columns[[i]], original_dimnames = dimnames(panels[[i]]))
}
abundance <- raw
abundance[zero] <- NA_real_
rd <- S4Vectors::DataFrame(
  source_feature_id = c(rownames(brain), rownames(panels[[2]])),
  source_accession = c(rep("GPST000027", 51L), rep("GPST000031", 287L)),
  source_panel = c(rep(panel_names[1], 51L), rep(panel_names[2], 287L)),
  row.names = feature_ids
)
rd$glycan_composition <- c(rds[[1]]$glycan_composition, rds[[2]]$glycan_composition)
rd$source_annotations <- I(c(as.list(rds[[1]]$source_annotations), as.list(rds[[2]]$source_annotations)))
rd$source_composition <- vapply(rd$source_annotations, `[[`, "", "source_composition")
rd$composition_status <- vapply(rd$source_annotations, `[[`, "", "composition_status")
fields <- unique(unlist(lapply(cds, names)))
aligned_cds <- lapply(cds, function(cd) {
  for (field in setdiff(fields, names(cd))) cd[[field]] <- rep(NA_character_, nrow(cd))
  cd[, fields, drop = FALSE]
})
cd <- do.call(rbind, aligned_cds)
rownames(cd) <- sample_ids
cd$source_panel <- c(rep(panel_names[1], 2L), rep(panel_names[2], 4L))
cd$assay_unit <- rep("source EIC peak intensity (panel-specific instrument units)", 6L)
idx <- expand.grid(feature_index = seq_len(338L), observation_index = seq_len(6L))
idx$feature_id <- feature_ids[idx$feature_index]
idx$observation_id <- sample_ids[idx$observation_index]
idx$original_value <- as.vector(raw)
idx$curated_value <- as.vector(abundance)
idx$reason <- ifelse(!as.vector(coverage), "not_measured_in_source_panel",
                    ifelse(as.vector(zero), "zero_abundance", "unchanged"))
name <- "glyhub_GPST000027_031_N"
metadata <- list(
  accession = "GPST000027",
  accessions = c("GPST000027", "GPST000031"),
  dataset_name = name,
  doi = "10.1074/mcp.RA119.001534",
  glycan_type = "N",
  unit = "source EIC peak intensity (panel-specific instrument units)",
  source = lapply(md, `[[`, "source"),
  license = list(
    name = "Creative Commons Attribution 4.0 International",
    url = "https://creativecommons.org/licenses/by/4.0/",
    evidence_scope = "Publisher-deposited article version-of-record license metadata. The supplements have no separately verified file-specific declaration; per-source evidence and attribution are preserved below.",
    source_licenses = lapply(md, `[[`, "license")
  ),
  raw_abundance = raw,
  source_relative_abundance = percentage,
  source_relative_abundance_note = "Original panel-specific percentages are retained as provenance, not a second assay. Brain percentages are rounded to one decimal; kidney percentages retain Excel precision. Both use high-mannose denominators, not total-glycome sums.",
  source_coverage = coverage,
  processing_masks = list(zero_to_na = zero, conflict = zero & FALSE, source_missing = coverage & is.na(raw), not_measured = !coverage),
  processing_counts = c(zero_to_na = sum(zero), conflict = 0L, source_missing = sum(coverage & is.na(raw)), not_measured = sum(!coverage)),
  processing_ledger = idx,
  panels = md,
  panel_maps = maps,
  panel_row_data = rds,
  panel_col_data = cds,
  merge_method = "Disjoint union of all source-labelled chromatographic features and observations from the same study and N-glycan class; no cross-tissue feature identity is inferred from composition, mass or numbering.",
  measurement_limitations = c(
    "This is a source-preserving study container, not an aligned cross-tissue quantitative feature matrix.",
    "Brain TMT6 126/127 and kidney aminoxyTMT0 protocols differ; raw EIC intensities are not calibrated for direct cross-tissue or cross-protocol numerical comparison.",
    "Brain and kidney feature spaces are disjoint; all 778 unmeasured combinations are NA with explicit coverage masks, not biological absences.",
    "No biological replication, sample pairing, sex or age is inferred from the sample labels. The article reports three independent brain pairs but S2C supplies only two genotype columns without replicate identifiers.",
    "Brain raw-file/run associations are genotype-and-filename-based candidates; only kidney columns carry exact source run-ID matches."
  ),
  zero_to_na = TRUE,
  zero_handling = "Only primary quantitative assay zeros become NA; source zeros, percentages, candidate compositions and source summaries remain intact. No imputation or renormalization.",
  software = md[[2]]$software
)
x <- glyexp::GlycomicSE(abundance, rowData = rd, colData = cd, metadata = metadata)
stopifnot(isTRUE(methods::validObject(x)), sum(coverage) == 1250L,
          sum(!coverage) == 778L, sum(zero) == 324L,
          sum(is.na(rd$glycan_composition)) == 32L,
          !"glycan_structure" %in% names(rd))
for (i in seq_along(panels)) {
  stopifnot(isTRUE(all.equal(unname(raw[rows[[i]], columns[[i]]]), unname(md[[i]]$raw_abundance))))
  stopifnot(isTRUE(all.equal(unname(percentage[rows[[i]], columns[[i]]]), unname(md[[i]]$source_relative_abundance))))
}
assign(name, x)
file <- file.path("data", paste0(name, ".rda"))
save(list = name, file = file, compress = "xz", version = 3)
# These newly built panel objects are retained losslessly inside the study object.
unlink(file.path("data", paste0(panel_names, ".rda")))
inventory <- utils::read.csv("data-raw/object-inventory.csv")
inventory <- inventory[!inventory$dataset %in% c(panel_names, name), ]
record <- data.frame(dataset = name, accession = "GPST000027;GPST000031", features = 338L,
  observations = 6L, missing = sum(is.na(abundance)), zero_to_na = sum(zero), conflict_to_na = 0L,
  typed_compositions = sum(!is.na(rd$glycan_composition)), typed_structures = 0L,
  compressed_bytes = file.info(file)$size, build_seconds = NA_real_)
utils::write.csv(rbind(inventory, record), "data-raw/object-inventory.csv", row.names = FALSE)
message(name, ": 338 x 6; 1250 measured source cells; no cross-tissue peak alignment")
