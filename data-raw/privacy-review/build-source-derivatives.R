# Create verified deidentified processed-source files; never publish original human sample metadata.
# args: directory of verified original author inputs (local reference only), cache directory.
args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) == 2L)
cache <- args[2]
source('data-raw/_shared/scripts/noncptac/register-source.R')
specs <- jsonlite::fromJSON(
  'data-raw/privacy-review/source-derivatives.json',
  simplifyVector = FALSE
)
validation <- list()
for (s0 in specs) {
  s <- jsonlite::fromJSON(jsonlite::toJSON(
    s0,
    auto_unbox = TRUE,
    null = 'null'
  ))
  id <- s$dataset
  candidates <- file.path(
    args[1],
    c(
      s$local_file,
      paste0(s$original_sha256, '-', id, '.', s$original_format),
      paste0(id, '.', s$original_format)
    )
  )
  path <- candidates[file.exists(candidates)][1]
  stopifnot(length(path) == 1L, !is.na(path))
  stopifnot(digest::digest(file = path, algo = 'sha256') == s$original_sha256)
  prefix <- sub('^glyhub_', '', id)
  a <- alternative <- NULL
  feature <- data.frame()
  cd <- NULL
  if (s$kind == 'stage') {
    d <- as.data.frame(readxl::read_excel(
      path,
      sheet = s$sheet,
      skip = s$rows[1] - 1L,
      n_max = s$rows[2] - s$rows[1] + 1L,
      col_names = FALSE,
      na = c('', 'NA'),
      .name_repair = 'minimal'
    ))
    a <- as.matrix(d[s$quant_columns])
    storage.mode(a) <- 'double'
    feature <- d[1:4]
    names(feature) <- c(
      'source_feature_annotation',
      'core_fucose',
      'PNGaseF_modified',
      'multiple_sites'
    )
    cd <- data.frame(condition = s$groups)
    if (isTRUE(s$paired)) {
      cd$anonymous_pair <- sprintf(
        '%s_pair_%03d',
        prefix,
        rep(seq_len(ncol(a) / 2), each = 2)
      )
    }
  } else if (s$kind == 'xmen') {
    d <- as.data.frame(readxl::read_excel(
      path,
      na = c('', 'NA'),
      .name_repair = 'minimal'
    ))[-1, , drop = FALSE]
    a <- matrix(as.numeric(as.matrix(d[1:6])), nrow = nrow(d))
    feature <- d[10:40]
    cd <- data.frame(condition = s$groups)
  } else if (s$kind == 'myeloma') {
    d <- as.data.frame(readxl::read_excel(
      path,
      sheet = s$sheet,
      na = c('', 'NA'),
      .name_repair = 'minimal'
    ))
    a <- as.matrix(d[s$quant_columns_1based])
    feature <- d[1:6]
    cd <- data.frame(condition = s$groups)
  } else if (s$kind == 'ovarian') {
    d <- read.delim(
      gzfile(path),
      check.names = FALSE,
      quote = '',
      na.strings = c('', 'NaN')
    )
    feature <- d[seq_len(s$annotation_columns)]
    a <- as.matrix(d[-seq_len(s$annotation_columns)])
    cd <- data.frame(
      sample_role = ifelse(
        grepl('CONTROL', colnames(a), fixed = TRUE),
        'quality_control',
        'tumor'
      )
    )
  } else if (s$kind == 'oxoscan') {
    d <- read.csv(path, check.names = FALSE)
    ids <- unique(d$File.Name)
    features <- unique(d$peak_num)
    ri <- match(d$peak_num, features)
    ci <- match(d$File.Name, ids)
    stopifnot(
      !anyDuplicated(paste(ri, ci)),
      nrow(d) == length(ids) * length(features)
    )
    a <- alternative <- matrix(NA_real_, length(features), length(ids))
    a[cbind(ri, ci)] <- d$Intensity
    alternative[cbind(ri, ci)] <- d$Intensity.Norm
    feature <- data.frame(
      source_signal_feature = features,
      merged_rt = d$merged_rt[match(features, d$peak_num)]
    )
    health <- grepl(
      'healthy|control',
      as.character(d$F.Severity),
      ignore.case = TRUE
    )
    cd <- data.frame(
      condition = ifelse(
        health[match(ids, d$File.Name)],
        'healthy_control',
        'COVID19'
      )
    )
    stopifnot(sum(cd$condition == 'healthy_control') == 15L)
  } else if (s$kind == 'hcc18o') {
    d <- read.delim(
      path,
      check.names = FALSE,
      quote = '',
      na.strings = c('', 'NA')
    )
    columns <- grep('^Intensity (Neg|Pos)_[PT]_', names(d))
    primary <- columns[!grepl('___', names(d)[columns], fixed = TRUE)]
    stopifnot(length(primary) == 36L)
    original_names <- sub('^Intensity ', '', names(d)[primary])
    a <- as.matrix(d[primary])
    alternate_cols <- setdiff(columns, primary)
    # Each multiplicity view has the same source experiments and is not another cohort.
    alternate <- list()
    for (mult in 1:3) {
      ix <- match(paste0('Intensity ', original_names, '___', mult), names(d))
      stopifnot(!anyNA(ix))
      alternate[[paste0('multiplicity_', mult)]] <- as.matrix(d[ix])
    }
    allowed <- c(
      'Proteins',
      'Positions within proteins',
      'Leading proteins',
      'Protein',
      'Protein names',
      'Gene names',
      'Fasta headers',
      'Amino acid',
      'Sequence window',
      'id',
      'Reverse',
      'Potential contaminant',
      'Localization prob',
      'Score',
      'PEP',
      'Score diff'
    )
    feature <- d[intersect(allowed, names(d))]
    hbv <- ifelse(
      grepl('^Neg_', original_names),
      'HBV_negative',
      'HBV_positive'
    )
    subject_key <- paste(hbv, sub('.*_', '', original_names))
    cd <- data.frame(
      condition = ifelse(grepl('_[T]_', original_names), 'tumor', 'adjacent'),
      HBV_group = hbv,
      anonymous_pair = sprintf(
        '%s_pair_%03d',
        prefix,
        match(subject_key, unique(subject_key))
      )
    )
  } else {
    stop('Unknown approved privacy source recipe')
  }
  cat(
    id,
    'derived dimensions',
    paste(dim(a), collapse = 'x'),
    'expected',
    s$features,
    s$measurements,
    '\n'
  )
  stopifnot(
    is.numeric(a),
    identical(dim(a), as.integer(c(s$features, s$measurements))),
    all(is.finite(a) | is.na(a))
  )
  sample_names <- sprintf('%s_sample_%03d', prefix, seq_len(ncol(a)))
  feature_names <- sprintf('%s_feature_%06d', prefix, seq_len(nrow(a)))
  dimnames(a) <- list(feature_names, sample_names)
  rownames(feature) <- feature_names
  rownames(cd) <- sample_names
  cd$anonymous_sample <- sample_names
  assays <- list(author_abundance = a)
  if (!is.null(alternative)) {
    dimnames(alternative) <- dimnames(a)
    assays$author_normalized_abundance <- alternative
  }
  if (s$kind == 'hcc18o') {
    for (k in names(alternate)) {
      dimnames(alternate[[k]]) <- dimnames(a)
      assays[[k]] <- alternate[[k]]
    }
  }
  # No original column labels, patient-code map, extra workbook sheet or original table is embedded.
  provenance <- s[intersect(
    c(
      'dataset',
      'doi',
      'accession',
      'repository',
      'source_url',
      'source_workbook_url',
      'source_workbook_sha256',
      'original_sha256',
      'license',
      'license_url',
      'license_evidence_url',
      'license_policy_url',
      'verified_submit_date',
      'scale',
      'source_scale',
      'assay_semantics',
      'privacy_description'
    ),
    names(s)
  )]
  result <- list(
    assays = assays,
    feature_data = feature,
    sample_data = cd,
    provenance = provenance,
    representation = 'deidentified processed-source derivative; not an exact-original file',
    processing = 'All selected author quantitative values and NA/zero states retained; no transformation, imputation or clinical metadata retained'
  )
  if (s$kind == 'oxoscan') {
    result$source_records <- data.frame(
      source_signal_feature = d$peak_num,
      anonymous_sample = sample_names[ci],
      merged_rt = d$merged_rt,
      Intensity = d$Intensity,
      Intensity.Norm = d$Intensity.Norm
    )
  }
  target <- file.path(
    'data-raw/_shared/artifacts/noncptac/assets',
    paste0(id, '-deidentified.rds')
  )
  saveRDS(result, target, compress = 'gzip', version = 3)
  spec <- provenance
  spec$dataset <- id
  spec$accession <- s$accession
  spec$repository <- s$repository
  spec['glycan_type'] <- list(
    if (is.null(s$glycan_type)) NULL else s$glycan_type
  )
  spec$format <- 'rds'
  spec$sha256 <- digest::digest(file = target, algo = 'sha256')
  spec$features <- nrow(a)
  spec$measurements <- ncol(a)
  spec$privacy_derivative <- TRUE
  spec$curated_status <- s$curated_status
  spec$source_representation <- 'deidentified derived processed-source file; original human source file is local reference only'
  register_literature_source(target, spec, cache)
  validation[[id]] <- list(
    dimensions = dim(a),
    assay_names = names(assays),
    source_quantitative_values_preserved = TRUE,
    missing = sum(is.na(a)),
    zeros = sum(a == 0, na.rm = TRUE),
    no_original_patient_mapping = TRUE,
    source_sha256 = s$original_sha256,
    derived_sha256 = spec$sha256
  )
}
jsonlite::write_json(
  validation,
  'data-raw/privacy-review/source-validation.json',
  pretty = TRUE,
  auto_unbox = TRUE
)
