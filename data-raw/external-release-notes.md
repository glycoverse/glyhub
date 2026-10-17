All glyhub datasets are distributed externally in this single data release:
75 GlycoPOST-derived curated RDA objects, eight CPTAC curated RDS objects,
and eight byte-preserving original CPTAC TSV gzip archives.

Use `glyhub_load("glyhub_CPTAC_CCRCC")` or `glyhub_CPTAC_CCRCC()`.
Every dataset has its own function with the same download, verification,
cache and offline options as the common loader. The package no longer bundles
dataset objects or exposes LazyData, `data()` or variable-style entry points.

`manifest.tsv` lists all 91 resources with pinned URLs, sizes and SHA-256 hashes.
`SHA256SUMS` covers data assets and supporting files. Build scripts and storage
policy are included in `build-sources.tar.gz`. The original CPTAC manifest is
preserved inside that archive as historical provenance.

This release consolidates the former CPTAC release and the unpublished general
data draft. Scientific file bytes have not changed. CPTAC objects retain their
original data-version label in metadata; the unified manifest identifies the
current hosting release.

CPTAC assays use 2^source log2 abundance, retaining complete original log2
matrices in metadata. None becomes NA. Reference and QC columns remain annotated.
Protein accessions and absolute sites remain unknown. HGSC does not match the
supplied original MD5 list and its fractionation identity remains unverified.

Scientific sources, citations and data-use terms remain in each dataset's
metadata and help topic. The package's MIT code license does not license source
data. CPTAC portal: https://pdc.cancer.gov/pdc/cptac-pancancer
Data-use guidelines: https://pdc.cancer.gov/pdc/data-use-guidelines

Future changes to scientific assets require a new version, not overwriting data.
