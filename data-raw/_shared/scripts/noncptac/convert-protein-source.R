# Source-grain glyco-enriched protein tables; never infer glycosites or glycans.
literature_protein_source <- function(path, spec) {
  d <- as.data.frame(readxl::read_excel(path, sheet = spec$sheet,
    range = spec$read_range, skip = spec$header_row - 1L,
    na = c("", "NA"), .name_repair = "minimal"))
  if (isTRUE(spec$privacy_anonymous_columns)) names(d)[spec$source_measurement_columns_1based] <- spec$measurement_columns
  stopifnot(nrow(d) == spec$feature_count,
    all(spec$measurement_columns %in% names(d)),
    !anyNA(d[[spec$protein_column]]))
  a <- as.matrix(d[spec$measurement_columns])
  stopifnot(is.numeric(a), all(is.finite(a) | is.na(a)), all(a >= 0, na.rm = TRUE),
    sum(is.na(a)) == spec$missing)
  ids <- sprintf("%s_protein_%05d", spec$accession, seq_len(nrow(d)))
  dimnames(a) <- list(ids, spec$measurement_columns)
  annotation <- d[setdiff(names(d), spec$measurement_columns)]
  rd <- S4Vectors::DataFrame(annotation, row.names = ids, check.names = FALSE)
  groups <- as.character(d[[spec$protein_column]])
  rd$source_protein_group <- groups
  rd$repeated_source_protein_label <- duplicated(groups) | duplicated(groups, fromLast = TRUE)
  rd$protein <- ifelse(!grepl("[;,]", groups), groups, NA_character_)
  rd$protein_site <- rep(NA_integer_, nrow(d))
  rd$glycan_composition <- rep(glyrepr::glycan_composition(NA), nrow(d))
  rd$source_row <- seq_len(nrow(d)) + spec$header_row
  cd <- S4Vectors::DataFrame(spec$sample_mapping, row.names = spec$measurement_columns)
  cd$species <- spec$species
  glyexp::GlycoproteomicSE(a, rowData = rd, colData = cd, metadata = list(
    accession = spec$accession, doi = spec$doi, glycan_type = spec$glycan_type,
    source_repository = spec$repository, source = paste(spec$local_file, spec$sheet),
    source_provenance = spec, license = spec$license,
    license_url = "https://creativecommons.org/licenses/by/4.0/",
    attribution = paste("Original author supplementary measurements; doi:", spec$doi),
    assay_scale = spec$assay_scale, raw_abundance = a, source_annotation = annotation,
    source_row = rd$source_row, source_measurement_columns = match(spec$measurement_columns, names(d)),
    feature_grain = "glyco-enriched protein; not intact glycopeptide or quantified site",
    processing_masks = list(source_missing = is.na(a), source_zero = !is.na(a) & a == 0),
    processing = c(spec$author_processing, spec$replication_caution,
      "No additional normalization, imputation, zero replacement, filtering or inverse transformation",
      "All source annotations retained; no molecular glycosite/composition/structure inferred")
  ))
}
