# Brain N-glycan quantification from Nakano et al. supplemental PDF

## Verified source

- Filename: `152506_2_supp_372524_pvkzw0.pdf`, 18 pages.
- Title: *Bisecting GlcNAc is a general suppressor of terminal modification of N-glycan*; Miyako Nakano et al.
- Quantitative source: printed PDF page **4**, **Supplemental Figure S2C**. This is a numerical table embedded as an image, not a digitized plot.
- Tissue and assay attribution: caption on pages **8-9** explicitly identifies **mouse brain N-glycans**, **Mgat3+/+** and **Mgat3-/-**, **aminoxy tandem tag 6 (TMT6)** and **LC-ESI-MS**. The front page distinguishes Supplemental Table S2 as a separate Excel file; Supplemental Table S1 on page 18 contains primer sequences.
- The original embedded page-4 image is 1827 x 2427 pixels, object 34 / Im3. Its PDF bounding box is x=73.5039..524.5039, y=130.2882..728.7882 points (PDF bottom-left coordinates). From the top, y=113.1016..711.6016. The image was reviewed at its original resolution after lossless rotation.
- PDF SHA-256: `a9393edfc7c67eb19e6d5e59919813fd18e4369489744e84950cbca048b1df72`.

## Data delivered

`brain_s2c_features.csv` and `.json` preserve all **51 printed chromatographic features** across **30 composition groups**, including every lettered isomer label, with **2 condition columns**. They contain:

- Original feature labels (1, 2a, 2b, ..., 30).
- Source-observed mass under its original M+3H or M+2H heading, calculated M+H, delta mass, source composition, and EIC interval. Shared cells are expanded onto the subfeatures within that group.
- Exact printed EIC peak intensities for WT and KO, with **zero retained as zero**, never silently imputed or changed to missing.
- Exact printed relative-abundance numbers (including source formatting of the isolated `0` versus `0.0`).
- Explicit derived total composition counts: source Hex + 3 core Man; source HexNAc + 2 core GlcNAc; source deoxyhexose and NeuAc unchanged. These are composition counts only, not a reconstruction of linkage/isomeric structure.

The `WT_peak_intensity` and `KO_peak_intensity` fields form the 51 x 2 intensity panel; the separately named relative-abundance fields retain the different-scale source percentages.

## Scale and validation

The table heading is **peak intensity in EIC**. It provides no additional physical measurement unit. It is peak intensity, not integrated peak area, absolute concentration, or TMT reporter-ion intensity.

All 102 relative-abundance values match:

`100 * feature EIC peak intensity / that condition's SUM of High Man`

rounded to one decimal. The high-mannose group consists of 1, 2a, 2b, 3 and 4.

| Total | WT Mgat3+/+ | KO Mgat3-/- |
|---|---:|---:|
| High Man | 979,000 | 745,500 |
| Without High Man | 908,230 | 1,017,338 |
| All listed features | 1,887,230 | 1,762,838 |

Every total exactly matches the printed table. Thus relative abundance **is not percent of total glycans** and can sum to more than 100. Source aggregate percentages use unrounded intensity sums: WT non-high-Man 92.8 and overall 192.8; KO 136.5 and 236.5. Summing the rounded individual WT percentages instead gives 92.9 and 192.9, which is expected rounding behavior, not a transcription discrepancy.

Two separate visual transcriptions of the numeric columns were compared: **all 51 labels and 204 numeric cells match**. Tesseract OCR was also generated as a non-authoritative cross-check; it cannot reliably distinguish the merged-cell layout and must not be used alone. `validation_primary.json` and `validation_independent.json` document the checks; `independent_s2c_numeric.csv` retains the independent transcription.

## Scientific and provenance limits

- This is the **complete printed annotated S2C table**, not an asserted complete untargeted peak list or all raw detected features.
- The PDF has no GPST accession, raw filenames, animal IDs, sex, biological replicate numbers, or pooling metadata. Its two condition columns must not be asserted to mean two individual mice. GPST000027 and raw-file association require the separately verified repository record.
- Do not collapse the 51 chromatographic features to 30 compositions without a declared lossy aggregation. In particular 9a/9b illustrate different structures sharing a composition and mass.
- Do not align brain and kidney feature rows only by composition or local numbered labels. Same paper, N-glycan class, and instrument method do not establish the same resolved features or interchangeable sampling coverage. A study-level resource can retain separate tissue-specific matrices linked by the publication and accession metadata.
- No figures were digitized and no missing intensities, retention times, absolute units, or glycan linkage structures were invented.

## Repository linkage and reuse metadata

The official GPST000027 record title is **GnT3 KO mouse brain**, with this publication's title and PMID 31375533. Its file list contains exactly the following two public raw files, both associated with sample-preparation profile S0000000016:

- 15071834_WT_TMT6_126.RAW (f_0000000563), 26,444,876 bytes, checksum 84b8a016e88a25592b1973319b4d6b49.
- 15071835_GnT3KO_TMT6_127.RAW (f_0000000562), 25,374,756 bytes, checksum 6cc605f285e4b629170a5fd33baf20da.

These are **genotype-and-filename-derived candidate associations** for the WT and KO table columns. Neither the PDF nor the API gives an explicit table-column-to-run crosswalk. The main article's Fig. 1 caption reports three independent brain WT/KO pairs, whereas the published S2C table contains only two numerical columns and this accession contains two raw files. Do not turn this into an asserted biological n=1, fabricate the other replicate columns, or claim exact run identity beyond the available evidence.

Official API: https://glycopost.glycosmos.org/api/projects/GPST000027.0/files?limit=20&offset=0
Article: https://pmc.ncbi.nlm.nih.gov/articles/PMC6773561/
DOI: https://doi.org/10.1074/mcp.RA119.001534

The copied Crossref article record gives a **CC BY 4.0** license for the version of record, starting 2020-09-19. The uploaded PDF itself has no separate license notice, and a supplement-specific license statement was not independently verified. Preserve this distinction rather than representing the PDF as carrying an explicit license notice. The exact relevant API entries and condensed provenance/license record accompany the extracted files.

Independent annotation review also checked all 30 composition groups and correct propagation across 51 rows: observed charge-column placement, observed/calculated masses, delta mass, composition strings, EIC intervals and derived composition counts all agree with the original image. No discrepancies were identified.

## Study object

The complete brain and kidney panels are stored in `glyhub_GPST000027_031_N` as a disjoint union: 338 source-specific features and six observations. Exactly 1,250 source cells are measured; 778 cross-panel combinations remain unmeasured and explicitly masked. This storage unification does not align peaks or establish numerical comparability between TMT6 brain and aminoxyTMT0 kidney intensities. The original panel data, row/column metadata, percentage scales and maps are recoverable from object metadata.

## External original files and reconstruction

The original PDF and kidney XLS are excluded from Git. Crossref records a CC BY 4.0 license for the article version of record, but a separate supplement-specific redistribution declaration has not been verified. The reviewed quantitative mappings, original-cell provenance, file hashes and attribution are retained; the package code license does not relicense the sources.

A clean source rebuild requires the lawfully obtained originals at these exact paths:

- `data-raw/GPST000027/152506_2_supp_372524_pvkzw0.pdf`: SHA-256 `a9393edfc7c67eb19e6d5e59919813fd18e4369489744e84950cbca048b1df72`.
- `data-raw/GPST000031/152506_2_supp_372529_pvkzs0.xls`: SHA-256 `854f238cc3507723d095d810bb6b8e40f6d21c98ebb8a1d51c2f08429e2e7ad2`.

`ensure-source.R` checks both originals before the expansion source checks. No automatic recovery is claimed: on 2026-10-16 the official Europe PMC supplementary-files API for PMC6773561 returned `Article with id PMC6773561 is not open access one`. The article's Crossref license evidence and this repository availability result are different kinds of evidence and are not conflated. A missing or changed original stops reconstruction with an explicit error. Loading the distributed RDA does not require the original files.
