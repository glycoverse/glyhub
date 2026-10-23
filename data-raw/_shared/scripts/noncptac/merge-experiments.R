# Exact source-feature union, not normalization or inference of missing values.
merge_literature_experiments <- function(experiments, identities, prefix) {
  stopifnot(length(experiments) == length(identities), length(experiments) > 1L,
    !is.null(names(experiments)), identical(names(experiments), names(identities)))
  citations <- jsonlite::fromJSON("data-raw/_shared/metadata/noncptac/literature-citations.json")
  experiments <- lapply(experiments, function(x) {
    md <- S4Vectors::metadata(x)
    citation <- citations[[md$doi]]
    stopifnot(!is.null(citation))
    md$citation <- citation
    md$attribution <- paste(citation$authors, paste0("(", citation$year, ")."),
      citation$title, citation$url)
    md$format_adaptation <- "Original author-selected measurements reshaped into a GlycoproteomicSE; no additional numerical transformation"
    S4Vectors::metadata(x) <- md
    x
  })
  fields <- names(identities[[1]])
  keys <- lapply(identities, function(d) {
    stopifnot(identical(names(d), fields), !anyNA(d))
    parts <- lapply(d, function(v) {
      if (is.numeric(v)) sprintf("%.17g", v) else as.character(v)
    })
    stopifnot(!any(vapply(parts, function(v) any(grepl("\037", v, fixed = TRUE)), logical(1))))
    key <- do.call(paste, c(parts, sep = "\037"))
    stopifnot(!anyDuplicated(key))
    key
  })
  all_keys <- unlist(keys, use.names = FALSE)
  union_keys <- unique(all_keys)
  first <- match(union_keys, all_keys)
  ids <- paste0(prefix, "_", vapply(union_keys, function(k)
    substr(digest::digest(k, algo = "sha256", serialize = FALSE), 1L, 20L), character(1)))
  stopifnot(!anyDuplicated(ids))
  samples <- unlist(lapply(experiments, colnames), use.names = FALSE)
  if (anyDuplicated(samples)) {
    samples <- unlist(Map(function(name, x) paste0(name, "__", colnames(x)),
      names(experiments), experiments), use.names = FALSE)
  }
  stopifnot(!anyDuplicated(samples))
  a <- matrix(NA_real_, length(ids), length(samples), dimnames = list(ids, samples))
  covered <- source_missing <- source_zero <- matrix(FALSE, nrow(a), ncol(a), dimnames = dimnames(a))
  row_maps <- column_maps <- list()
  offset <- 0L
  for (name in names(experiments)) {
    x <- experiments[[name]]
    original <- SummarizedExperiment::assay(x)
    ri <- match(keys[[name]], union_keys)
    ci <- offset + seq_len(ncol(x))
    stopifnot(length(ri) == nrow(x), !anyNA(ri))
    a[ri, ci] <- original
    covered[ri, ci] <- TRUE
    source_missing[ri, ci] <- is.na(original)
    source_zero[ri, ci] <- !is.na(original) & original == 0
    rd0 <- SummarizedExperiment::rowData(x)
    row_maps[[name]] <- data.frame(source_row_index = seq_len(nrow(x)),
      source_excel_row = rd0$source_row, source_feature_id = rownames(x),
      merged_row_index = ri, merged_feature_id = ids[ri])
    column_maps[[name]] <- data.frame(source_column_index = seq_len(ncol(x)),
      source_sample_id = colnames(x), merged_column_index = ci,
      merged_sample_id = samples[ci])
    recovered <- a[ri, ci, drop = FALSE]
    dimnames(recovered) <- dimnames(original)
    stopifnot(identical(recovered, original))
    offset <- offset + ncol(x)
  }
  groups <- split(seq_along(all_keys), factor(all_keys, levels = union_keys))
  row_data <- lapply(experiments, SummarizedExperiment::rowData)
  common <- Reduce(intersect, lapply(row_data, names))
  # These quantities/coordinates belong to a source experiment, not one global row.
  common <- setdiff(common, c("source_row", "PSMs", "repeated_source_peptide"))
  rd <- S4Vectors::DataFrame(row.names = ids)
  conflicts <- rep("", length(ids))
  for (field in common) {
    values <- do.call(c, unname(lapply(row_data, function(d) d[[field]])))
    selected <- values[first]
    if (field == "source_structure_composition_conflict") {
      selected <- vapply(groups, function(i) any(values[i]), logical(1))
      names(selected) <- NULL
    } else {
      labels <- as.character(values)
      changed <- vapply(groups, function(i) length(unique(labels[i])) > 1L, logical(1))
      if (any(changed)) {
        if (field == "glycan_composition") selected[changed] <- glyrepr::glycan_composition(NA) else selected[changed] <- NA
        conflicts[changed] <- ifelse(nzchar(conflicts[changed]),
          paste(conflicts[changed], field, sep = ";"), field)
      }
    }
    rd[[field]] <- selected
  }
  if ("source_structure_composition_conflict" %in% names(rd)) {
    rd$glycan_composition[rd$source_structure_composition_conflict] <- glyrepr::glycan_composition(NA)
  }
  rd$source_annotation_conflict_fields <- conflicts
  rd$source_experiment_count <- lengths(groups)
  if (all(vapply(row_data, function(d) "repeated_source_peptide" %in% names(d), logical(1)))) {
    repeated <- unlist(lapply(row_data, function(d) d$repeated_source_peptide), use.names = FALSE)
    rd$source_peptide_repeated_in_any_experiment <- unname(vapply(groups,
      function(i) any(repeated[i]), logical(1)))
  }
  cd <- do.call(rbind, lapply(experiments, SummarizedExperiment::colData))
  cd$experiment <- rep(names(experiments), vapply(experiments, ncol, integer(1)))
  cd$batch <- cd$experiment
  rownames(cd) <- samples
  md <- S4Vectors::metadata(experiments[[1]])
  md[c("source_table", "source_tables", "source_row", "source_measurement_columns",
    "source_measurement_sheets")] <- NULL
  md$source_repository <- "Publication"
  md$raw_abundance <- a
  md$source_experiments <- experiments
  md$source_experiment_row_maps <- row_maps
  md$source_experiment_column_maps <- column_maps
  md$alignment_key_fields <- fields
  md$alignment_identity_table <- do.call(rbind, identities)[first, , drop = FALSE]
  rownames(md$alignment_identity_table) <- ids
  md$source_provenance <- lapply(experiments, function(x) S4Vectors::metadata(x)$source_provenance)
  md$processing_masks <- list(source_coverage = covered, structural_missing = !covered,
    source_missing = source_missing, source_zero = source_zero)
  md$processing <- c(
    "Exact complete source-feature identity union; no averaging, normalization, imputation or value transformation",
    "Absent feature/experiment combinations are structural NA, distinguished from original source missing values and zeros",
    "Original experiments, annotations, source tables, row order and exact round-trip maps are retained",
    "Different experimental batches remain separate measurements; merged storage does not establish cross-batch quantitative comparability",
    "Variable source annotations are not silently replaced by the first experiment's value"
  )
  x <- glyexp::GlycoproteomicSE(a, rowData = rd, colData = cd, metadata = md)
  stopifnot(methods::validObject(x), identical(is.na(a), source_missing | !covered))
  x
}

# Only retire named local staged resources; never touch a released baseline entry.
retire_staged_experiments <- function(old_names, new_name, selectors, path,
  selector_column = "experiment", selector_values = selectors) {
  manifest <- utils::read.delim("inst/extdata/manifest.tsv", stringsAsFactors = FALSE)
  old <- manifest[manifest$dataset %in% old_names, , drop = FALSE]
  stopifnot(all(old$storage == "staged"))
  baseline <- utils::read.delim("tests/testthat/fixtures/baseline-manifest.tsv")
  stopifnot(!any(old_names %in% baseline$dataset))
  prior <- if (file.exists(path)) jsonlite::fromJSON(path, simplifyVector = FALSE) else list()
  migration <- lapply(seq_along(old_names), function(i) {
    record <- old[old$dataset == old_names[i], , drop = FALSE]
    previous_sha <- if (nrow(record)) record$sha256 else prior[[i]]$previous_local_sha256
    list(previous_local_id = old_names[i], previous_local_sha256 = previous_sha,
      canonical_id = new_name, source_experiment = selectors[i],
      column_selector = list(field = selector_column, value = selector_values[i]),
      access_original_experiment = sprintf('S4Vectors::metadata(x)$source_experiments[["%s"]]', selectors[i]),
      status = "unpublished local identifier superseded; no silent loader alias")
  })
  for (file in c("inst/extdata/manifest.tsv", "data-raw/_shared/metadata/noncptac/manifest.tsv",
    "inst/extdata/catalog-metadata.tsv")) {
    d <- utils::read.delim(file, colClasses = "character", na.strings = character(), check.names = FALSE)
    utils::write.table(d[!d$dataset %in% old_names, , drop = FALSE], file,
      sep = "\t", quote = FALSE, row.names = FALSE, na = "")
  }
  for (name in old_names) {
    unlink(c(file.path("R", paste0("data-", name, ".R")), file.path("man", paste0(name, ".Rd")),
      file.path("data-raw", strsplit(name, "_", fixed = TRUE)[[1]][2], paste0(name, "-receipt.json"))))
  }
  jsonlite::write_json(migration, path, pretty = TRUE, auto_unbox = TRUE, null = "null")
  invisible(migration)
}
