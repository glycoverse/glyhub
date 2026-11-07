# PXD072047 original author quantitative source assets

These entries use `glyhub_load(dataset, kind="raw")` to return an unchanged source file. "raw" denotes source-file storage, **not instrument-raw intensity**. Curated SE conversion is not performed; source record grain, alternative metrics and source missing/sentinel values remain intact.

Read `source-assets-additional.json` for exact columns, scale, experimental design, limitations, licence, URLs and SHA256. Reproduce with the listed original files in one input directory:

```r
# From repository root, in a shell:
# Rscript data-raw/PXD072047/build-additional-sources.R <source-directory> <cache>
```

## `glyhub_PXD072047_Retina_SourcePrecursorRecords`

[Original source](prd_ascp@fasp.ebi.ac.uk:pride/data/archive/2026/03/PXD072047/Original_proteomics_quantification.tsv) · [Study](https://doi.org/10.1172/JCI195048)

Precursor.Quantity original linear author quantity; Precursor.Normalised alternative retained. Protein-group repeated summaries not aggregated anew.

Sample_information.xlsx explicitly joins12of16Run to genotype/diabetes4groups3rep. FourRuns03,05,12,15 absentmetadata remain unknown. No source rows dropped; no inferred genotype from runnumber.

Raw sourceasset eligible; curatedSE hold incomplete4run samplemap.591MBsource needs appropriate externalasset storage, no truncatedpreview.

## Source grain

Original765368precursor×run longrows, exact Run+Precursor.Id unique; complete16acquisitions; sWGA-enriched proteins but ordinary tryptic peptides do not establish O-GlcNAc sites.
