# Expand the versioned storage representation before any scientific processing.
read_matrix_specs <- function(path) {
  document <- jsonlite::fromJSON(path, simplifyVector = FALSE)
  if (is.null(document$format)) {
    return(document)
  }
  stopifnot(identical(document$format, "glyhub-compact-specs-v1"))
  matrix_fields <- c(
    "raw_matrix",
    "matrix",
    "raw_source_matrix",
    "source_cell_rows",
    "source_cell_columns",
    "source_coverage"
  )
  lapply(document$specs, function(s) {
    for (key in intersect(names(s), matrix_fields)) {
      value <- s[[key]]
      if (!identical(value$encoding, "runs")) {
        next
      }
      dims <- unlist(value$dim)
      counts <- vapply(value$runs, function(r) r[[1]], numeric(1))
      stopifnot(
        length(dims) == 2L,
        all(dims >= 0),
        all(dims == floor(dims)),
        all(counts > 0),
        all(counts == floor(counts)),
        sum(counts) == prod(dims)
      )
      flat <- rep(lapply(value$runs, function(r) r[[2]]), counts)
      s[[key]] <- lapply(seq_len(dims[1]), function(i) {
        flat[(i - 1L) * dims[2] + seq_len(dims[2])]
      })
    }
    value <- s$row_annotations
    if (identical(value$encoding, "records")) {
      keys <- unlist(value$keys)
      s$row_annotations <- lapply(value$rows, function(row) {
        stopifnot(length(row) == length(keys), !anyDuplicated(keys))
        stats::setNames(row, keys)
      })
    }
    s
  })
}

# Build typed objects from reviewed, checksum-pinned quantitative table mappings.
# Original measurements and source annotations are retained in metadata.
build_matrix_specs <- function(path) {
  scalar <- function(x, default = NA) {
    if (is.null(x) || length(x) == 0) default else x
  }
  vec <- function(x, default = NA_character_) {
    vapply(x, function(z) as.character(scalar(z, default)), character(1))
  }
  numeric_matrix <- function(x) {
    m <- do.call(
      rbind,
      lapply(x, function(r) {
        vapply(
          r,
          function(z) {
            if (is.null(z)) NA_real_ else suppressWarnings(as.numeric(z))
          },
          numeric(1)
        )
      })
    )
    storage.mode(m) <- "double"
    m
  }
  specs <- read_matrix_specs(path)
  for (s in specs) {
    build_started <- proc.time()[["elapsed"]]
    stopifnot(
      file.exists(s$source_file),
      unname(tools::md5sum(s$source_file)) == s$source_md5
    )
    raw <- numeric_matrix(s$raw_matrix)
    dimnames(raw) <- list(unlist(s$feature_ids), unlist(s$sample_ids))
    coverage <- if (is.null(s$source_coverage)) {
      matrix(TRUE, nrow(raw), ncol(raw), dimnames = dimnames(raw))
    } else {
      z <- numeric_matrix(s$source_coverage)
      dimnames(z) <- dimnames(raw)
      z != 0
    }
    stopifnot(
      identical(dim(coverage), dim(raw)),
      !anyNA(coverage),
      all(is.na(raw[!coverage]))
    )
    zero <- !is.na(raw) & raw == 0
    abundance <- raw
    conflict <- matrix(FALSE, nrow(raw), ncol(raw), dimnames = dimnames(raw))
    if (length(s$conflict_columns)) {
      conflict[, unlist(s$conflict_columns)] <- TRUE
    }
    abundance[zero | conflict] <- NA_real_
    rd <- S4Vectors::DataFrame(
      source_feature_id = rownames(raw),
      row.names = rownames(raw)
    )
    annotations <- s$row_annotations
    rd$source_annotations <- I(annotations)
    comps <- lapply(seq_len(nrow(raw)), function(i) {
      counts <- annotations[[i]]$composition_counts
      if (!is.null(counts) && length(counts) > 0) {
        counts <- unlist(counts)
        counts <- counts[counts > 0]
        if (length(counts)) return(glyrepr::glycan_composition(counts))
      }
      label <- s$composition[[i]]
      if (is.null(label) || !nzchar(label)) {
        return(glyrepr::glycan_composition(NA))
      }
      tryCatch(glyrepr::as_glycan_composition(label), error = function(e) {
        stop(
          "Invalid reviewed composition in ",
          s$name,
          " row ",
          i,
          ": ",
          conditionMessage(e)
        )
      })
    })
    rd$glycan_composition <- do.call(c, comps)
    structures <- if (is.null(s$structure_iupac)) {
      rep(NA_character_, nrow(raw))
    } else {
      vec(s$structure_iupac)
    }
    if (any(!is.na(structures))) {
      rd$glycan_structure <- glyrepr::as_glycan_structure(structures)
    }
    cd <- S4Vectors::DataFrame(row.names = colnames(raw))
    for (key in names(s$col_data)) {
      vals <- s$col_data[[key]]
      stopifnot(length(vals) == ncol(raw))
      nonmissing <- Filter(Negate(is.null), vals)
      if (
        length(nonmissing) && all(vapply(nonmissing, is.logical, logical(1)))
      ) {
        cd[[key]] <- vapply(
          vals,
          function(z) as.logical(scalar(z, NA)),
          logical(1)
        )
      } else if (
        length(nonmissing) && all(vapply(nonmissing, is.numeric, logical(1)))
      ) {
        cd[[key]] <- vapply(
          vals,
          function(z) as.numeric(scalar(z, NA_real_)),
          numeric(1)
        )
      } else {
        cd[[key]] <- vapply(
          vals,
          function(z) as.character(scalar(z, NA_character_)),
          character(1)
        )
      }
    }
    rr <- s$row_indices
    cc <- s$column_indices
    idx <- expand.grid(
      feature_index = seq_len(nrow(raw)),
      observation_index = seq_len(ncol(raw))
    )
    idx$feature_id <- rownames(raw)[idx$feature_index]
    idx$observation_id <- colnames(raw)[idx$observation_index]
    idx$source_row <- if (
      length(rr) == nrow(raw) &&
        all(vapply(rr, function(x) length(x) == 1, logical(1)))
    ) {
      unlist(rr)[idx$feature_index]
    } else {
      NA_integer_
    }
    idx$source_column <- if (length(cc) == ncol(raw)) {
      unlist(cc)[idx$observation_index]
    } else {
      NA_integer_
    }
    if (!is.null(s$source_cell_rows)) {
      idx$source_row <- as.vector(numeric_matrix(s$source_cell_rows))
    }
    if (!is.null(s$source_cell_columns)) {
      idx$source_column <- as.vector(numeric_matrix(s$source_cell_columns))
    }
    idx$original_value <- as.vector(raw)
    idx$curated_value <- as.vector(abundance)
    idx$reason <- ifelse(
      !as.vector(coverage),
      "not_measured_in_source_panel",
      ifelse(
        as.vector(conflict),
        "source_conflict",
        ifelse(
          as.vector(zero),
          "zero_abundance",
          ifelse(
            is.na(idx$original_value),
            "source_missing_or_nonnumeric",
            "unchanged"
          )
        )
      )
    )
    source_table <- if (!is.null(s$validated_source_table_file)) {
      # Some BIFF files contain nested chart streams which readxl/libxls can
      # mistake for worksheet cells. Use only the independently verified,
      # checksum-pinned worksheet extraction for these explicitly marked files.
      table_file <- s$validated_source_table_file
      stopifnot(
        unname(tools::md5sum(table_file)) == s$validated_source_table_md5
      )
      table_data <- jsonlite::fromJSON(table_file, simplifyVector = FALSE)
      stopifnot(identical(table_data$sheet, s$sheet))
      do.call(
        rbind,
        lapply(table_data$values, function(row) {
          vapply(
            row,
            function(value) as.character(scalar(value, NA_character_)),
            character(1)
          )
        })
      )
    } else if (grepl("[.]xlsx?$", s$source_file, ignore.case = TRUE)) {
      as.matrix(readxl::read_excel(
        s$source_file,
        sheet = s$sheet,
        range = readxl::cell_limits(c(1, 1), c(NA, NA)),
        col_names = FALSE,
        col_types = "text",
        .name_repair = "minimal"
      ))
    } else {
      NULL
    }
    if (
      !is.null(source_table) &&
        length(rr) == nrow(raw) &&
        length(cc) == ncol(raw)
    ) {
      source_values <- suppressWarnings(matrix(
        as.numeric(source_table[unlist(rr), unlist(cc), drop = FALSE]),
        nrow(raw),
        ncol(raw)
      ))
      stopifnot(isTRUE(all.equal(
        unname(raw),
        source_values,
        tolerance = 1e-12
      )))
    }
    if (!is.null(s$source_cell_rows) && !is.null(source_table)) {
      take <- which(as.vector(coverage))
      observed <- suppressWarnings(as.numeric(source_table[cbind(
        idx$source_row[take],
        idx$source_column[take]
      )]))
      stopifnot(isTRUE(all.equal(
        observed,
        as.vector(raw)[take],
        tolerance = 1e-12
      )))
    }
    md <- list(
      accession = s$accession,
      dataset_name = s$name,
      glycan_type = s$glycan_type,
      source_glycan_type = s$source_glycan_type,
      title = s$title,
      source = list(
        file = s$source_file,
        url = s$source_url,
        sheet = s$sheet,
        md5 = s$source_md5,
        row_indices = rr,
        column_indices = cc
      ),
      citation = paste0(s$title, ". DOI: ", s$doi),
      license = s$license,
      unit = s$unit,
      source_table = source_table,
      raw_abundance = raw,
      source_coverage = coverage,
      raw_text = s$raw_source_matrix,
      processing_masks = list(
        zero_to_na = zero,
        conflict = conflict,
        source_missing = coverage & is.na(raw),
        not_measured = !coverage
      ),
      processing_counts = c(
        zero_to_na = sum(zero),
        conflict = sum(conflict),
        source_missing = sum(coverage & is.na(raw)),
        not_measured = sum(!coverage)
      ),
      processing_ledger = idx,
      zero_to_na = TRUE,
      zero_handling = "Only quantitative assay zeros become NA. Original measurements and annotation zeros are retained. No imputation or renormalization is applied.",
      molecular_annotation = s$annotation,
      reviewed_mapping = s,
      software = list(
        glyexp = as.character(utils::packageVersion("glyexp")),
        glyrepr = as.character(utils::packageVersion("glyrepr"))
      )
    )
    if (identical(s$object_class, "GlycoproteomicSE")) {
      rd$protein <- vapply(
        annotations,
        function(a) scalar(a$protein, NA_character_),
        character(1)
      )
      rd$protein_site <- vapply(
        annotations,
        function(a) as.integer(scalar(a$protein_site, NA_integer_)),
        integer(1)
      )
      object <- glyexp::GlycoproteomicSE(
        abundance,
        rowData = rd,
        colData = cd,
        metadata = md
      )
    } else {
      object <- glyexp::GlycomicSE(
        abundance,
        rowData = rd,
        colData = cd,
        metadata = md
      )
    }
    stopifnot(
      isTRUE(methods::validObject(object)),
      !any(abundance == 0, na.rm = TRUE)
    )
    assign(s$name, object)
    save(
      list = s$name,
      file = file.path("data", paste0(s$name, ".rda")),
      compress = "xz",
      version = 3
    )
    inventory_path <- "data-raw/object-inventory.csv"
    record <- data.frame(
      dataset = s$name,
      accession = s$accession,
      features = nrow(raw),
      observations = ncol(raw),
      missing = sum(is.na(abundance)),
      zero_to_na = sum(zero),
      conflict_to_na = sum(conflict),
      typed_compositions = sum(!is.na(rd$glycan_composition)),
      typed_structures = sum(!is.na(rd$glycan_structure)),
      compressed_bytes = file.info(file.path(
        "data",
        paste0(s$name, ".rda")
      ))$size,
      build_seconds = proc.time()[["elapsed"]] - build_started
    )
    inventory <- if (file.exists(inventory_path)) {
      utils::read.csv(inventory_path)
    } else {
      record[FALSE, ]
    }
    inventory <- rbind(inventory[inventory$dataset != s$name, ], record)
    utils::write.csv(inventory, inventory_path, row.names = FALSE)
    message(s$name, ": ", nrow(raw), " x ", ncol(raw))
  }
}
