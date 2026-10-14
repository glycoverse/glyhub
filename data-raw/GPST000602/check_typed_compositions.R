library(jsonlite)
library(glyrepr)
args <- commandArgs(trailingOnly = FALSE)
script_arg <- grep('^--file=', args, value = TRUE)
if (!length(script_arg) && '-f' %in% args) {
  script_arg <- paste0('--file=', args[match('-f', args) + 1L])
}
base <- if (length(script_arg)) {
  dirname(normalizePath(sub('^--file=', '', script_arg[[1]])))
} else {
  getwd()
}
specs <- fromJSON(file.path(base, 'matrix-specs.json'), simplifyVector = FALSE)
results <- list()
for (spec in specs) {
  typed <- lapply(spec$row_annotations, function(r) {
    glycan_composition(unlist(r$composition_counts))
  })
  typed <- do.call(c, typed)
  stopifnot(length(typed) == spec$features, !any(is.na(typed)))
  results[[spec$name]] <- list(
    status = 'PASS',
    typed_compositions = length(typed),
    glyrepr_version = as.character(packageVersion('glyrepr'))
  )
}
write_json(
  results,
  file.path(base, 'typed-composition-validation.json'),
  auto_unbox = TRUE,
  pretty = TRUE
)
