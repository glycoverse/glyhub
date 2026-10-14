# Complete supplementary workbook

The primary 45 × 134 quantitative workbook, reviewed sample metadata and clinical source-cell snapshot are versioned here. The original `mmc4.xlsx` is 20,679,775 bytes and is retained separately from Git. Its full bytes are not present in this PR.

Public original archive:
https://www.ebi.ac.uk/europepmc/webservices/rest/PMC12794580/supplementaryFiles

Unchanged XLSX SHA-256:
`30931f27058092c02d531a8ae1650b5c81181b79e3ac3cf35904b23ee937f910`

From the repository root, `source("data-raw/GPST000599/ensure-source.R")` downloads the public archive without credentials, selects the sole `mmc4.xlsx` member and verifies the SHA-256 before copying it to this directory. The complete build invokes this step before the source manifest checks. An existing mismatching file is left untouched and produces an error. Download, archive-layout or checksum errors stop the build; absence is never interpreted as a negative data result. SHA verification uses the CRAN package digest.

`clinical-source-snapshot.json` preserves the original Table S1 cells, including source missing-value strings and dates. `clinical-source-mapping.json` records the 134 sample-to-subject/date/column mappings. These are reviewable factual snapshots of the original source, not a replacement presented as the original XLSX. `validate-clinical-snapshot.py` verifies the stored clinical mapping independently; when the original workbook is available it also verifies its hash and source cells.

The large workbook is not split or replaced with a reconstructed spreadsheet. Source licensing and attribution remain those recorded for the original publication. File storage management does not change any assay, glycan annotation or clinical observation.

Anonymous end-to-end recovery was verified on 14 October 2026. The archive download was 222.1 MB; the extracted 20,679,775-byte XLSX matched the SHA-256 above. The default timeout is at least 1,800 seconds because this endpoint bundles the entire article supplement, not just the workbook. A separate negative test confirmed that an existing mismatching file is preserved and produces an error.
