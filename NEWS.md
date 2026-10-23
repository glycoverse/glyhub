# glyhub (development version)

* Remove original human subject/sample identifiers and individual clinical covariates from seven curated objects and eight source representations, preserving quantitative values and necessary study design with study-local labels. Withhold four EV originals with unresolved subject linkage; do not publish a reverse identity map.
* Consolidate nine unpublished GALNT lysate objects into a 6,789-by-54 exact molecular-key union and two HGF cell-line objects into a 2,318-by-12 annotation-group union. Retain every original experiment, batch, source value and native missingness; distinguish structural missing cells. Explicit migration maps replace the eleven old local identifiers without silent aliases. Secretome remains separate.
* Stage 47 curated objects and 32 source representations (24 original files and eight deidentified derivatives) from the literature assessment, including additional source-preserving glycoproteomics objects for literature review, with provenance, licenses, complete selected author matrices and independent source-value checks. These objects require the maintainer's verified local cache; no data release is published.
* Distinguish protein-level N-glyco-enrichment, site-associated O-glycopeptide reporter signals and N-site/composition measurements. Retain source log2 scales, missing values and zeros; do not infer absent structures, sites or replicate independence.

* Support signed author-processed source files through the existing `kind = "raw"` path interface, without changing the curated assay contract or transforming values. Multi-run GPSM source files are not aligned matrices or independent cohorts.

* For PXD019914 only, curate `2^x` of explicitly author-normalized log2 ratios as linear relative ratios, not raw intensity. Retain the original log2 matrix, missingness, source zeros and ten QC roles; other signed source files remain unchanged.

# glyhub 0.1.0

* Initial release with 97 curated glycomics and glycoproteomics datasets: 75 from GlycoPOST, eight from CPTAC, and 14 from other published studies.
* `glyhub_catalog()` lists datasets as a tibble with source, experiment and glycan types, structure availability, quantification descriptions, dimensions, and download metadata.
* `glyhub_load()` and 97 dataset-specific loaders retrieve `GlycomicSE` or `GlycoproteomicSE` objects from a versioned data release, verify file size and SHA-256 checksums, and support cached offline loading. CPTAC loaders also provide verified raw source archives.
* Dataset documentation describes source annotations, abundance scales, missing-value conventions, processing records, and source-data licenses. Curated objects retain source numerical values and provenance in metadata.
