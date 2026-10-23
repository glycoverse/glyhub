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
