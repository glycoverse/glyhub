# Run from the glyhub package root. Input files are checksum-pinned.
# Curated assay only: original zero values are preserved in metadata, not assays.
root <- "data-raw/GPST000738"
file <- file.path(root, "GPST000738__Supplementary_Table_IMER_20260707.xlsx")
stopifnot(unname(tools::md5sum(file)) == "f83b7c3e4e5d33a367ce2a23999a7757")
sheets <- setNames(
  lapply(as.character(1:8), function(s) {
    as.matrix(readxl::read_excel(
      file,
      sheet = s,
      col_names = FALSE,
      col_types = "text",
      .name_repair = "minimal"
    ))
  }),
  as.character(1:8)
)
cell <- function(r, c) paste0("R", r, "C", c)
number <- function(x) suppressWarnings(as.numeric(x))
# Explicit composition correspondences from sheets 5-8 and Figure S3.
compositions <- list(
  B4GalT1 = c(
    "H3N4",
    "H4N4",
    "H5N4",
    "H3N5",
    "H4N5",
    "H4N5",
    "H5N5",
    "H5N5",
    "H6N5"
  ),
  ST6GAL1 = c(
    "H6N5",
    "H6N5S1",
    "H6N5S2",
    "H6N5S3",
    "H5N5",
    "H5N5S1",
    "H5N5S2",
    "H5N4",
    "H5N4S1",
    "H5N4S2"
  )
)
# Manual transcription ONLY of fully localized Figure S3 structures.
# The reducing-end anomer is unspecified. Bracketed ambiguous antennae in S3
# are not resolved by guessing a topology or assigning an a/b source isomer.
tail <- "Man(b1-4)GlcNAc(b1-4)GlcNAc(?1-"
bi <- function(arm) {
  paste0(arm, "GlcNAc(b1-2)Man(a1-3)[", arm, "GlcNAc(b1-2)Man(a1-6)]", tail)
}
tri <- function(arm) {
  paste0(
    arm,
    "GlcNAc(b1-2)[",
    arm,
    "GlcNAc(b1-4)]Man(a1-3)[",
    arm,
    "GlcNAc(b1-2)Man(a1-6)]",
    tail
  )
}
structure_map <- c(
  H3N4 = bi(""),
  H5N4 = bi("Gal(b1-4)"),
  H3N5 = tri(""),
  H6N5 = tri("Gal(b1-4)"),
  H5N4S2 = bi("Neu5Ac(a2-6)Gal(b1-4)"),
  H6N5S3 = tri("Neu5Ac(a2-6)Gal(b1-4)")
)
ledger_all <- list()
for (enzyme in names(compositions)) {
  ids <- if (enzyme == "B4GalT1") c("1", "2") else c("3", "4")
  control_n <- if (enzyme == "B4GalT1") 4L else 7L
  nf <- nrow(sheets[[ids[1]]]) - 1L
  stopifnot(identical(
    sheets[[ids[1]]][1:(nf + 1), 2:(control_n + 1)],
    sheets[[ids[2]]][1:(nf + 1), 2:(control_n + 1)]
  ))
  # The exact repeated control table is represented once, with both locations.
  # No biological identity, pairing or independent replicate type is assigned.
  observations <- list()
  for (k in seq_along(ids)) {
    s <- ids[k]
    x <- sheets[[s]]
    label <- NA_character_
    ordinal <- 0L
    for (j in 2:ncol(x)) {
      if (!is.na(x[1, j])) {
        label <- x[1, j]
        ordinal <- 0L
      }
      ordinal <- ordinal + 1L
      is_control <- j <= control_n + 1L
      if (k == 2L && is_control) {
        next
      }
      observations[[length(observations) + 1L]] <- data.frame(
        source_sheet = s,
        source_column = j,
        source_group = label,
        source_observation_ordinal = ordinal,
        time_hours = if (is_control) {
          NA_real_
        } else {
          as.numeric(sub(".*\\(([0-9]+).*", "\\1", label))
        },
        reactor_flow_uL_min = if (is_control) NA_real_ else c(25, 75)[k],
        condition = if (is_control) "substrate_control" else "enzyme_reactor",
        enzyme = enzyme,
        replicate_type = NA_character_,
        biological_sample_id = NA_character_,
        control_table_repeated = is_control,
        secondary_source_sheet = if (is_control) ids[2] else NA_character_
      )
    }
  }
  cd <- do.call(rbind, observations)
  rownames(cd) <- paste0(enzyme, "_", seq_len(nrow(cd)))
  raw_text <- vapply(
    seq_len(nrow(cd)),
    function(j) sheets[[cd$source_sheet[j]]][-1, cd$source_column[j]],
    character(nf)
  )
  dimnames(raw_text) <- list(sheets[[ids[1]]][-1, 1], rownames(cd))
  raw <- matrix(number(raw_text), nf, dimnames = dimnames(raw_text))
  curated <- raw
  nd <- !is.na(raw_text) & grepl("^n[.]d[.]?$", raw_text, ignore.case = TRUE)
  original_na <- is.na(raw_text)
  zero <- !is.na(raw) & raw == 0
  conflict <- matrix(FALSE, nf, ncol(raw), dimnames = dimnames(raw))
  reason <- matrix(
    "retained_source_value",
    nf,
    ncol(raw),
    dimnames = dimnames(raw)
  )
  reason[nd] <- "source_not_detected"
  reason[original_na] <- "source_missing"
  reason[zero] <- "zero_to_na"
  alt <- matrix(NA_character_, nf, ncol(raw), dimnames = dimnames(raw))
  alt_value <- alt
  comparison <- matrix("not_compared", nf, ncol(raw), dimnames = dimnames(raw))
  for (j in seq_len(ncol(raw))) {
    ps <- as.character(as.integer(cd$source_sheet[j]) + 4L)
    p <- sheets[[ps]]
    ctrl <- cd$condition[j] == "substrate_control"
    ord <- cd$source_observation_ordinal[j]
    if (enzyme == "B4GalT1") {
      rA <- if (ctrl) 5L else which(p[, 1] == cd$source_group[j])[1]
      br <- if (ps == "5") 23:26 else 25:29
      rB <- br[match(cd$source_group[j], p[br, 1])]
      for (i in seq_len(nf)) {
        cc <- if (i <= 3) {
          c(2, 6, 10)[i] + ord - 1L
        } else {
          c(2, 5, 5, 8, 8, 11)[i - 3] + ord - 1L
        }
        rr <- if (i <= 3) rA else rB
        if (ctrl && i > 3 && ord >= 3) {
          conflict[i, j] <- TRUE
          reason[i, j] <- "conflict_control_correspondence_unresolved"
          comparison[
            i,
            j
          ] <- "four_raw_vs_three_processed_controls; no remapping"
          next
        }
        alt[i, j] <- paste0("sheet ", ps, " ", cell(rr, cc))
        alt_value[i, j] <- p[rr, cc]
        val <- number(p[rr, cc])
        group <- if (i %in% c(5, 6)) {
          5:6
        } else if (i %in% c(7, 8)) {
          7:8
        } else {
          i
        }
        reference <- sum(raw[group, j])
        agrees <- !is.na(val) && abs(val - reference) < 1e-6
        comparison[i, j] <- if (agrees) {
          "agrees_at_composition_level"
        } else {
          "value_or_presence_conflict"
        }
        if (!agrees) {
          conflict[i, j] <- TRUE
          reason[i, j] <- "conflict_processed_value_or_presence"
        }
      }
      if (!ctrl && cd$reactor_flow_uL_min[j] == 25) {
        # Both duplicated A2/A2G1 values are suspect; do not choose the correct row.
        conflict[1:2, j] <- TRUE
        reason[1:2, j] <- "conflict_duplicated_A2_A2G1_nonclosing_family"
      }
    } else {
      rr <- if (ctrl) 5L else match(cd$time_hours[j], c(0, 2, 4, 8)) + 5L
      starts <- which(!is.na(p[3, ]) & grepl("^H", p[3, ]))
      labs <- sub("S0$", "", p[3, starts])
      for (i in seq_len(nf)) {
        cc <- starts[match(compositions[[enzyme]][i], labs)] + ord - 1L
        alt[i, j] <- paste0("sheet ", ps, " ", cell(rr, cc))
        alt_value[i, j] <- p[rr, cc]
        val <- number(p[rr, cc])
        if (nd[i, j] && !is.na(val) && val == 0) {
          comparison[i, j] <- "source_nd_processed_zero"
          next
        }
        if (is.na(val) || is.na(raw[i, j]) || abs(val - raw[i, j]) > 1e-7) {
          conflict[i, j] <- TRUE
          reason[i, j] <- "conflict_processed_value_or_presence"
          comparison[i, j] <- "value_or_presence_conflict"
        } else {
          comparison[i, j] <- "agrees"
        }
      }
    }
  }
  curated[zero | nd | original_na | conflict] <- NA_real_
  # Each original cell has a location and processing decision; masks can overlap.
  idx <- expand.grid(
    feature = rownames(raw),
    observation = colnames(raw),
    stringsAsFactors = FALSE
  )
  idx$source_sheet <- rep(cd$source_sheet, each = nf)
  idx$source_cell <- unlist(lapply(cd$source_column, function(j) {
    cell(2:(nf + 1), j)
  }))
  idx$raw_text <- as.vector(raw_text)
  idx$raw_numeric <- as.vector(raw)
  idx$processed_source <- as.vector(alt)
  idx$processed_raw_text <- as.vector(alt_value)
  idx$comparison <- as.vector(comparison)
  idx$reason <- as.vector(reason)
  idx$source_missing <- as.vector(original_na)
  idx$source_nd <- as.vector(nd)
  idx$zero_to_na <- as.vector(zero)
  idx$conflict_to_na <- as.vector(conflict)
  idx$curated_value <- as.vector(curated)
  idx$dataset <- enzyme
  ledger_all[[enzyme]] <- idx
  comp <- compositions[[enzyme]]
  rd <- S4Vectors::DataFrame(
    source_feature_label = rownames(raw),
    reported_composition = comp,
    glycan_composition = glyrepr::as_glycan_composition(comp),
    glycan_structure = glyrepr::as_glycan_structure(unname(structure_map[
      comp
    ])),
    normalization_family = if (enzyme == "B4GalT1") {
      c(rep("A2", 3), rep("A3", 6))
    } else {
      c(rep("H6N5", 4), rep("H5N5", 3), rep("H5N4", 3))
    },
    structure_evidence = "Supplementary Figure S3; only fully localized diagrams transcribed",
    structure_status = ifelse(
      is.na(structure_map[comp]),
      "source diagram ambiguous or isomer mapping unresolved; diagram retained",
      "localized Figure S3 topology; reducing-end anomer unspecified"
    ),
    row.names = rownames(raw)
  )
  m <- list(
    glycan_type = "N",
    accession = "GPST000738",
    revision = 0,
    doi = "10.3389/fmolb.2026.1932584",
    project_url = "https://glycopost.glycosmos.org/entry/GPST000738",
    source = list(
      file = basename(file),
      md5 = unname(tools::md5sum(file)),
      url = "https://glycopost.glycosmos.org/data/GPST000738.0/Supplementary_Table_IMER_20260707.xlsx"
    ),
    source_tables = sheets,
    raw_abundance = raw,
    raw_text = raw_text,
    processing_ledger = idx,
    processing_masks = list(
      source_missing = original_na,
      source_nd = nd,
      conflict = conflict,
      zero_to_na = zero
    ),
    processing_counts = c(
      source_missing = sum(original_na),
      source_nd = sum(nd),
      conflict = sum(conflict),
      zero_to_na = sum(zero)
    ),
    zero_to_na = TRUE,
    zero_to_na_policy = "Zero-valued abundances are represented as NA in the distributed assay. Original measurements and zero-valued metadata are preserved; no imputation or renormalization is applied.",
    unit = if (enzyme == "B4GalT1") {
      "percent within glycan family"
    } else {
      "fraction within glycan family"
    },
    normalization = "Author-reported within-family relative abundance; no cross-family renormalization or unit conversion",
    material = "foetal bovine serum fetuin",
    species = "Bos taurus",
    observation_identity = "Source table columns, not established biological individuals. Exact repeated control table represented once. No raw-file mapping or cross-condition pairing inferred.",
    incompleteness = "Full source feature space and raw-table observation columns retained, with repeated control table represented once. Conflicts set NA; not a reconstruction of the authors' final analytical matrix.",
    unmatched_processed_observations = if (enzyme == "ST6GAL1") {
      data.frame(
        source_sheet = c("7", "7", "7", "8", "8", "8"),
        source_cell = rep(c("R5C9", "R5C17", "R5C25"), 2),
        composition = rep(c("H5N4", "H5N4S1", "H5N4S2"), 2),
        raw_value = rep(c(0.969164, 0.029125, 0.001711), 2),
        reason = "Processed control rep 8 lacks raw-table identity; not paired or inserted as a new individual"
      )
    } else {
      NULL
    },
    license = list(
      repository_terms = "https://glycopost.glycosmos.org/terms",
      article = "CC BY",
      article_url = "https://doi.org/10.3389/fmolb.2026.1932584"
    ),
    structure_evidence = lapply(
      c("GPST000738_Figure_S3A.png", "GPST000738_Figure_S3B.png"),
      function(f) {
        list(
          file = f,
          bytes = readBin(
            file.path(root, f),
            "raw",
            n = file.info(file.path(root, f))$size
          )
        )
      }
    ),
    methods = jsonlite::fromJSON(
      file.path(root, "GPST000738-f_0000069167.json"),
      simplifyVector = FALSE
    ),
    software = list(
      glyexp = as.character(packageVersion("glyexp")),
      glyrepr = as.character(packageVersion("glyrepr"))
    )
  )
  x <- glyexp::GlycomicSE(
    curated,
    rowData = rd,
    colData = S4Vectors::DataFrame(cd),
    metadata = m
  )
  stopifnot(isTRUE(methods::validObject(x)), !any(curated == 0, na.rm = TRUE))
  name <- paste0("glyhub_GPST000738_N_", enzyme)
  assign(name, x)
  dir.create("data-raw/_shared/artifacts/bundled-build", showWarnings = FALSE)
  save(
    list = name,
    file = file.path(
      "data-raw/_shared/artifacts/bundled-build",
      paste0(name, ".rda")
    ),
    compress = "xz",
    version = 3
  )
  message(
    name,
    ": ",
    nrow(x),
    " x ",
    ncol(x),
    "; ",
    sum(is.na(curated)),
    " NA cells"
  )
}
utils::write.csv(
  do.call(rbind, ledger_all),
  file.path(root, "GPST000738-processing-ledger.csv"),
  row.names = FALSE,
  na = "NA"
)
