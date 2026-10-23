# Rscript data-raw/MSV000097695/build.R /path/to/MSV000097695 /path/to/cache
args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) == 2L)
evidence <- normalizePath(args[1], mustWork = TRUE)
cache <- args[2]
source("data-raw/MSV000097695/convert-site.R")
source("data-raw/_shared/scripts/noncptac/register-literature.R")
provenance <- jsonlite::fromJSON("data-raw/MSV000097695/source.json")
p <- file.path(evidence, provenance$local_file)
stopifnot(identical(digest::digest(file = p, algo = "sha256"), provenance$sha256))
dictionary <- unlist(provenance$composition_dictionary)
x <- msv000097695_site(p, provenance, dictionary)
stopifnot(identical(dim(x), c(3274L, 6L)))
# Independent source read, not the converter's intermediate matrix.
original <- utils::read.delim(p, check.names = FALSE, quote = "\"", na.strings = "")
source_matrix <- as.matrix(original[5:10])
stopifnot(identical(as.numeric(source_matrix),
                    as.numeric(SummarizedExperiment::assay(x))))
register_literature(x, "glyhub_MSV000097695_N_AdultWorm",
  "Schistosoma mansoni adult-worm source N-glycan-site abundance",
  c("Three female-labelled and three male-labelled whole-adult-worm measurements.",
    "Replicate biological independence is not reported. The study's tissue-specific",
    "transcriptomic analyses do not imply tissue-resolved mass-spectrometry samples.",
    "All 3,274 source site/composition rows are retained. Ambiguous protein/site",
    "groups are not expanded or assigned a guessed single accession or position.",
    "Author downstream protein normalization and Perseus processing are not reapplied."))
jsonlite::write_json(list(
  source_sha256 = provenance$sha256, dimensions = dim(x),
  source_cells_compared = length(source_matrix), source_values_exact = TRUE,
  zero = sum(source_matrix == 0, na.rm = TRUE), missing = sum(is.na(source_matrix)),
  valid_object = methods::validObject(x)
), "data-raw/MSV000097695/validation.json", pretty = TRUE, auto_unbox = TRUE)
