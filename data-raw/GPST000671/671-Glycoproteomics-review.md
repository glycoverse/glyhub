# Supplementary File 5 glycoproteomics curation

Input: `42003_2026_10759_MOESM8_ESM.xlsx`, MD5 `63ed3fe91bed0184a6dbca2ac7be48f0`.
Paper: https://doi.org/10.1038/s42003-026-10759-y

All ten `Glycoforms_Org_*` and `Glycoforms_Sec_*` sheets are included. Rows with protein identity after header row 4 are molecular source records; unrelated summary material to the right of column W is not part of the assay. The independent workbook reread checked all 7,692 molecular rows and all 176,916 A:W cells against the pinned row-preserving extraction.

The main assay is F:N, the author's site-normalized proportions. O:W unnormalized intensities are retained separately in the pinned original and validated source extraction. No derivatives such as fold changes, p-values or desialylation scores are added as observations. Author source Concat equals Protein + site + glycan in every molecular row.

Final feature unions:
- N: 3,609 exact protein/site/glycan triplets × 90 observations.
- O: 253 exact protein/site/glycan triplets × 90 observations, comprising 140 S-site and 113 T-site feature identities.

No within-source-sheet duplicate triplets occur. All observed site strings are single N/S/T + integer assignments. N and O remain separate. There are 163 actual quantitative zeros in N and 7 in O; these become NA through the common builder. Source missing cells (25 N, 3 O) are distinct from absent-panel union cells (258,831 N, 19,521 O). The source-coverage mask and source-cell mappings preserve the distinction.

Three biologically independent replicates per condition follow the paper's TMT-methods statistical statement. Replicate numbers 1–3 encode source-column order within a condition; they do not assert pairing between different time points or compartments. Original TMT channel assignments remain recorded because channels change across time. Org denotes organelle protein fraction, Sec denotes secreted protein fraction. Exposure is mock, PR8 (H1N1), or x31 (H3N2) at 0, 6, 12, 18 and 24 hours post infection.

Protein organisms are parsed from explicit source OS/OX descriptions. Human, bovine and both influenza strain assignments remain included, with row-level organism annotations. Human A549 describes the culture host, not every detected protein. Explicit Phospho and Sulfo composition tokens remain phosphate and sulfate respectively; no structure is inferred. Source site localization and protein assignments are preserved, not independently revalidated from raw MS.

Rebuild with `671-Glycoproteomics-build.R`. It intentionally remains separate from the accession's released-glycomics build script and specs.
