# Each file is one run-specific source PSM table, never an aligned molecular matrix.
pxd047982_convert <- function(path, spec, provenance) {
  d <- utils::read.delim(path, check.names = FALSE, stringsAsFactors = FALSE,
    quote = "", comment.char = "", na.strings = character())
  stopifnot(nrow(d) == spec$rows, identical(names(d), spec$columns),
    identical(unique(d$RawName), spec$actual_raw_names),
    is.numeric(d$MonoArea), all(is.finite(d$MonoArea)), all(d$MonoArea >= 0))
  run <- unique(d$RawName)
  stopifnot(length(run) == 1L)
  prefix <- paste("PXD047982", spec$age, spec$enrichment,
    spec$biological_replicate_label, sep = "_")
  ids <- sprintf("%s_PSM_%05d", prefix, seq_len(nrow(d)))
  a <- matrix(d$MonoArea, ncol = 1L, dimnames = list(ids, run))
  rd <- S4Vectors::DataFrame(d, row.names = ids, check.names = FALSE)
  single <- grepl("^(sp|tr)\\|[^|;]+\\|[^;]+$", d$Proteins)
  rd$protein <- ifelse(single, sub("^(sp|tr)\\|([^|]+)\\|.*$", "\\2", d$Proteins), NA_character_)
  rd$protein_site <- rep(NA_integer_, nrow(d))
  rd$glycan_composition <- rep(glyrepr::glycan_composition(NA), nrow(d))
  rd$source_row <- seq_len(nrow(d)) + 1L
  molecular_key <- paste(d$Peptide, d$Mod, d[["Glycan(H,N,A,F,G)"]], sep = "\t")
  rd$repeated_source_molecular_key <- duplicated(molecular_key) |
    duplicated(molecular_key, fromLast = TRUE)
  cd <- S4Vectors::DataFrame(
    source_run = run, source_deposition_run_label = spec$raw_run_name,
    species = "Mus musculus", material = "testis", source_age = spec$age,
    enrichment = spec$enrichment, source_replicate_label = spec$biological_replicate_label,
    replicate_type = "author-reported biological replicate within age/enrichment group",
    cross_enrichment_sample_linkage = "not established; do not infer 16 independent animals",
    row.names = run
  )
  glyexp::GlycoproteomicSE(a, rowData = rd, colData = cd, metadata = list(
    accession = provenance$accession, doi = provenance$doi, glycan_type = "O",
    source_repository = "iProX",
    source = spec$name, source_provenance = spec,
    license = "CC0-1.0 under iProX dataset policy and verified submission date",
    license_evidence = provenance$license,
    attribution = paste("Author-deposited PXD047982 pGlyco output; doi:", provenance$doi),
    assay_scale = "linear author MonoArea per source PSM; not aligned across runs",
    quant_method = "Author-reported MonoArea",
    feature_grain = "run-specific source PSM row, not unique molecular feature",
    raw_abundance = a, source_table = d, source_measurement_columns = match("MonoArea", names(d)),
    source_row = seq_len(nrow(d)) + 1L,
    processing_masks = list(source_missing = is.na(a), source_zero = a == 0),
    processing = c(
      "All source PSM rows retained; no aggregation, matching, alignment, normalization or imputation",
      "MonoArea is the sole measurement; IsotopeArea and corrected quantities are annotations, not samples",
      "Original negative sentinel values in annotation columns remain unchanged",
      "Source GlySpec, Scan, GlycanComposition and PlausibleStruct are retained verbatim",
      "No unverified source composition notation, plausible topology or protein site is promoted to a typed claim",
      "Repeated molecular features are flagged; separate run objects cannot be compared as an aligned assay"
    )
  ))
}
