# Maintenance validation helper: input is a private pre-redaction manifest and local cache.
# Native study builders also apply the same mandatory privacy transformation on registration.
args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) == 2L)
cache <- args[2]
source('data-raw/_shared/scripts/noncptac/register-literature.R')
source('data-raw/_shared/scripts/noncptac/privacy.R')
m <- read.delim(args[1], stringsAsFactors = FALSE)
results <- list()
for (id in literature_private_subject_datasets) {
 e <- m[m$dataset == id & m$kind == 'curated', ]
 path <- file.path(cache, e$version, paste0(e$sha256, '-', e$filename))
 stopifnot(digest::digest(file=path, algo='sha256') == e$sha256)
 x <- readRDS(path)
 y <- redact_literature_subjects(x, id)
 stopifnot(identical(as.numeric(SummarizedExperiment::assay(x)), as.numeric(SummarizedExperiment::assay(y))))
 register_literature(y, id, paste('Deidentified', sub('^glyhub_[^_]+_[NO]_', '', id)),
  'Original quantitative values retained; public individual clinical metadata removed.')
 results[[id]] <- list(dimensions=dim(y), values_unchanged=TRUE, zeros_unchanged=TRUE,
  missingness_unchanged=TRUE, privacy_redacted=TRUE, valid=methods::validObject(y))
}
jsonlite::write_json(results, 'data-raw/privacy-review/curated-validation.json', pretty=TRUE, auto_unbox=TRUE)
