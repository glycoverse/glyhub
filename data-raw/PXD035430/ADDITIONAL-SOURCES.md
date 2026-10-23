# PXD035430 original author quantitative source assets

These entries use `glyhub_load(dataset, kind="raw")` to return an unchanged source file. "raw" denotes source-file storage, **not instrument-raw intensity**. Curated SE conversion is not performed; source record grain, alternative metrics and source missing/sentinel values remain intact.

Read `source-assets-additional.json` for exact columns, scale, experimental design, limitations, licence, URLs and SHA256. Reproduce with the listed original files in one input directory:

```r
# From repository root, in a shell:
# Rscript data-raw/PXD035430/build-additional-sources.R <source-directory> <cache>
```

## `glyhub_PXD035430_BOCTAG_SourceProteinGroups`

[Original source](http://ftp.pride.ebi.ac.uk/pride/data/archive/2022/09/PXD035430/proteinGroups_BOCTAG.txt) · [Study](https://doi.org/10.1038/s41467-022-33854-0)

Original MaxQuant Intensity L/H per experiment (SILAC) or Intensity per acquisition, linear. Sourcezero preserved, no new normalization/imputation. Ratios and global aggregateIntensity not assay.

PXD035430 exactheaders17H_20L_R1..3 and17L_20H_R1..3 (12isotope-channelmeasurements); sample workbookdefinesZL17engineeredBOCTAG andZL20mock; PXD0354378pairedSILACexperiments16channels exactDMSO/GalNAlk6/engineered cellcodes; PXD03543810cocultureexperimentcolumns explicitlyhumanMCF7/murine4T1mock/BOCTAG+substrate, mqparretained. Do not countlabelswaps as independent subjects.

035430mqparHTTP403 stopped; sample workbook ordinary503 resolvedHTTPS with12272bytes expected. Fullsourceassets eligible, granularcuratedsamplemapping can beheld.

## Source grain

Protein groups as source IDs/id, contaminants/decoys retained flagged rather than silently removed; enriched glycoprotein abundance not site-specific intactglycopeptide.
