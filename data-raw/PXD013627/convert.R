# Protein-level N-glyco-enrichment matrices, not intact glycopeptide matrices.
pxd013627_convert <- function(path, spec) {
  d <- as.data.frame(readxl::read_excel(path, sheet = spec$sheet,
    skip = spec$header_row_1based - 1L, na = c("", "NA"), .name_repair = "minimal"))
  stopifnot(nrow(d) == spec$feature_count,
    identical(names(d), c(spec$annotation_columns, spec$measurement_columns)),
    !anyDuplicated(d[["Protein group"]]))
  a <- as.matrix(d[spec$measurement_columns])
  stopifnot(is.numeric(a), all(is.finite(a) | is.na(a)), all(a >= 0, na.rm = TRUE),
    sum(is.na(a)) == spec$missing, sum(a == 0, na.rm = TRUE) == spec$zeros)
  ids <- sprintf("PXD013627_%s_protein_%04d", spec$object_suffix, seq_len(nrow(d)))
  dimnames(a) <- list(ids, spec$measurement_columns)
  rd <- S4Vectors::DataFrame(
    protein = as.character(d[["Entry (primary)"]]),
    protein_site = rep(NA_integer_, nrow(d)),
    source_protein_group = as.character(d[["Protein group"]]),
    source_primary_entry = as.character(d[["Entry (primary)"]]),
    source_description = as.character(d[["Description (primary)"]]),
    source_row = seq_len(nrow(d)) + spec$header_row_1based,
    row.names = ids
  )
  rd$glycan_composition <- rep(glyrepr::glycan_composition(NA), nrow(d))
  rd$glycan_annotation_status <- "not provided for protein-level quantitative features"
  labels <- spec$measurement_columns
  cd <- S4Vectors::DataFrame(
    source_measurement = labels,
    source_group = sub("_r[0-9]+$", "", labels),
    source_replicate = as.integer(sub(".*_r", "", labels)),
    species = spec$species, biological_unit = spec$biological_unit,
    replicate_type = "biological; author-consolidated technical measurements",
    row.names = labels
  )
  glyexp::GlycoproteomicSE(a, rowData = rd, colData = cd, metadata = list(
    glycan_type = "N", doi = spec$doi, accession = "PXD013627",
    source = paste(spec$archive_member, spec$sheet),
    source_provenance = spec,
    license = "CC BY 4.0; original-author supplementary abundance table, no separate exclusion located",
    license_url = "https://creativecommons.org/licenses/by/4.0/",
    attribution = "Classification of mouse B cell types using surfaceome proteotype maps (2019); doi:10.1038/s41467-019-13418-5",
    assay_scale = spec$value_scale,
    quant_method = "Author MSstats sample-level protein abundance",
    raw_abundance = a, source_annotation = d[spec$annotation_columns],
    source_row = seq_len(nrow(d)) + spec$header_row_1based,
    source_measurement_columns = match(labels, names(d)),
    feature_grain = "N-glyco-enriched protein group, not intact glycopeptide or quantified glycosite",
    processing_masks = list(source_missing = is.na(a), source_zero = !is.na(a) & a == 0),
    processing = c(
      "All selected source rows and measurement columns retained; original author log2 scale is unchanged",
      "No inverse transformation, filtering, zero conversion, imputation or normalization",
      "Source literal NA denotes a missing numeric cell and is retained as NA",
      "Primary protein entry is the author's annotation; complete source protein groups retained",
      "No quantitative sites or glycan identities inferred from separate qualitative tabs",
      spec$sample_design
    )
  ))
}
