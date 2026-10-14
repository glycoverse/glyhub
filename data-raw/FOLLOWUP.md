# Follow-up curation, 14 October 2026

The package now contains 34 objects from 17 projects, including 30 objects from fifteen newly accepted pilot projects. The initial 22 objects retain identical assays, molecular annotations and observation metadata; new source coverage masks extend their provenance without changing their measurements.

## Newly included profiles

- **GPST000125:** three complete Table S4 profiles cover N-glycans (41 × 16), O-glycans (14 × 16), and glycosphingolipid glycans (12 × 16) in eight HEK293 conditions with two author-described biological replicates. The original 253,603-byte `mmc5.xlsx`, including its native drawings, is retained and checksum-verified. All 1,072 primary quantitative cells match the original; only the 304 assay zeros become NA, with original values preserved. The 67 features have 66 supported compositions and 25 single-source, registry-backed structures. All six original annotation-conflict flags remain. The original drawing supports five composition decisions; N feature 17 remains unresolved, with composition and structure NA and its quantitative row intact. Average/error columns and the separate diagnostic MS2-ion table are not treated as glycome observations.
- **GPST000381:** 36 N-glycan features across two prosaposin profiles. The Relative expression block supplies both quantities and pSAP65/pSAP75 labels. Separate raw-block headers disagree; those original labels remain available. This is an explicit curation choice, not an author correction. Fractions are not rescaled, and replication is unknown.
- **GPST000578:** nine complete source panels produce three measurement groups: total peak area (75 × 27), source repeatability intensity (41 × 12), and inter-instrument fetuin peak area (14 × 2). Author GlyTouCan identifiers support feature alignment; biological replication is not inferred. All 85 unique identifiers have registry-backed structures and compositions. Duplicate lower source blocks are not counted again.
- **GPST000602:** five worksheets remain distinct: Sh GSL 566 × 11, Sm GSL 183 × 3, Sh N 489 × 10, Sm N 247 × 4, Sh O 122 × 4. These are annotated source-peak containers, with each peak tied to exactly one spectrum. They are not aligned cross-sample molecular matrices and must not be used directly for differential abundance. A complete ledger accounts for 1,607 retained and 729 excluded unannotated records. Coverage separates unmeasured combinations from observed missingness. Eighty-two calculated mass-error flags and seven untestable theoretical-mass entries retain original values without correction.

## Source-reading safeguard

In the GPST000578 XLS, readxl/libxls can substitute ten embedded chart-cache values for worksheet C3:C12 on Figure 4b. Independent OLE/BIFF parsing verifies the actual worksheet records and all 1,516 selected quantities. The original XLS is unchanged. Only this explicitly flagged sheet uses a checksum-pinned 19 × 36 worksheet snapshot. The build never routes that sheet through the affected reader. A ten-cell regression fixture records worksheet coordinates, correct values, nested-chart values and BIFF offsets. This is a reading-software issue, not an author-data conflict.

## Pending candidates

GPST000168 is deferred from this batch. Its muropeptide representation is outside the currently supported glycan types; no upstream schema change is proposed, and no source files or derived objects for this project are included. Four pilot projects remain excluded: GPST000580, GPST000301 and GPST000297 lack an eligible complete quantitative matrix; GPST000038 is an identification library.

## Licensing scope

GPST000125 has no independently verified explicit reuse license for the publisher supplementary workbook. Its source notice and unresolved license scope are retained; neither the package code license nor GlycoPOST deposited-data terms are assigned to that workbook.

GPST000578 and GPST000602 publisher-hosted numeric tables lack a separately verified data-specific license in the reviewed materials. Their articles carry CC BY-NC-ND terms. A linked Panorama deposit explicitly carries CC BY 4.0, but its inspected contents do not establish a matching export of these source matrices, so that license is not assigned to them. The source notices and exact scope remain recorded independently of package code licensing. This is not a legal determination that factual extraction is forbidden or unrestricted. Review applicable source terms before redistribution or commercial reuse.

## GPST000599 source storage

The 20,679,775-byte original supplementary `mmc4.xlsx` is kept outside Git. The versioned primary quantitative workbook, clinical source-cell snapshot and sample-to-subject/date mapping preserve the reviewed data and provenance. The public original archive URL, unchanged XLSX SHA-256 and `ensure-source.R` recovery script are recorded in `GPST000599/SOURCE-RECOVERY.md`. The full build requires recovery and checksum verification of the unchanged original; the clinical snapshot is not presented as a replacement workbook. End-to-end anonymous recovery was verified on 14 October 2026: the public archive download was 222.1 MB and the extracted original matched the fixed SHA-256. A mismatching pre-existing file also correctly stops recovery without being changed.

## Reproduction and checks

The build consumes checksum-pinned originals and mappings under accession directories. GPST000125 has original-workbook, annotation and exact-cell validators; GPST000381 has an independent expression-block validator; GPST000578 has a standard-library-only BIFF verifier; GPST000602 has an XML-level conservation validator and portable extraction script. Package tests cover masks, quantities, annotations, identifiers, object/documentation coverage, and the ten-cell reader regression. Full build, clean-install and package-check outcomes are recorded in VALIDATION.md and the corresponding logs.

## Optional structural annotation column

The `glycan_structure` row-data column is omitted when a dataset has no valid structural annotations. It is absent from 18 of the 34 datasets. The remaining 16 retain a typed column, with NA for unsupported individual features. Complete rebuilding and comparison preserve all measurements, compositions, supported structures, sample metadata and source provenance. Each help page describes the actual row-data schema.
