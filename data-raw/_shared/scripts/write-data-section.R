# Replace one generated section without overwriting other dataset families.
write_data_section <- function(section, text, path = "R/data.R") {
  lines <- readLines(path, warn = FALSE)
  begin <- paste0("# BEGIN DATA SECTION: ", section)
  end <- paste0("# END DATA SECTION: ", section)
  first <- which(lines == begin)
  last <- which(lines == end)
  stopifnot(length(first) == 1L, length(last) == 1L, first < last)
  lines <- c(
    head(lines, first),
    text,
    lines[seq.int(last, length(lines))]
  )
  writeLines(lines, path)
}
