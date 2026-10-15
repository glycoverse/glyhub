# Validation of the 73-project expansion

The 74-object catalog was validated with R 4.5.0, glyexp 0.17.0 and glyrepr 1.1.0 on Linux.

- Complete reconstruction reproduced all 74 objects with identical assays, canonical typed annotations, sample metadata and provenance. Runtime graph identifiers were excluded from comparison.
- All 34 previously distributed objects remain identical in scientific content to the upstream main baseline (991e82395ae7fa86b40e1d3e02649126947fc624); their original RDA files are retained.
- All 1,548 development-loaded expectations passed, with no failures, warnings or skips.
- `R CMD check --no-manual --no-build-vignettes --no-vignettes` completed with Status: OK, including installed-package tests, documentation checks, data loading and LazyData checks.
- Each accepted new matrix was independently checked against its original source coordinates or manually transcribed image table, with explicit masks for unreported values, zero conversion and annotation conflicts.
- GPST000240 and GPST000297 structure diagrams received a second visual review; GPST000296 mapping was checked against the source spectral atlas.
- Source recovery records pin exact payload SHA-256 values and archive member paths. Nested archive extraction is supported; missing or altered content stops the build.

These checks establish reproducibility and software integrity. They do not imply recovery of every experiment in each article or resolve missing biological evidence. Per-project limits are listed in HIGH-IMPACT-73.md and the accession ledger. Remote platform checks are reported on the review pull request.
