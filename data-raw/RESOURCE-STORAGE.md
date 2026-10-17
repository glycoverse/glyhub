# External data resources

All 83 curated datasets are hosted on the single `v0.1.0` GitHub Release.
No dataset objects are installed with the package. `inst/extdata/manifest.tsv`
is the authority for resource filenames, SHA-256, sizes, versions and URLs.

Use `glyhub_load(dataset)` or the same-named dataset function. Both support
`kind`, `cache_dir`, `refresh` and `offline`, and share the verified cache.
There is no LazyData, `data()` or variable-style object interface.
`kind = "raw"` returns a verified file path for the eight available CPTAC source
archives. Scientific data and original provenance have not changed.

GlycoPOST build scripts write to ignored `data-raw/bundled-build/` (the historical
staging directory name does not indicate package inclusion). Run
`Rscript data-raw/package-resources.R` to copy all 75 files and all CPTAC resources
to ignored `data-raw/releases/v0.1.0/` and regenerate the manifest.
The full GlycoPOST build invokes this packaging step automatically.
Build CPTAC assets using its documented source directory first.

The release consolidates the former CPTAC release and the unpublished general
data draft. Original CPTAC object provenance retains its original data-version
label; the unified manifest identifies the current transport release. The build
source archive preserves that original CPTAC manifest for historical context.
Future revisions require a new release version; do not overwrite scientific
assets. Source-data terms and attribution remain as recorded in each object.
