dir.create(
  "data-raw/_shared/bundled-build",
  recursive = TRUE,
  showWarnings = FALSE
)
source("data-raw/GPST000599/ensure-source.R", local = new.env())
source("data-raw/_shared/ensure-expansion-sources.R", local = new.env())
# Verify retained original sources, annotations and reviewed mappings.
source_manifest <- utils::read.csv(
  "data-raw/_shared/source-checksums.csv",
  stringsAsFactors = FALSE
)
stopifnot(
  all(file.exists(source_manifest$path)),
  identical(unname(tools::md5sum(source_manifest$path)), source_manifest$md5)
)
# Run from the package root to rebuild all curated accessions.
source("data-raw/GPST000035/GPST000035-build.R", local = new.env())
source("data-raw/GPST000120/GPST000120-build.R", local = new.env())
source("data-raw/GPST000128/GPST000128-build.R", local = new.env())
source("data-raw/GPST000183/GPST000183-build.R", local = new.env())
source("data-raw/GPST000213/GPST000213-build.R", local = new.env())
source("data-raw/GPST000271/GPST000271-build.R", local = new.env())
source("data-raw/GPST000374/GPST000374-build.R", local = new.env())
source("data-raw/GPST000431/GPST000431-build.R", local = new.env())
source("data-raw/GPST000533/GPST000533-build.R", local = new.env())
source("data-raw/GPST000599/GPST000599-build.R", local = new.env())
source("data-raw/GPST000643/GPST000643-build.R", local = new.env())
source("data-raw/GPST000676/GPST000676-build.R", local = new.env())
source("data-raw/GPST000738/GPST000738-build.R", local = new.env())
source("data-raw/GPST000381/GPST000381-build.R", local = new.env())
source("data-raw/GPST000602/GPST000602-build.R", local = new.env())
source("data-raw/GPST000578/GPST000578-build.R", local = new.env())
source("data-raw/GPST000125/GPST000125-build.R", local = new.env())
source('data-raw/_shared/merge-panels.R', local = new.env())
source("data-raw/_shared/build-expansion.R", local = new.env())

source("data-raw/_shared/package-resources.R", local = new.env())
