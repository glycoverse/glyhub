# Validation summary

## Coverage

- 47 staged curated objects: 9,833,288 matrix positions, including author zeros and missing values; this is not a count of independently detected glycopeptides.
- 32 staged source representations: 24 original processed-source assets and eight deidentified derivatives. Source files include protein, peptide, site-group and GPSM records, alternative analyses of the same acquisition, and signed author-processed matrices. They are not 32 independent cohorts or instrument-raw spectra.
- 79 resources linked to 33 papers. The 164-paper ledger separately records existing coverage and unfinished verification; no whole-paper completeness claim is made.

## Scientific and integrity checks

Independent rereading checked complete selected author values, row/column order and identities, source annotations, sample mapping, original zero/NA masks, and stated processing scales. Every new curated object passed `validObject`, SHA-256, byte count, dimensions, and actual offline loading. Every new source representation passed file/member checksums and verified-path offline loading; source-only identifiers reject curated loading. Original 105 manifest entries and 97 metadata entries are unchanged, with regression fixtures protecting both.

The two PXD019914 assays are the sole numerical exception: every value was checked against `2^source_log2_normalized_ratio`; original matrices, NA and QC roles remain available, and source log2 zero becomes one. No other source received that conversion. HGF annotation disagreements in seven author rows are flagged and canonical composition is unknown while both source annotations remain intact. Alternative structure codes are not asserted to be verified unique topologies.

## Package checks

The consolidated objects and new PXD013893 table passed independent complete-value checks. The privacy-reviewed local-cache test suite passed 966 expectations with zero failures, errors or warnings. Sixteen tests for older release assets remain skipped because those assets are absent from this cache; all 47 new curated objects and 32 source representations were available. All eleven embedded original experiments are identical to their prior checksum-pinned objects, including author attribution. Final `R CMD check` passed with 0 errors, 0 warnings and 0 notes (R 4.6.1, glyexp 0.18.0).

The merged matrices contain 253,614 structural NA positions introduced only by source-feature union. Their masks distinguish these from author missingness; all original experiment matrices, annotations, attribution, source row order and column mapping remain recoverable. Twenty-three TCL gene-label conflicts remain unknown in the merged consensus. The former eleven unpublished identifiers are explicitly superseded, not aliases.

## Limits and availability

This validates faithful data representation, not the original experiments, raw-spectrum identifications, FDR, site localization, glycan isomer topology, author imputation, or unreported subject correspondence. Author processing and unknowns remain explicit. No new normalization, imputation, feature aggregation or synthetic cross-run alignment was introduced.

These are locally staged resources, without public data-release URLs. The local review branch contains reproducible study builders, checksums, provenance, sample mappings, manifests and catalog documentation, not large original attachments or RDS binaries. Download the specifically licensed author inputs using each study specification, preserve relative archive paths, and run its builder with an input directory and cache directory. No release or merge is performed by these builders.

## Privacy regression

All 47 curated assay values, author missing/zero masks and source-scale matrices are unchanged; exactly seven objects have minimized human-subject metadata. Forty curated hashes remain unchanged. Eight human source entries are explicit deidentified derivatives; four EV originals are withheld. Individual clinical values and original subject labels are not published, including in embedded source metadata. Necessary analysis grouping and repeated/paired design are retained without an original-ID crosswalk. See `data-raw/privacy-review/` for reproducible processing and validation.

## Abundance-scale compatibility update (2026-11-07)

The source-reviewed mapping is 37 linear (`raw`), seven `log2`, and three `logx` assays. The three `logx` entries preserve the two documented pseudocount transformations and one unresolved post-log processing stage without promising an automatic inverse or log2 fold changes. The eleven embedded original experiments are linear. See `data-raw/_shared/metadata/literature-scales.md` for the per-source rationale.

The current loader adds absent scale metadata only for exact dataset/SHA-256 matches, including the embedded experiments. It does not rewrite cached files, alter the staged manifest, change any measurement or source mask, or publish data. Future constructors set explicit scales; registration validates the reviewed decision, and experiment merging rejects missing or mixed scales.

Package tests pass 667 expectations with zero failures, errors or warnings under both glyexp 0.18.0 and 0.19.0.9000. Separate builder checks pass 69 expectations. Nineteen scientific-cache tests are skipped, including the three literature-asset checks: the original staged cache is unavailable in this validation environment. The original full-data validation above used glyexp 0.18.0 and is historical evidence, not proof of current actual-artifact compatibility. Synthetic legacy-object/cache regressions do not substitute for rereading the 47 checksum-pinned RDS files; that remains a required check when the maintainer cache is restored.

To perform that check, set `GLYHUB_LITERATURE_CACHE` to the cache containing the manifest-pinned `noncptac-local-v1` assets, then run the complete test suite with current glyexp. The scientific tests now assert each actual object's reviewed scale, embedded-object validity, source matrices, missingness and merge round-trips in addition to the existing checksum and source-preservation checks.

## Recovery verification (2026-11-07)

The cache-dependent verification described above has now been completed for the
current staged registrations. See the [cache recovery report](../_shared/reports/noncptac/cache-recovery-20261107/README.md)
for the frozen historical manifest, explicit old-to-new asset mapping, reproduction
limits and verification summary.

All 79 actual staged files were verified by SHA-256 and size. Fifty-four match
historical bytes exactly: 27 curated RDS, three deidentified source RDS and 24
non-RDS source files. Twenty curated and five source RDS are newly rebuilt bytes
with updated registrations and matching metadata bindings. The unrecovered
historical bytes of those 20 curated objects were not tested; compatibility of
their current rebuilt artifacts must not be described as validation of the old
artifacts. The historical manifest remains preserved, and all resources remain
locally staged without public release URLs.

With this complete 79-file cache, the full suite passed 1,545 assertions with zero
failures, errors or warnings under both glyexp 0.18.0 and 0.19.0.9000 on R 4.6.1.
Sixteen tests for unavailable older released-resource source assets were skipped;
no literature scientific-cache tests were skipped. The actual curated-object audit
covered all 47 objects and 9,833,288 cells, including reviewed scales, source values,
missing/zero masks and embedded-experiment round-trips. Independent deep privacy
review covered the seven human-subject curated objects and eight deidentified
source derivatives, without claiming guaranteed anonymity.

Final clean-source `R CMD check --as-cran --no-manual` with glyexp 0.19.0.9000 passed
with 0 errors, 0 warnings and 0 notes. The historical check results above are
retained as records of their original validation stages.
