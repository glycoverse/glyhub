# Explicitly selected source columns; no artificial aggregation or feature matching.
literature_feature_source <- function(path, spec) {
  if (identical(spec$file_format, "csv")) {
    d <- utils::read.csv(
      path,
      check.names = FALSE,
      na.strings = c("", "NA"),
      stringsAsFactors = FALSE
    )
  } else {
    d <- as.data.frame(readxl::read_excel(
      path,
      sheet = spec$sheet,
      skip = spec$header_excel_row - 1L,
      range = spec$read_range,
      n_max = spec$features,
      na = c("", "NA"),
      .name_repair = "minimal"
    ))
  }
  columns <- spec$measurement_columns_1based
  stopifnot(nrow(d) == spec$features)
  if (isTRUE(spec$privacy_anonymous_columns)) {
    names(d)[columns] <- spec$measurement_columns
  } else {
    stopifnot(identical(names(d)[columns], spec$measurement_columns))
  }
  source_matrix <- as.matrix(d[columns])
  a <- matrix(suppressWarnings(as.numeric(source_matrix)), nrow = nrow(d))
  stopifnot(!any(!is.na(source_matrix) & is.na(a)))
  stopifnot(
    is.numeric(a),
    all(is.finite(a) | is.na(a)),
    all(a >= 0, na.rm = TRUE),
    sum(is.na(a)) == spec$missing,
    sum(a == 0, na.rm = TRUE) == spec$zeros
  )
  ids <- sprintf("%s_source_%05d", spec$accession, seq_len(nrow(d)))
  dimnames(a) <- list(ids, spec$measurement_columns)
  annotations <- spec$annotation_columns_1based
  if (is.null(annotations)) {
    annotations <- setdiff(seq_len(ncol(d)), columns)
  }
  rd <- S4Vectors::DataFrame(
    d[annotations],
    row.names = ids,
    check.names = FALSE
  )
  protein <- as.character(d[[spec$protein_column]])
  rd$source_protein_annotation <- protein
  rd$protein <- ifelse(
    !is.na(protein) & !grepl("[;,]", protein),
    protein,
    NA_character_
  )
  rd$protein_site <- rep(NA_integer_, nrow(d))
  rd$glycan_composition <- rep(glyrepr::glycan_composition(NA), nrow(d))
  if (!is.null(spec$composition_column)) {
    label <- as.character(d[[spec$composition_column]])
    parsed <- lapply(label, function(value) {
      tryCatch(
        glyrepr::as_glycan_composition(value),
        error = function(e) glyrepr::glycan_composition(NA)
      )
    })
    rd$glycan_composition <- do.call(c, parsed)
  }
  rd$source_row <- seq_len(nrow(d)) + spec$header_excel_row
  if (!is.null(spec$composition_structure_conflict_excel_rows)) {
    conflict <- rd$source_row %in%
      spec$composition_structure_conflict_excel_rows
    rd$source_structure_composition_conflict <- conflict
    rd$glycan_composition[conflict] <- glyrepr::glycan_composition(NA)
  }
  cd <- S4Vectors::DataFrame(spec$mapping, row.names = spec$measurement_columns)
  glyexp::GlycoproteomicSE(
    a,
    rowData = rd,
    colData = cd,
    metadata = list(
      accession = spec$accession,
      doi = spec$doi,
      glycan_type = spec$glycan_type,
      source_repository = spec$repository,
      source = paste(spec$local_file, spec$sheet),
      source_provenance = spec,
      license = spec$license,
      license_url = "https://creativecommons.org/licenses/by/4.0/",
      assay_scale = spec$scale,
      feature_grain = spec$molecular_level,
      raw_abundance = a,
      source_table = d,
      source_row = rd$source_row,
      source_measurement_columns = columns,
      processing_masks = list(
        source_missing = is.na(a),
        source_zero = !is.na(a) & a == 0
      ),
      processing = c(
        spec$design,
        spec$limitations,
        "Retain complete selected source rows/columns; no imputation, normalization, filtering, inverse transformation or zero replacement",
        "Keep source annotation ambiguity; only explicit canonical composition strings parsed, no structures inferred",
        "Protein groups remain verbatim; no ambiguous absolute glycosites inferred"
      )
    )
  )
}
