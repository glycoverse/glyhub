# Validation

Current expansion results: [73-project validation](HIGH-IMPACT-73-VALIDATION.md).

## Previous 34-dataset baseline

The previous baseline catalog contains 34 datasets from 17 accessions. All 34 datasets retain identical assays, supported molecular annotations, sample metadata values and provenance after omitting all-NA structure columns from 18 datasets. The other 16 retain their typed structure columns and per-feature missing values. GPST000168 is deferred and outside this catalog.

- The optional-structure-column review is recorded in `validation-logs/structure-column-*`; per-dataset and shared help pages state the actual schema.
- Sample-metadata type review: 20 columns across 11 datasets retain numeric/logical source types. Independent conservation checks verify all values and missingness, all assays and row annotations, mixed-source text and nonaffected metadata.
- R 4.5.0 on the isolated Linux cloud runtime; glyhub 0.0.0.9000, glyexp 0.17.0, glyrepr 1.1.0.
- Development-loaded tests: 1,114 passed, zero failures, warnings or skips.
- Clean installed-package tests: 1,114 passed, zero failures, warnings or skips. The actual isolated installation is explicitly printed in the validation log.
- Complete 34-object reconstruction: all assays, canonical composition/structure annotations, sample conditions and provenance are identical. Graph runtime identifiers are excluded from canonical comparisons. The earlier full-catalog timing was 69.088 seconds for reconstruction and 52.825 seconds for a separate build; the optional-column reconstruction also passed and was not separately timed. Neither figure measures literature curation labor or download time.
- GPST000599: anonymous full-archive recovery succeeded; the extracted XLSX matches its fixed SHA-256. The 134 clinical mappings and source-cell snapshot validate; a negative checksum fixture stops without altering the existing file.
- All 88 retained source/annotation/mapping checksums verified.
- Original 22-object regression: assays, supported molecular annotations and observation metadata values unchanged; the documented optional-column and source-type schemas apply.
- GPST000125: all 1,072 quantitative cells match the original XLSX; 304 zero values become assay NA. Sixty-six compositions and 25 structures validate, with one unresolved source diagram/name conflict retained as typed NA. All 215 registry records were independently reparsed; portable helper reconstruction matches the reviewed specifications.
- GPST000381: complete 36 × 2 expression block, 48 populated source cells, source label choice and direct composition counts independently verified.
- GPST000578: all 1,516 selected worksheet cells independently verified using standard-library OLE/BIFF parsing. Ten affected cells have fixed worksheet values and a checksum-pinned override, with regression tests guarding against chart-cache substitutions. All 85 distinct GlyTouCan identifiers resolve and validate.
- GPST000602: all 2,336 source peaks and 23,360 original field values accounted for; 1,607 annotated records retained, 729 excluded with provenance. Exact retained source coordinates, coverage masks, 82 review indicators and all typed compositions verified. The five source-peak matrices remain explicitly unaligned between spectra.
- Initial independent merger checks remain preserved: all 20,154 cells from the eight earlier consolidated objects were recoverable exactly. Current tests additionally verify the new merged groups and new source-coverage semantics.
- Independent GPST000128 reconstruction from source query tables: all 978 records, IDs, composition counts and 22 zero-to-NA conversions agree.
- Documentation and object-inventory coverage checked for every distributed object. Former panel names are mapped in panel-name-mapping.csv without duplicate distributed datasets.

The remote baseline remains abd0b336b180df922f3c6c0e9884b8bb2856b7cf. Its CI configuration and prior fixes are preserved. These local checks cover the available Linux R runtime; they do not establish older-R or other-platform compatibility. GitHub CI results belong to the review pull request. The package website was not deployed.

The package check log is retained as 00check.log. Software checks establish packaging integrity, not author-level biological correctness or a legal determination about source-data licensing. Source terms and limitations are documented separately.

Final local source-package check: `R CMD check --no-manual` completed with **0 errors, 0 warnings and 0 notes** (Status: OK). Full log: 00check.log. The package check reran the complete test suite against its own installation.
