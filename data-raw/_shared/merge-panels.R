# Consolidate study/type panels without inventing cross-panel feature identity.
merge_study_panels <- function() {
  catalog <- jsonlite::fromJSON(
    'data-raw/_shared/panel-descriptions.json',
    simplifyVector = FALSE
  )
  objects <- lapply(catalog, function(d) {
    e <- new.env()
    load(file.path('data-raw/_shared/bundled-build', paste0(d$name, '.rda')), e)
    e[[d$name]]
  })
  names(objects) <- vapply(catalog, `[[`, '', 'name')
  md <- lapply(objects, S4Vectors::metadata)
  group <- vapply(
    seq_along(objects),
    function(i) {
      m <- md[[i]]
      type <- m$glycan_type
      if (grepl('^O', type)) {
        type <- 'O'
      }
      if (m$accession %in% c('GPST000738', 'GPST000602')) {
        return(names(objects)[i])
      }
      measurement <- m$reviewed_mapping$measurement_group
      if (is.null(measurement)) {
        measurement <- ''
      }
      paste(m$accession, type, class(objects[[i]])[1], measurement, sep = '|')
    },
    ''
  )
  align213 <- read.csv(
    'data-raw/GPST000213/feature_alignment.csv',
    check.names = FALSE
  )
  align035 <- read.csv(
    'data-raw/GPST000035/feature_alignment.csv',
    check.names = FALSE
  )
  final <- list()
  mapping <- list()
  audit <- list()
  for (g in unique(group)) {
    ids <- which(group == g)
    xs <- objects[ids]
    ds <- catalog[ids]
    ms <- md[ids]
    ns <- names(xs)
    if (length(ids) == 1L) {
      final <- c(final, ds)
      mapping[[length(mapping) + 1L]] <- data.frame(
        old_name = ns,
        new_name = ns,
        features = nrow(xs[[1]]),
        observations = ncol(xs[[1]])
      )
      next
    }
    acc <- ms[[1]]$accession
    type <- ms[[1]]$glycan_type
    if (grepl('^O', type)) {
      type <- 'O'
    }
    name <- paste0('glyhub_', acc, '_', type)
    measurement <- ms[[1]]$reviewed_mapping$measurement_group
    if (!is.null(measurement) && nzchar(measurement)) {
      name <- paste0(name, '_', measurement)
    }
    units <- unique(vapply(ms, function(m) m$unit, ''))
    stopifnot(length(units) == 1L)
    fk <- lapply(seq_along(xs), function(i) {
      x <- xs[[i]]
      r <- SummarizedExperiment::rowData(x)
      m <- ms[[i]]
      key <- paste(ns[i], rownames(x), sep = '::')
      if (acc == 'GPST000035') {
        a <- align035[
          match(
            paste(m$source$sheet, rownames(x)),
            paste(align035$sheet, align035$feature_id)
          ),
        ]
        stopifnot(!anyNA(a$aligned_feature_id))
        key <- paste0(acc, '::', a$aligned_feature_id)
      }
      if (acc == 'GPST000213') {
        a <- align213[
          match(
            paste(ns[i], rownames(x)),
            paste(align213$old_panel, align213$source_feature_id)
          ),
        ]
        stopifnot(!anyNA(a$new_key))
        key <- paste0(acc, '::', a$new_key)
      }
      if (acc == 'GPST000431') {
        key <- paste0(
          acc,
          '::composition_feature::',
          unname(as.character(r$glycan_composition))
        )
      }
      if (acc == 'GPST000676') {
        key <- paste0(
          acc,
          '::',
          vapply(r$source_annotations, function(a) a$source_feature_label, '')
        )
      }
      if (acc == 'GPST000578') {
        gt <- vapply(
          r$source_annotations,
          function(a) {
            if (is.null(a$glytoucan_accession)) {
              NA_character_
            } else {
              a$glytoucan_accession
            }
          },
          ''
        )
        good <- !is.na(gt) & !duplicated(gt) & !duplicated(gt, fromLast = TRUE)
        key[good] <- paste0(acc, '::GlyTouCan::', gt[good])
      }
      if (acc == 'GPST000643') {
        z <- unname(as.character(r$glycan_structure))
        good <- !is.na(z) & !duplicated(z) & !duplicated(z, fromLast = TRUE)
        internal <- sub('\\(\\?1-$', '', z)
        good <- good & !grepl('?', internal, fixed = TRUE)
        if ('annotation_consistency' %in% names(r)) {
          good <- good &
            !grepl('conflict', r$annotation_consistency, ignore.case = TRUE)
        }
        key[good] <- paste0(acc, '::structure::', z[good])
      }
      stopifnot(!anyDuplicated(key))
      key
    })
    ck <- lapply(seq_along(xs), function(i) {
      m <- ms[[i]]
      x <- xs[[i]]
      cols <- unlist(m$source$column_indices)
      if (acc == 'GPST000374' && length(cols) == ncol(x)) {
        paste(m$source$md5, m$source$sheet, cols, sep = '::')
      } else {
        paste(ns[i], colnames(x), sep = '::')
      }
    })
    rows <- unique(unlist(fk))
    cols <- unique(unlist(ck))
    dn <- list(
      make.unique(paste0('feature_', seq_along(rows))),
      make.unique(paste0('sample_', seq_along(cols)))
    )
    raw <- val <- matrix(NA_real_, length(rows), length(cols), dimnames = dn)
    coverage <- zero <- conflict <- matrix(
      FALSE,
      length(rows),
      length(cols),
      dimnames = dn
    )
    rcon <- vector('list', length(rows))
    ccon <- vector('list', length(cols))
    maps <- list()
    for (i in seq_along(xs)) {
      x <- xs[[i]]
      r <- match(fk[[i]], rows)
      c <- match(ck[[i]], cols)
      m <- ms[[i]]
      stopifnot(!any(coverage[r, c, drop = FALSE]))
      raw[r, c] <- m$raw_abundance
      val[r, c] <- SummarizedExperiment::assay(x)
      coverage[r, c] <- TRUE
      if (!is.null(m$processing_masks$zero_to_na)) {
        zero[r, c] <- m$processing_masks$zero_to_na
      } else {
        zero[r, c] <- !is.na(m$raw_abundance) & m$raw_abundance == 0
      }
      if (!is.null(m$processing_masks$conflict)) {
        conflict[r, c] <- m$processing_masks$conflict
      } else {
        conflict[r, c] <- !is.na(m$raw_abundance) &
          is.na(SummarizedExperiment::assay(x)) &
          m$raw_abundance != 0
      }
      maps[[ns[i]]] <- list(
        rows = r,
        columns = c,
        original_dimnames = dimnames(x)
      )
      for (j in seq_along(r)) {
        rcon[[r[j]]] <- c(rcon[[r[j]]], list(list(panel = ns[i], index = j)))
      }
      for (j in seq_along(c)) {
        ccon[[c[j]]] <- c(ccon[[c[j]]], list(list(panel = ns[i], index = j)))
      }
      stopifnot(
        isTRUE(all.equal(
          unname(val[r, c, drop = FALSE]),
          unname(SummarizedExperiment::assay(x))
        )),
        isTRUE(all.equal(
          unname(raw[r, c, drop = FALSE]),
          unname(m$raw_abundance)
        ))
      )
    }
    rd <- S4Vectors::DataFrame(feature_key = rows, row.names = dn[[1]])
    choose_annotation <- function(con, field) {
      v <- vapply(
        con,
        function(z) {
          annotation <- SummarizedExperiment::rowData(objects[[z$panel]])[[
            field
          ]]
          if (is.null(annotation)) {
            return(NA_character_)
          }
          unname(as.character(annotation[z$index]))
        },
        ''
      )
      v <- unique(v[!is.na(v)])
      if (length(v) == 1L) v else NA_character_
    }
    rd$glycan_composition <- do.call(
      'c',
      lapply(rcon, function(con) {
        z <- choose_annotation(con, 'glycan_composition')
        if (is.na(z)) {
          return(glyrepr::glycan_composition(NA))
        }
        for (a in con) {
          v <- SummarizedExperiment::rowData(objects[[
            a$panel
          ]])$glycan_composition[a$index]
          if (!is.na(v)) return(v)
        }
        glyrepr::glycan_composition(NA)
      })
    )
    structures <- vapply(
      rcon,
      choose_annotation,
      '',
      field = 'glycan_structure'
    )
    if (any(!is.na(structures))) {
      rd$glycan_structure <- glyrepr::as_glycan_structure(structures)
    }
    rd$source_features <- I(rcon)
    rd$source_glycan_subtypes <- vapply(
      rcon,
      function(con) {
        paste(
          unique(vapply(
            con,
            function(z) {
              m <- S4Vectors::metadata(objects[[z$panel]])
              if (is.null(m$source_glycan_type)) {
                m$glycan_type
              } else {
                m$source_glycan_type
              }
            },
            ''
          )),
          collapse = ';'
        )
      },
      ''
    )
    cd <- S4Vectors::DataFrame(
      source_observation_key = cols,
      row.names = dn[[2]]
    )
    fields <- unique(unlist(lapply(xs, function(x) {
      names(SummarizedExperiment::colData(x))
    })))
    for (field in fields) {
      source_columns <- lapply(xs, function(x) {
        SummarizedExperiment::colData(x)[[field]]
      })
      present <- Filter(Negate(is.null), source_columns)
      informative <- Filter(function(v) any(!is.na(v)), present)
      if (!length(informative)) {
        informative <- present
      }
      types <- unique(vapply(
        informative,
        function(v) {
          if (is.object(v)) "character" else typeof(v)
        },
        ""
      ))
      common_type <- if (
        length(types) && all(types %in% c("integer", "double"))
      ) {
        if ("double" %in% types) "double" else "integer"
      } else if (identical(types, "logical")) {
        "logical"
      } else {
        # Preserve genuine mixed metadata as source text, including literal NA labels.
        "character"
      }
      missing_value <- switch(
        common_type,
        double = NA_real_,
        integer = NA_integer_,
        logical = NA,
        character = NA_character_
      )
      convert <- switch(
        common_type,
        double = as.numeric,
        integer = as.integer,
        logical = as.logical,
        character = as.character
      )
      cd[[field]] <- vapply(
        ccon,
        function(con) {
          values <- unlist(
            lapply(con, function(z) {
              column <- SummarizedExperiment::colData(objects[[z$panel]])[[
                field
              ]]
              if (is.null(column)) {
                return(NULL)
              }
              convert(column[z$index])
            }),
            use.names = FALSE
          )
          values <- unique(values[!is.na(values)])
          if (length(values) == 1L) values else missing_value
        },
        missing_value
      )
    }
    cd$assay_unit <- rep(units, length(cols))
    cd$source_panels <- vapply(
      ccon,
      function(con) {
        paste(unique(vapply(con, `[[`, '', 'panel')), collapse = ';')
      },
      ''
    )
    idx <- expand.grid(
      feature_index = seq_along(rows),
      observation_index = seq_along(cols)
    )
    idx$original_value <- as.vector(raw)
    idx$curated_value <- as.vector(val)
    idx$reason <- ifelse(
      !as.vector(coverage),
      'not_measured_in_source_panel',
      ifelse(
        as.vector(conflict),
        'source_conflict',
        ifelse(
          as.vector(zero),
          'zero_abundance',
          ifelse(
            is.na(idx$original_value),
            'source_missing_or_nonnumeric',
            'unchanged'
          )
        )
      )
    )
    outmd <- list(
      accession = acc,
      dataset_name = name,
      glycan_type = type,
      unit = units,
      raw_abundance = raw,
      source_coverage = coverage,
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
      panels = ms,
      panel_maps = maps,
      panel_row_data = lapply(xs, SummarizedExperiment::rowData),
      panel_col_data = lapply(xs, SummarizedExperiment::colData),
      merge_method = 'Union of evidence-supported feature identities and source observations. Unmeasured panel combinations are explicitly masked; original panel data and annotations are retained.',
      zero_to_na = TRUE
    )
    names(outmd$panels) <- ns
    object <- glyexp::GlycomicSE(
      val,
      rowData = rd,
      colData = cd,
      metadata = outmd
    )
    stopifnot(isTRUE(methods::validObject(object)))
    assign(name, object)
    save(
      list = name,
      file = file.path('data-raw/_shared/bundled-build', paste0(name, '.rda')),
      compress = 'xz',
      version = 3
    )
    d <- ds[[1]]
    d$name <- name
    d$title <- paste0(ds[[1]]$title, ' and related study experiments')
    d$features <- nrow(object)
    d$observations <- ncol(object)
    d$description <- paste0(
      ds[[1]]$description,
      ' Combined ',
      type,
      '-glycan quantitative profiles from ',
      acc,
      '. ',
      nrow(object),
      ' union features and ',
      ncol(object),
      ' source observations are represented.'
    )
    d$details <- paste0(
      'Source experiments are identified in colData and original panel-specific metadata, annotations and measurements are retained in metadata. Feature identities are aligned only when supported by author identifiers or explicit molecular structures; other features retain source-specific identities. The source_coverage matrix distinguishes unmeasured combinations from measured missing values. Units: ',
      units,
      '.\n\n',
      paste(
        vapply(ds, function(z) paste(z$title, z$details, sep = ': '), ''),
        collapse = '\n\n'
      )
    )
    final[[length(final) + 1L]] <- d
    mapping[[length(mapping) + 1L]] <- data.frame(
      old_name = ns,
      new_name = name,
      features = vapply(xs, nrow, integer(1)),
      observations = vapply(xs, ncol, integer(1))
    )
    audit[[name]] <- list(
      panels = length(xs),
      source_cells = sum(vapply(xs, function(x) nrow(x) * ncol(x), integer(1))),
      covered_cells = sum(coverage),
      features = nrow(object),
      observations = ncol(object),
      not_measured = sum(!coverage),
      conservation = 'all panel assay and raw values exactly recovered via panel_maps'
    )
  }
  jsonlite::write_json(
    final,
    'data-raw/_shared/dataset-descriptions.json',
    auto_unbox = TRUE,
    pretty = TRUE,
    null = 'null'
  )
  utils::write.csv(
    do.call(rbind, mapping),
    'data-raw/_shared/panel-name-mapping.csv',
    row.names = FALSE
  )
  jsonlite::write_json(
    audit,
    'data-raw/_shared/merge-validation.json',
    auto_unbox = TRUE,
    pretty = TRUE
  )
  keep <- vapply(final, `[[`, '', 'name')
  obsolete <- setdiff(names(objects), keep)
  cache <- Sys.getenv(
    'GLYHUB_PANEL_CACHE',
    file.path(tempdir(), 'glyhub-panel-cache')
  )
  dir.create(cache, recursive = TRUE, showWarnings = FALSE)
  for (n in obsolete) {
    f <- file.path('data-raw/_shared/bundled-build', paste0(n, '.rda'))
    stopifnot(file.copy(f, file.path(cache, basename(f)), overwrite = TRUE))
    unlink(f)
  }
  panel_inventory <- utils::read.csv('data-raw/_shared/object-inventory.csv')
  panel_inventory <- panel_inventory[
    panel_inventory$dataset %in% names(objects),
    ,
    drop = FALSE
  ]
  utils::write.csv(
    panel_inventory,
    'data-raw/_shared/panel-inventory.csv',
    row.names = FALSE
  )
  inventory <- lapply(keep, function(n) {
    e <- new.env()
    load(file.path('data-raw/_shared/bundled-build', paste0(n, '.rda')), e)
    x <- e[[n]]
    m <- S4Vectors::metadata(x)
    r <- SummarizedExperiment::rowData(x)
    old <- do.call(rbind, mapping)
    old <- old$old_name[old$new_name == n]
    data.frame(
      dataset = n,
      accession = m$accession,
      features = nrow(x),
      observations = ncol(x),
      missing = sum(is.na(SummarizedExperiment::assay(x))),
      zero_to_na = sum(m$processing_masks$zero_to_na),
      conflict_to_na = sum(m$processing_masks$conflict),
      typed_compositions = sum(!is.na(r$glycan_composition)),
      typed_structures = sum(!is.na(r$glycan_structure)),
      compressed_bytes = file.info(file.path(
        'data-raw/_shared/bundled-build',
        paste0(n, '.rda')
      ))$size,
      build_seconds = if (m$accession %in% c('GPST000643', 'GPST000738')) {
        NA_real_
      } else if (any(panel_inventory$dataset %in% old)) {
        sum(panel_inventory$build_seconds[panel_inventory$dataset %in% old])
      } else {
        NA_real_
      }
    )
  })
  utils::write.csv(
    do.call(rbind, inventory),
    'data-raw/_shared/object-inventory.csv',
    row.names = FALSE
  )
  invisible(final)
}
merge_study_panels()
