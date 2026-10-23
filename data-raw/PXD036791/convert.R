pxd036791_read <- function(path, sheet) {
  d <- as.data.frame(readxl::read_excel(
    path,
    sheet = sheet,
    na = c("", "NA"),
    .name_repair = "minimal"
  ))
  stopifnot(!anyNA(d$Identifier), !anyDuplicated(d$Identifier))
  d
}

pxd036791_convert <- function(path, specs, secretome = FALSE) {
  tables <- lapply(specs, function(s) pxd036791_read(path, s$sheet))
  names(tables) <- vapply(specs, function(s) s$sheet, character(1))
  d <- tables[[1]]
  columns <- specs[[1]]$measurement_columns
  a <- as.matrix(d[columns])
  source_sheet <- rep(specs[[1]]$sheet, ncol(a))
  source_column <- match(columns, names(d))
  if (secretome) {
    stopifnot(length(tables) == 2L)
    d2 <- tables[[2]]
    # Independent descriptions establish the same sixplex; verify keys and WT.
    stopifnot(
      identical(d$Identifier, d2$Identifier),
      identical(d$Sequence, d2$Sequence),
      identical(d$GlycoSite, d2$GlycoSite),
      identical(d$GlycanType, d2$GlycanType),
      identical(d$GlyNum, d2$GlyNum),
      identical(
        a[, 1:2, drop = FALSE],
        as.matrix(d2[specs[[2]]$measurement_columns[1:2]])
      )
    )
    extra <- specs[[2]]$measurement_columns[3:4]
    a <- cbind(a, as.matrix(d2[extra]))
    source_sheet <- c(source_sheet, rep(specs[[2]]$sheet, 2L))
    source_column <- c(source_column, match(extra, names(d2)))
    group <- c("WT", "WT", "GALNT1_KO", "GALNT1_KO", "GALNT2_KO", "GALNT2_KO")
    replicate <- rep(1:2, 3L)
    replicate_type <- c(rep("technical", 2L), rep("biological", 4L))
    experiment <- "Secretome_GALNT1_GALNT2"
  } else {
    stopifnot(length(tables) == 1L)
    experiment <- sub("^∆", "", sub("_Glycoproteome$", "", specs[[1]]$sheet))
    group <- c(rep("WT", 3L), rep(paste0(experiment, "_KO"), 3L))
    replicate <- rep(1:3, 2L)
    replicate_type <- c(
      rep("technical", 3L),
      rep("distinct biological KO clone", 3L)
    )
  }
  stopifnot(
    is.numeric(a),
    all(is.finite(a) | is.na(a)),
    all(a >= 0, na.rm = TRUE),
    ncol(a) == 6L,
    nrow(a) == specs[[1]]$feature_count
  )
  ids <- sprintf("PXD036791_%s_%05d", experiment, seq_len(nrow(d)))
  samples <- paste0(experiment, "_TMT", 126:131)
  dimnames(a) <- list(ids, samples)
  single_protein <- !grepl("[;,]", d$Accessions)
  valid_site <- grepl("^[^:]+:[0-9]+:[ST]$", d$GlycoSite)
  site <- rep(NA_integer_, nrow(d))
  site[single_protein & valid_site] <- as.integer(sub(
    "^[^:]+:([0-9]+):[ST]$",
    "\\1",
    d$GlycoSite[single_protein & valid_site]
  ))
  rd <- S4Vectors::DataFrame(
    protein = ifelse(single_protein, d$Accessions, NA_character_),
    protein_site = site,
    peptide = d$Sequence,
    source_identifier = d$Identifier,
    source_gene = d$Gene,
    source_accessions = d$Accessions,
    source_site = d$GlycoSite,
    source_glycan_type = d$GlycanType,
    source_glycan_number = d$GlyNum,
    source_modification = d$Modi,
    source_row = seq_len(nrow(d)) + 1L,
    multisite_peptide_signal = d$GlyNum > 1L,
    repeated_source_peptide = duplicated(d$Sequence) |
      duplicated(d$Sequence, fromLast = TRUE),
    row.names = ids
  )
  rd$glycan_composition <- rep(glyrepr::glycan_composition(NA), nrow(d))
  rd$glycan_annotation_status <- "Author T/Tn labels retained; no composition or topology inferred"
  cd <- S4Vectors::DataFrame(
    source_sheet = source_sheet,
    source_measurement_column = source_column,
    source_channel = as.character(126:131),
    experiment = experiment,
    source_group = group,
    source_replicate = replicate,
    replicate_type = replicate_type,
    species = "Homo sapiens",
    cell_line = "N/TERT-1",
    material = if (secretome) "secretome" else "total cell lysate",
    row.names = samples
  )
  glyexp::GlycoproteomicSE(
    a,
    rowData = rd,
    colData = cd,
    metadata = list(
      glycan_type = "O",
      doi = "10.1038/s41467-022-33806-8",
      accession = "PXD036791",
      source = "Supplementary Data 2; complete author glycopeptide abundance sheets",
      source_provenance = specs,
      license = "CC BY 4.0; original-author supplementary abundance table, no separate exclusion located",
      license_url = "https://creativecommons.org/licenses/by/4.0/",
      attribution = "Global mapping of GalNAc-T isoform-specificities and O-glycosylation site-occupancy in a tissue-forming human cell line (2022); doi:10.1038/s41467-022-33806-8",
      assay_scale = "Linear author-normalized TMT6plex reporter abundance; source total-peptide-level normalization",
      quant_method = "TMT6plex, Proteome Discoverer; source normalization retained",
      raw_abundance = a,
      source_tables = tables,
      source_row = seq_len(nrow(d)) + 1L,
      source_measurement_columns = source_column,
      source_measurement_sheets = source_sheet,
      feature_grain = "Author site-associated glycopeptide signal; multisite peptide signal is copied to constituent sites",
      processing_masks = list(
        source_missing = is.na(a),
        source_zero = !is.na(a) & a == 0
      ),
      processing = c(
        "All source rows and full reporter channels retained; no additional normalization, imputation, inverse transformation or filtering",
        "Site-associated rows from the same multisite peptide are not independently quantified sites",
        "Original author statistics and all annotations retained in source_tables",
        if (secretome) {
          "Two sheets are one sixplex: exact keys and WT quantities verified, WT retained once; no averaging"
        } else {
          "This is one independent sixplex; WT channels are not joined to other experiments"
        },
        "The stale description accession PXD031998 conflicts with article and Data7 PXD036791; recorded, not treated as another dataset"
      )
    )
  )
}
