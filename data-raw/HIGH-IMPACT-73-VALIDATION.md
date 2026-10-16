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

## 2026-10-16: Mgat3 brain and kidney source recovery

The additive 75-object catalog was validated with the same R 4.5.0, glyexp 0.17.0 and glyrepr 1.1.0 environment.

- The combined GPST000027/GPST000031 study object retains all 51 brain and 287 kidney source features across six source observations. Its 338 by 6 storage matrix contains 1,250 measured source cells and 778 explicitly unmeasured cross-panel combinations.
- Both complete source intensity matrices and source high-mannose-normalized percentage matrices are preserved. All 324 measured source zeros have distinct zero-conversion masks. The brain transcription was independently reviewed against the source image; all 2,296 kidney quantitative cells were checked directly against the workbook.
- All 306 unambiguous compositions and 32 typed missing ambiguous compositions agree with source annotations. Every candidate annotation remains available, and no unsupported structure column is created.
- Rebuilding the new study twice reproduced identical scientific content and preserved all 74 preexisting RDA files byte-for-byte. The reproducible audit is `GPST000027/validate-study.R` and its machine-readable result is `GPST000027/study-validation.json`.
- All 1,650 development-loaded expectations passed with no failures, warnings or skips, including 74 focused new expectations.
- `R CMD build` succeeded and `R CMD check --no-manual --no-build-vignettes --no-vignettes` completed with Status: OK (zero errors, warnings and notes).

The union is a source-preserving resource, not a cross-tissue peak alignment or calibrated intensity comparison. Brain raw-file associations are explicitly candidate mappings, and the public two-column brain table is not treated as all three biological pairs reported in the article. The article-version CC BY 4.0 evidence is recorded with its scope; no separate supplement-specific declaration was independently verified.

The same study builder and all 1,650 package expectations also passed in a separate development-library copy using glyexp 0.18.0. This compatibility check did not modify the pinned glyexp 0.17.0 validation library or the original working copy.
