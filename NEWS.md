# glyhub 0.2.1

## Minor improvements and bug fixes

* `glyhub_load()` and the 47 literature dataset loaders now download the verified assets from `data-v0.2.0` without a preseeded cache. All 47 curated objects and 32 source files retain their existing SHA-256 checksums and scientific content; existing `data-v0.1.0` resources are unchanged.

# glyhub 0.2.0

## New features

* `glyhub_catalog()` includes 47 locally staged curated datasets and 32 source representations for literature review, with provenance and source-data licenses; these resources require a verified local cache and are not downloadable data assets in this release.
* Locally staged GALNT lysate and HGF cell-line datasets provide consolidated molecular-key and annotation-group matrices while retaining original experiments, source values, and missingness; explicit migration maps identify the replaced local dataset names.
* Locally staged human datasets use study-local labels in place of original subject identifiers and individual clinical covariates; four EV source representations with unresolved subject linkage remain withheld.
* The staged PXD019914 dataset provides linear relative ratios obtained from author-normalized log2 ratios, with the original log2 matrix, missingness, zeros, and QC roles retained; these values are not raw intensities.

## Minor improvements and bug fixes

* `glyhub_load()` restores reviewed abundance scales for historical resources and staged literature datasets after dataset and SHA-256 verification, without changing scientific values or cached files.
* `glyhub_load()` synchronizes historical assay and annotation axis names through public glyexp conversions for compatibility with glyexp 0.20.0. (#8)
* `glyhub_load(kind = "raw")` supports signed author-processed source files without changing their values or treating multi-run GPSM files as aligned sample matrices.
* The GPST000120 rebuild retains Spike/ACE2 sample annotations; existing published data assets are unchanged.

# glyhub 0.1.0

* Initial release with 97 curated glycomics and glycoproteomics datasets: 75 from GlycoPOST, eight from CPTAC, and 14 from other published studies.
* `glyhub_catalog()` lists datasets as a tibble with source, experiment and glycan types, structure availability, quantification descriptions, dimensions, and download metadata.
* `glyhub_load()` and 97 dataset-specific loaders retrieve `GlycomicSE` or `GlycoproteomicSE` objects from a versioned data release, verify file size and SHA-256 checksums, and support cached offline loading. CPTAC loaders also provide verified raw source archives.
* Dataset documentation describes source annotations, abundance scales, missing-value conventions, processing records, and source-data licenses. Curated objects retain source numerical values and provenance in metadata.
