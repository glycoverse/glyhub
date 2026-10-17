# Run from package root. Curate complete, explicitly labelled quantitative tables.
root <- "data-raw/GPST000643"
manifest <- read.csv(
  file.path(root, "GPST000643-source-manifest.csv"),
  stringsAsFactors = FALSE
)
stopifnot(all(
  unname(tools::md5sum(file.path(root, manifest$file))) == manifest$md5
))
read_sheet <- function(file, sheet) {
  as.matrix(readxl::read_excel(
    file.path(root, file),
    sheet = sheet,
    col_names = FALSE,
    col_types = "text",
    .name_repair = "minimal"
  ))
}
num <- function(x) suppressWarnings(as.numeric(x))
fill <- function(x) {
  for (i in seq_along(x)) {
    if (i > 1 && is.na(x[i])) x[i] <- x[i - 1]
  }
  x
}
comp_string <- function(x) {
  if (is.na(x)) {
    return(NA_character_)
  }
  names <- c(
    HexNAc = "HexNAc",
    Hex = "Hex",
    deHex = "dHex",
    NeuAc = "Neu5Ac",
    NeuGc = "Neu5Gc",
    Sul = "S"
  )
  pattern <- "(HexNAc|deHex|NeuAc|NeuGc|Hex|Sul)[0-9]+"
  tokens <- regmatches(x, gregexpr(pattern, x, perl = TRUE))[[1]]
  if (!length(tokens) || gsub(pattern, "", x, perl = TRUE) != "") {
    return(NA_character_)
  }
  paste0(
    vapply(
      tokens,
      function(z) {
        key <- sub("[0-9]+$", "", z)
        paste0(names[[key]], "(", sub("^[A-Za-z]+", "", z), ")")
      },
      character(1)
    ),
    collapse = ""
  )
}
structure_string <- function(x) {
  if (is.na(x) || grepl("Not assigned|not assigned|\\+|/", x)) {
    return(NA_character_)
  }
  x <- gsub("[[:space:]]", "", x)
  x <- gsub("NeuAc", "Neu5Ac", x, fixed = TRUE)
  x <- gsub("NeuGc", "Neu5Gc", x, fixed = TRUE)
  # Localized sulfate prefixes, including (6S), have unambiguous local meaning.
  x <- gsub(
    "\\(?([0-9]+)S\\)?(GlcNAc|GalNAc|Gal|Glc|Man|Fuc)",
    "\\2\\1S",
    x,
    perl = TRUE
  )
  x <- chartr("()", "[]", x)
  x <- gsub("β", "b", x, fixed = TRUE)
  x <- gsub("α", "a", x, fixed = TRUE)
  x <- gsub("([ab][12]-[0-9]+)", "(\\1)", x, perl = TRUE)
  for (m in c("GlcNAc", "GalNAc", "HexNAc", "Gal", "Glc", "Man", "Fuc")) {
    old <- if (grepl("NAc$", m)) {
      paste0(sub("c$", "", m), "col")
    } else {
      paste0(m, "ol")
    }
    x <- gsub(old, paste0(m, "-ol"), x, fixed = TRUE)
  }
  tryCatch(as.character(glyrepr::as_glycan_structure(x)), error = function(e) {
    NA_character_
  })
}
# Table, header row, condition row, replicate row, RT-column sequence,
# mass column, composition column, structure column, optional row restriction.
specs <- list(
  list(
    id = "S5",
    file = 6,
    sheet = "Table S5",
    h = 6,
    g = 4,
    r = 5,
    cols = seq(8, 71, 3),
    mass = 1,
    comp = 2,
    structure = 3,
    type = "O",
    material = "porcine colonic mucin oligosaccharides",
    species = "Sus scrofa"
  ),
  list(
    id = "S7",
    file = 8,
    sheet = "Table S7",
    h = 5,
    g = 3,
    r = 4,
    cols = seq(6, 21, 3),
    mass = 2,
    comp = 3,
    structure = 4,
    type = "O",
    material = "porcine gastric mucin",
    species = "Sus scrofa"
  ),
  list(
    id = "S9B",
    file = 10,
    sheet = "Table S9B",
    h = 4,
    g = 3,
    r = NA,
    cols = seq(9, 27, 3),
    mass = 2,
    comp = 3,
    structure = 4,
    type = "O",
    material = "bovine submaxillary mucin",
    species = "Bos taurus"
  ),
  list(
    id = "S10B_O",
    file = 11,
    sheet = "Table S10B",
    h = 8,
    g = 7,
    r = NA,
    cols = seq(6, 27, 3),
    mass = 2,
    comp = 3,
    structure = 4,
    type = "O",
    rows = 9:17,
    material = "PSGL-1 expressing core 4; pretreated with BT0455 + BT1626 + BT4241",
    species = NA_character_
  ),
  list(
    id = "S10B_N",
    file = 11,
    sheet = "Table S10B",
    h = 24,
    g = 7,
    r = NA,
    cols = seq(6, 27, 3),
    mass = 2,
    comp = 3,
    structure = 4,
    type = "N",
    rows = 25:27,
    material = "PSGL-1 expressing core 4; pretreated with BT0455 + BT1626 + BT4241",
    species = NA_character_
  ),
  list(
    id = "S10C_O",
    observation_id = "S10C",
    rows = 8:10,
    file = 11,
    sheet = "Table S10C",
    h = 7,
    g = 5,
    r = 6,
    cols = seq(6, 48, 3),
    mass = 2,
    comp = 3,
    structure = 4,
    type = "O",
    material = "PSGL-1 expressing core 4; pretreated with enzyme mix",
    species = NA_character_
  ),
  list(
    id = "S10C_N",
    observation_id = "S10C",
    rows = 11:12,
    file = 11,
    sheet = "Table S10C",
    h = 7,
    g = 5,
    r = 6,
    cols = seq(6, 48, 3),
    mass = 2,
    comp = 3,
    structure = 4,
    type = "N",
    material = "PSGL-1 expressing core 4; pretreated with enzyme mix",
    species = NA_character_
  ),
  list(
    id = "S11B",
    file = 12,
    sheet = "Table 11B",
    h = 5,
    g = 3,
    r = 4,
    cols = seq(5, 29, 3),
    mass = 2,
    comp = 3,
    structure = 4,
    type = "O",
    material = "porcine colonic mucin oligosaccharides",
    species = "Sus scrofa"
  ),
  list(
    id = "S12",
    file = 13,
    sheet = "Table 12",
    h = 5,
    g = 4,
    r = NA,
    cols = seq(6, 15, 3),
    mass = 2,
    comp = 3,
    structure = 4,
    type = "O",
    material = "gastric mucin oligosaccharides; B. theta culture supernatant",
    species = "Sus scrofa"
  )
)
# Class assignments are tied to the explicitly labelled sections of S10B.
s10b <- read_sheet("GPST000643-media-11.xlsx", "Table S10B")
s10c <- read_sheet("GPST000643-media-11.xlsx", "Table S10C")
stopifnot(
  s10b[5, 1] == "O-glycans",
  s10b[21, 1] == "N-glycans",
  identical(unname(s10c[8:10, 2:4]), unname(s10b[c(10, 14, 15), 2:4])),
  identical(unname(s10c[11:12, 2:4]), unname(s10b[25:26, 2:4]))
)
ledger <- list()
inventory <- list()
for (s in specs) {
  f <- paste0("GPST000643-media-", s$file, ".xlsx")
  x <- read_sheet(f, s$sheet)
  rows <- if (!is.null(s$rows)) {
    s$rows
  } else {
    which(grepl("^[0-9]", x[, s$mass]) & grepl("^(Hex|Neu|deHex)", x[, s$comp]))
  }
  stopifnot(length(rows) > 0, all(rows > s$h))
  # Explicit source triplets are RT, AUC, percentage; no inference from a typo alone.
  stopifnot(
    all(grepl("^RT", x[s$h, s$cols])),
    all(grepl("^Int|^Ins", x[s$h, s$cols + 1])),
    all(grepl("^Per|^Perc", x[s$h, s$cols + 2]))
  )
  raw_text <- x[rows, s$cols + 2, drop = FALSE]
  rt <- x[rows, s$cols, drop = FALSE]
  auc_text <- x[rows, s$cols + 1, drop = FALSE]
  ids <- paste0("source_row_", rows)
  observation_id <- if (is.null(s$observation_id)) s$id else s$observation_id
  obs <- paste0(observation_id, "_column_", s$cols + 2)
  dimnames(raw_text) <- dimnames(rt) <- dimnames(auc_text) <- list(ids, obs)
  raw <- matrix(num(raw_text), nrow(raw_text), dimnames = dimnames(raw_text))
  a <- raw
  zero <- !is.na(raw) & raw == 0
  missing <- is.na(raw_text)
  nd <- !is.na(rt) & tolower(rt) %in% c("nd", "n.d", "n.d.")
  dim(nd) <- dim(raw)
  dimnames(nd) <- dimnames(raw)
  invalid <- !missing & is.na(raw)
  a[zero | missing | invalid] <- NA_real_
  reason <- matrix(
    "retained_source_value",
    nrow(a),
    ncol(a),
    dimnames = dimnames(a)
  )
  reason[missing] <- "source_missing"
  reason[invalid] <- "source_nonnumeric"
  reason[zero] <- "zero_to_na"
  rd <- S4Vectors::DataFrame(
    source_mass_label = x[rows, s$mass],
    source_composition = x[rows, s$comp],
    source_putative_structure = x[rows, s$structure],
    source_row = rows,
    row.names = ids
  )
  cs <- vapply(rd$source_composition, comp_string, character(1))
  rd$glycan_composition <- glyrepr::as_glycan_composition(cs)
  st <- vapply(rd$source_putative_structure, structure_string, character(1))
  if (any(!is.na(st))) {
    rd$glycan_structure <- glyrepr::as_glycan_structure(st)
  }
  rd$structure_status <- ifelse(
    is.na(st),
    "original text retained; unassigned, ambiguous or not safely converted",
    "source putative structure; notation translated without added linkage information"
  )
  rd$annotation_consistency <- vapply(
    seq_along(cs),
    function(i) {
      if (is.na(cs[i])) {
        return("source composition not safely parsed; original retained")
      }
      if (is.na(st[i])) {
        return("structure not converted; original evidence retained")
      }
      parsed <- unclass(glyrepr::as_glycan_composition(rd$glycan_structure[
        i
      ]))$data[[1]]
      mapping <- c(
        Gal = "Hex",
        Glc = "Hex",
        Man = "Hex",
        GlcNAc = "HexNAc",
        GalNAc = "HexNAc",
        Fuc = "dHex"
      )
      labels <- names(parsed)
      labels[labels %in% names(mapping)] <- mapping[labels[
        labels %in% names(mapping)
      ]]
      parsed <- tapply(parsed, labels, sum)
      declared <- unclass(rd$glycan_composition[i])$data[[1]]
      same <- identical(sort(names(parsed)), sort(names(declared))) &&
        isTRUE(all.equal(
          as.numeric(parsed[sort(names(parsed))]),
          as.numeric(declared[sort(names(declared))])
        ))
      if (same) {
        "composition counts agree"
      } else {
        "source composition/structure count conflict; neither silently corrected"
      }
    },
    character(1)
  )
  # Keep all categorical source annotations, including literal zero flags.
  anncols <- setdiff(seq_len(min(s$cols) - 1), c(s$mass, s$comp, s$structure))
  rd$source_annotations <- S4Vectors::List(lapply(rows, function(i) {
    setNames(x[i, anncols], paste0("column_", anncols))
  }))
  groups <- fill(x[s$g, ])
  cd <- S4Vectors::DataFrame(
    source_condition = groups[s$cols],
    source_replicate = if (is.na(s$r)) {
      rep(NA_character_, length(s$cols))
    } else {
      x[s$r, s$cols]
    },
    source_percentage_column = s$cols + 2,
    source_auc_column = s$cols + 1,
    source_rt_column = s$cols,
    material = s$material,
    species = s$species,
    replicate_type = NA_character_,
    biological_sample_id = NA_character_,
    row.names = obs
  )
  idx <- expand.grid(feature = ids, observation = obs, stringsAsFactors = FALSE)
  idx$source_file <- f
  idx$source_sheet <- s$sheet
  idx$source_row <- rep(rows, ncol(a))
  idx$source_column <- rep(s$cols + 2, each = nrow(a))
  idx$raw_text <- as.vector(raw_text)
  idx$raw_numeric <- as.vector(raw)
  idx$raw_auc <- as.vector(auc_text)
  idx$raw_rt <- as.vector(rt)
  idx$source_missing <- as.vector(missing)
  idx$source_rt_not_detected <- as.vector(nd)
  idx$zero_to_na <- as.vector(zero)
  idx$reason <- as.vector(reason)
  idx$curated_value <- as.vector(a)
  idx$dataset <- observation_id
  ledger[[s$id]] <- idx
  md <- list(
    glycan_type = s$type,
    accession = "GPST000643",
    revision = 0,
    doi = "10.64898/2026.03.26.714468",
    pmcid = "PMC13042051",
    source = list(
      file = f,
      sheet = s$sheet,
      md5 = unname(tools::md5sum(file.path(root, f))),
      url = paste0(
        "https://pmc.ncbi.nlm.nih.gov/articles/instance/13042051/bin/media-",
        s$file,
        ".xlsx"
      ),
      retrieval = "Official Europe PMC supplementaryFiles ZIP; complete entries checked against ZIP CRC32"
    ),
    title = x[1, 1],
    source_table = x,
    raw_abundance = raw,
    raw_text = raw_text,
    raw_auc = auc_text,
    raw_retention_time = rt,
    source_annotation_headers = x[s$h, seq_len(min(s$cols) - 1)],
    processing_ledger = idx,
    processing_masks = list(
      source_missing = missing,
      source_rt_not_detected = nd,
      source_nonnumeric = invalid,
      zero_to_na = zero
    ),
    processing_counts = c(
      source_missing = sum(missing),
      source_rt_not_detected = sum(nd),
      source_nonnumeric = sum(invalid),
      zero_to_na = sum(zero)
    ),
    zero_to_na = TRUE,
    zero_to_na_policy = "Zero-valued abundances are represented as NA in the distributed assay. Original measurements and zero-valued metadata are preserved; no imputation or renormalization is applied.",
    unit = "source-reported percentage of total glycan AUC",
    normalization = "Use source percentages unchanged except zero-to-NA; no renormalization after filtering or N/O separation. AUC retained separately in metadata, not mixed into percentage assay.",
    observation_identity = "Each explicit source percentage column is one observation; source replicate labels do not establish biological replication or cross-table pairing. No repository raw-file map inferred.",
    license = list(
      name = "Creative Commons Attribution-NoDerivatives 4.0 International",
      url = "https://creativecommons.org/licenses/by-nd/4.0/",
      source_statement = "This work is licensed under a Creative Commons Attribution-NoDerivatives 4.0 International License",
      scope = "Original source license retained; original XLSX bytes unchanged. Abundance zeros are represented as NA; original measurements and source attribution are preserved. The source license is unchanged."
    ),
    citation = "Degradation of mucin O-glycans by a human gut symbiont requires a complex enzyme repertoire and promotes colonization. DOI: 10.64898/2026.03.26.714468.",
    software = list(
      glyexp = as.character(packageVersion("glyexp")),
      glyrepr = as.character(packageVersion("glyrepr"))
    )
  )
  object <- glyexp::GlycomicSE(a, rowData = rd, colData = cd, metadata = md)
  stopifnot(isTRUE(methods::validObject(object)), !any(a == 0, na.rm = TRUE))
  name <- paste0("glyhub_GPST000643_", s$type, "_", sub("_[ON]$", "", s$id))
  assign(name, object)
  save(
    list = name,
    file = file.path(
      "data-raw/_shared/artifacts/bundled-build",
      paste0(name, ".rda")
    ),
    compress = "xz",
    version = 3
  )
  inventory[[name]] <- data.frame(
    dataset = name,
    features = nrow(a),
    observations = ncol(a),
    na = sum(is.na(a)),
    typed_structures = sum(!is.na(st)),
    source_sheet = s$sheet
  )
  message(name, ": ", nrow(a), " x ", ncol(a), "; structures ", sum(!is.na(st)))
}
write.csv(
  do.call(rbind, ledger),
  file.path(root, "GPST000643-processing-ledger.csv"),
  row.names = FALSE,
  na = "NA"
)
write.csv(
  do.call(rbind, inventory),
  file.path(root, "GPST000643-inventory.csv"),
  row.names = FALSE
)
