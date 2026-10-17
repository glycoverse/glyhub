# GPST000125: Table S4 source data and reproduction

## Result

This directory contains three complete Table S4 abundance blocks:

| Dataset | Features × observations | Canonical compositions | Single-source structures | Quantitative zeros retained |
|---|---:|---:|---:|---:|
| N-glycans | 41 × 16 | 40 | 13 | 242 |
| O-glycans | 14 × 16 | 14 | 8 | 30 |
| Glycosphingolipid glycans | 12 × 16 | 12 | 4 | 32 |

All blocks have eight HEK293 conditions with Exp1 and Exp2. The paper's methods explicitly identify two biological replicates. No cross-condition pairing or donor identity is inferred. The source T-KO spelling is retained separately from the article-supported MAN1A1/MAN1A2/MAN1B1 label.

Units are percent relative abundance. Every primary column sums to 100 within floating-point tolerance. All 1,072 primary quantitative cells match the preserved cell records and the original workbook. Average and error columns agree with the individual experiments and are not treated as samples. The existing R builder creates three valid GlycomicSE objects; only the 304 assay zeros become NA, with source values retained and no renormalization.

## Sources and original workbook

- Paper: Huang et al., *Global mapping of glycosylation pathways in human-derived cells*. Developmental Cell (2021). https://doi.org/10.1016/j.devcel.2021.02.023
- Article and methods: https://pmc.ncbi.nlm.nih.gov/articles/PMC8086148/
- Table S4, official public attachment: https://pmc.ncbi.nlm.nih.gov/articles/instance/8086148/bin/NIHMS1683936-supplement-5.xlsx
- Accession: https://glycopost.glycosmos.org/entry/GPST000125.0
- Registry evidence: https://ts.glytoucan.org/sparql

The original supplemental workbook, mmc5.xlsx, is retained with its native Excel vector drawings. Its size is 253,603 bytes and its SHA-256 is ae008af32e54980a6add4907da91a49723f9affb710c32e00f672c1e8e95ef41. This matches the workbook hash recorded in source-cell-records.json. All 1,072 primary measurements were checked against the XLSX. The 2,672-cell text/formula/value record provides an additional reproduction check; the XLSX remains the authoritative source for drawings and workbook layout.

The original drawings were rendered with LibreOffice. The six previously conflicting rows were visually inspected and their colored symbol counts independently checked from DrawingML; original-workbook-review.json records the evidence. This was a targeted composition-conflict review, not a claim of exhaustive visual validation or new linkage determination for every diagram.

## Annotation decisions

All source Component IDs and Structure IDs were retrieved from the official GlyTouCan SPARQL service: 215 distinct records. Generic base-composition counts were read from explicit WURCS residue declarations and indices. Full structures were parsed with glyparse 0.8.1 and validated using glyrepr 1.1.0. Registry records and parse results are preserved, including parser failures on base-composition ambiguity syntax. These failures do not prevent explicit residue counting and are not treated as structural evidence.

A canonical structure is assigned only when a single source Structure ID is successfully parsed and consistent with the accepted source composition. Multiple source structures remain an intact candidate list. No linkage is inferred from a diagram or mass.

Six features retain source/registry conflict flags and all original names/IDs. Five compositions are now supported by the original diagram and name. One remains NA:

- N feature 15 (worksheet row 18): source name, Component ID and diagram support H4N3F1S1. Structure ID G40578SN resolves to H4N3S1 and remains an inconsistent candidate; no canonical structure is assigned.
- N feature 16 (row 19): source name, Component ID and diagram support H5N3F1S1. G82273ZM resolves to H5N3S1 and remains an inconsistent candidate; no canonical structure is assigned.
- N feature 17 (row 20), unresolved: name/Component ID imply H6N3F1S1, but the original drawing has four Man plus one Gal, hence H5N3F1S1. It duplicates feature 16's symbol counts. G71917KP resolves to H6N3S1. Canonical composition and structure remain NA; the quantitative row remains intact.
- N feature 25 (row 28): name, original diagram and all four Structure IDs support H4N5F2. Component ID G03382KH resolves to H4N5F1 and is retained as inconsistent.
- N feature 38 (row 41): name, original diagram and all three Structure IDs support H6N6F1S2. Component ID G37881RL resolves to H6N6S2 and is retained as inconsistent.
- GSL feature 11 (row 75): name, original diagram and unique Structure ID G77285LE support H5N3. Component ID G66538GV resolves to H4N2 and is retained as inconsistent. The typed structure comes from the existing source G77285LE record, not a new interpretation of linkages in the picture.

H, N, F and S denote Hex, HexNAc, dHex and Neu5Ac in generic compositions. Source annotation zero counts are retained.

## Separate diagnostic evidence

Table S4_2 contains 10 × 8 selected MS2 signature-ion intensities for minor mucin-type O-glycans. It is preserved in diagnostic-ms2-evidence.json, including eight quantitative zeros and their NA representation. It is not part of matrix-specs.json: fragment intensities are not whole-glycan relative abundance, this is a diagnostic subset rather than a complete O-glycome, and experiment/replicate identity is unspecified. Original diagrams are preserved in the XLSX; their composition/structure fields are not transcribed into glycome objects. The article notes low-abundance and possible serum-contamination explanations for some core 3/4 assignments.

## License

No explicit reuse license for the supplemental workbook was located. The PMC author-manuscript notice does not establish a Creative Commons license for the supplement. GlycoPOST repository terms should not be assigned to a workbook obtained from the paper. Metadata records this unresolved status; do not silently label these source data with the package license.

## Reproduction

The frozen source, registry responses, parsed structures and visual-review evidence needed for offline reproduction are included in this directory. No external download is required. Source paths in matrix-specs.json are relative to the repository root and point to mmc5.xlsx. The original vector drawings are inside that workbook; separate rendered images are not required.

Requirements:

- Python 3 and openpyxl for workbook checks. The other Python imports use the standard library.
- R and the package's build dependencies: glyexp, glyrepr, jsonlite, readxl, S4Vectors and SummarizedExperiment.
- Optional registry re-parsing additionally requires glyparse. The recorded parser versions are glyparse 0.8.1 and glyrepr 1.1.0.

To validate the frozen quantitative data without regenerating the specifications, run from the repository root:

```sh
python data-raw/GPST000125/validate_extraction.py
```

To reproduce the evidence and specifications, first copy this directory to a working location, because these scripts overwrite their derived JSON outputs. Run the following scripts in order from that copy:

```sh
python audit_annotations.py
python review_original_workbook.py
python build_specs.py
python validate_extraction.py
```

The original XLSX hash is pinned. review_original_workbook.py recounts the native DrawingML symbols for the six recorded visual-review decisions; those decisions apply only to this exact workbook version. The scripts preserve all primary abundance measurements and the unresolved N feature 17 annotation.

To rebuild the three source-panel GlycomicSE objects, run from the repository root:

```sh
R --vanilla -s -f data-raw/GPST000125/GPST000125-build.R
```

This uses the shared data-raw/_shared/scripts/build-matrix-specs.R helper, which verifies the XLSX checksum and its measurement cells before building the objects. It writes the source-panel objects and updates the build inventory. Package-wide merging and documentation are handled by the repository's full build workflow.

validation.json records the quantitative checks. Its R-builder summary records the separate object validation performed for this source snapshot; validate_extraction.py does not itself execute R. Re-run the R command above to check current object construction.

For an optional online refresh, run fetch_evidence.py only in a separate working copy. It retrieves the public supplement and current GlyTouCan responses, and can replace files in that copy. parse_glytoucan.R takes the data directory as its first trailing argument; GLYHUB_GLYPARSE_LIBRARY can select an additional installed library. For example:

```sh
R --vanilla -s -f parse_glytoucan.R --args .
```

Current registry data may differ from the frozen responses. Compare the outputs, verify the workbook hash, and review annotation_audit.json and original-workbook-review.json before adopting any refreshed results.
