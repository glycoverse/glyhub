# Exact reviewed source mapping, never a guess based on values or descriptive text.
literature_scale <- function(dataset) {
  scales <- utils::read.delim(
    "inst/extdata/literature-scales.tsv",
    stringsAsFactors = FALSE
  )
  matched <- which(scales$dataset == dataset)
  if (length(matched) != 1L || is.na(scales$scale[matched])) {
    stop("No reviewed literature abundance scale for: ", dataset, call. = FALSE)
  }
  scales$scale[matched]
}
