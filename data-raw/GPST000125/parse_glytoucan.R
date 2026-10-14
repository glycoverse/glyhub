extra_lib <- Sys.getenv('GLYHUB_GLYPARSE_LIBRARY')
if (nzchar(extra_lib)) {
  .libPaths(c(extra_lib, .libPaths()))
}
library(glyparse)
library(glyrepr)
library(jsonlite)
args <- commandArgs(trailingOnly = TRUE)
b <- if (length(args)) args[[1]] else '.'
xs <- fromJSON(
  file.path(b, 'glytoucan_sequences.json'),
  simplifyVector = FALSE
)$results$bindings
out <- lapply(xs, function(x) {
  id <- sub('.*/', '', x$id$value)
  seq <- x$seq$value
  warns <- character()
  err <- NULL
  result <- tryCatch(
    withCallingHandlers(
      {
        st <- parse_wurcs(seq, validate = TRUE)
        st <- as_glycan_structure(as.character(st))
        if (anyNA(st)) {
          stop('NA structure')
        }
        comp <- as_glycan_composition(st)
        list(structure = as.character(st), composition = as.character(comp))
      },
      warning = function(w) {
        warns <<- c(warns, conditionMessage(w))
        invokeRestart('muffleWarning')
      }
    ),
    error = function(e) {
      err <<- conditionMessage(e)
      NULL
    }
  )
  cat(id, if (is.null(result)) 'FAIL' else result$composition, '\n')
  list(
    glytoucan_id = id,
    wurcs = seq,
    parsed = result,
    error = err,
    warnings = warns,
    parser_version = as.character(packageVersion('glyparse')),
    glyrepr_version = as.character(packageVersion('glyrepr'))
  )
})
write_json(
  out,
  file.path(b, 'glytoucan_parsed.json'),
  auto_unbox = TRUE,
  pretty = TRUE,
  null = 'null'
)
