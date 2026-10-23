gprodia_source <- function(path, spec) {
  d <- as.data.frame(readxl::read_excel(
    path,
    sheet = spec$sheet,
    skip = spec$header_excel_row - 1L,
    na = c("", "NA"),
    .name_repair = "minimal"
  ))
  columns <- spec$measurement_columns_1based
  stopifnot(
    nrow(d) == spec$features,
    identical(names(d)[columns], spec$measurement_columns)
  )
  if (spec$name == "Mixture_DIA_SSL") {
    top <- readxl::read_excel(
      path,
      sheet = spec$sheet,
      range = "A1:X1",
      col_names = FALSE,
      .name_repair = "minimal"
    )
    stopifnot(top[[7]][1] == "MS2", top[[16]][1] == "MS1")
  }
  a <- as.matrix(d[columns])
  stopifnot(
    is.numeric(a),
    all(is.finite(a) | is.na(a)),
    all(a >= 0, na.rm = TRUE),
    sum(is.na(a)) == spec$missing,
    sum(a == 0, na.rm = TRUE) == spec$zeros
  )
  ids <- sprintf("PXD023980_%s_%05d", spec$name, seq_len(nrow(d)))
  dimnames(a) <- list(ids, spec$measurement_columns)
  rd <- S4Vectors::DataFrame(d[1:6], row.names = ids, check.names = FALSE)
  single <- grepl("^(sp|tr)\\|[^|;]+\\|[^;]+$", d$ProteinName)
  rd$protein <- ifelse(
    single,
    sub("^(sp|tr)\\|([^|]+)\\|.*$", "\\2", d$ProteinName),
    NA_character_
  )
  site <- as.character(d$ProteinGlycoSite)
  rd$protein_site <- rep(NA_integer_, nrow(d))
  scalar <- single & !is.na(site) & grepl("^[0-9]+$", site)
  rd$protein_site[scalar] <- as.integer(site[scalar])
  dictionary <- unlist(spec$composition_dictionary)
  parsed <- lapply(d$GlycanComposition, function(label) {
    terms <- regmatches(label, gregexpr("[A-Za-z]+\\([0-9]+\\)", label))[[1]]
    token <- sub("\\(.*$", "", terms)
    count <- as.integer(sub("^[^(]+\\(([0-9]+)\\)$", "\\1", terms))
    if (
      !identical(paste0(terms, collapse = ""), label) ||
        anyDuplicated(token) ||
        anyNA(count) ||
        any(!token[count > 0] %in% names(dictionary))
    ) {
      return(glyrepr::glycan_composition(NA))
    }
    positive <- count > 0
    glyrepr::glycan_composition(stats::setNames(
      count[positive],
      dictionary[token[positive]]
    ))
  })
  rd$glycan_composition <- do.call(c, parsed)
  rd$source_row <- seq_len(nrow(d)) + spec$header_excel_row
  key <- paste(d$FullPeptideName, d$GlycanComposition, d$Charge, sep = "\t")
  rd$repeated_source_precursor_key <- duplicated(key) |
    duplicated(key, fromLast = TRUE)
  cd <- S4Vectors::DataFrame(spec$mapping, row.names = spec$measurement_columns)
  cd$quantification_metric <- if (spec$name == "Mixture_DIA_SSL") {
    "MS2"
  } else {
    "author selected abundance"
  }
  glyexp::GlycoproteomicSE(
    a,
    rowData = rd,
    colData = cd,
    metadata = list(
      accession = "PXD023980",
      doi = spec$doi,
      glycan_type = "N",
      source_repository = "iProX",
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
        spec$variant_policy,
        "No additional normalization, aggregation, matching, filtering, zero replacement or imputation",
        "Source J notation retained; single protein/site mappings only, ambiguous groups not expanded",
        "Composition tokens H/N/F/A supported by article Fig3; unknown tokens not guessed; no structures inferred"
      )
    )
  )
}
