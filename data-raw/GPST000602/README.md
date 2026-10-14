# GPST000602: five annotated MALDI peak-list objects

## Result

Five source sheets remain five separate objects. The assay is the original `Intens.` peak intensity, in source instrument/arbitrary units.

| Object | Sheet | Retained peak records | Spectra | Removed unannotated records |
|---|---|---:|---:|---:|
| glyhub_GPST000602_Sh_GSL | (A) Sh GSL glycans | 566 | 11 | 261 |
| glyhub_GPST000602_Sm_GSL | (B) Sm GSL glycans | 183 | 3 | 16 |
| glyhub_GPST000602_Sh_N | (C) Sh N-glycans | 489 | 10 | 265 |
| glyhub_GPST000602_Sm_N | (D) Sm N-glycans | 247 | 4 | 60 |
| glyhub_GPST000602_Sh_O | (E) Sh O-glycans | 122 | 4 | 127 |
| **Total** | | **1,607** | **32** | **729** |

Exactly 728 literal `null` annotations and one blank annotation were excluded under the annotated-rows-only selection. Every removed record retains all ten original source fields, exact cell coordinates, sample label, source row/block, and applicable formulas in `removed-row-ledger.json`. The source workbook itself is unchanged.

## Feature identity limitation

These are source-specific peak records, not a claim of 1,607 distinct molecular glycans. Rows have identity `accession::sheet::spectrum::source-row`. Every row has one source measurement. Other spectrum columns are unaligned/unmeasured combinations, marked `source_coverage=FALSE`; they are not observed absence, source missingness, or zero abundance. Direct between-sample differential abundance needs an independently justified alignment first.

Alignment by row position or composition was rejected. Two same-spectrum pairs have the same composition and theoretical m/z but distinct source peak records: source sheet (A), rows 42/43 and 59/60 in the sixth spectrum block. Broad mass matching does not resolve these. Several theoretical-mass values also have apparent decimal errors. All annotations are retained verbatim; no source errors are silently repaired. MOESM4–6 characterize selected ions but do not supply a unique peak-level crosswalk for all spectra, and report multiple isomeric structures for some compositions. See `alignment-audit.json`, `candidate-composition-groups.json`, and `source-mass-annotation-anomalies.json` for the evidence and assessment.

Typed monosaccharide counts preserve the source's resolution: `dHex` is not promoted to fucose and `Pen` is not promoted to xylose. AA/reduced-end labels are kept separately from monosaccharide counts. Exact structures remain unknown.

## Integration contract

1. Copy `41467_2026_70850_MOESM3_ESM.xlsx` and accompanying provenance files into `data-raw/GPST000602/` when integrating. `matrix-specs.json` uses that relative source path. No repository was changed during extraction.
2. The mapping is nonrectangular. `row_indices` and `column_indices` are deliberately empty. Use the full-dimension `source_cell_rows` and `source_cell_columns` for per-cell source verification. Off-spectrum cells have null coordinates.
3. Preserve `source_coverage` in object metadata, and distinguish `not_measured/unaligned` from `source_missing`. The ordinary rectangular extraction check is inapplicable.
4. Keep the five source sheets as five objects. Respect `keep_source_sheet_as_separate_object=TRUE` and `prevent_study_type_merge=TRUE`; do not merge the two species' GSL or N-glycan objects merely because study/type matches.
5. Preserve raw intensities, source annotations, the raw workbook, and both record ledgers. Apply only quantitative zero-to-NA conversion. There are no zero assay intensities in these retained rows. No normalization, summation, averaging, imputation, intensity filtering, or raw-MS reprocessing was performed.
6. Retain license caution in package metadata/documentation before any publication or redistribution.

## Validation

`validation-report.json` passed independent XLSX-XML source checks for all 23,360 source field values, every retained intensity and exact coordinate, the 2,336-record conservation partition, all sparse coverage/coordinate cells, and the sole permitted zero-to-NA rule. Non-shared formulas were checked against XML; shared formula expansions are retained from the read-only workbook parser. The original workbook preserves the underlying formula representation and caches. `typed-composition-validation.json` confirms that glyrepr constructs all 1,607 typed compositions successfully.

R object construction and package-wide validation are the integration step; this folder supplies five checked specifications and provenance.

## Source and license

Petralia et al. (2026), *Major human schistosome species express different glycans with immunological and diagnostic implications*, Nature Communications 17, 4312. DOI: https://doi.org/10.1038/s41467-026-70850-0

Workbook: https://media.springernature.com/original/springer-static/esm/art%3A10.1038%2Fs41467-026-70850-0/MediaObjects/41467_2026_70850_MOESM3_ESM.xlsx

Source SHA-256: `e5ea07ba142a319b98dce1540de4c74888a535cacfb29baa62aea7a8af62a87b`.

The source comes from Springer supplementary material. The article's notice is CC BY-NC-ND 4.0: https://creativecommons.org/licenses/by-nc-nd/4.0/. Whether this factual extraction is independently redistributable is not established here; review before public packaging. GlycoPOST raw-MS repository terms should not be substituted for the source workbook's actual licensing context.

## Portable execution and validator inputs

Run `python prepare_specs.py` from any working directory. It reads exactly these two files beside the script: `41467_2026_70850_MOESM3_ESM.xlsx` and `source-peaklist-mapping.json`. The reviewed source SHA-256 is pinned; the source URL is the fixed official Springer URL. No external review-folder files or absolute workspace paths are required.

Run `python validate_specs.py` with the following files beside that script:
- `41467_2026_70850_MOESM3_ESM.xlsx`
- `matrix-specs.json`
- `retained-peak-ledger.json`
- `removed-row-ledger.json`
- `source-mass-annotation-anomalies.json`

`check_typed_compositions.R` locates `matrix-specs.json` beside itself and requires installed jsonlite/glyrepr packages. It writes `typed-composition-validation.json` there.

Exactly 82 retained row annotations have `source_mass_annotation_flag=TRUE`, matching the audited rule `abs(1e6 * (measured_mz - source_theoretical_mz) / source_theoretical_mz) > 300`. Each row also exposes `source_reported_accuracy_ppm`, `calculated_mass_error_ppm`, and an explanatory flag reason. This is an informational review indicator; no source value, composition, or row inclusion is corrected or changed. All other retained rows have the flag set to false. Seven records lack a source theoretical mass and are separately marked `source_mass_annotation_testable=FALSE`; their calculated error remains null. The flag is available within the rowData source annotation record and may also be exposed as a direct rowData column by the integrating builder.
