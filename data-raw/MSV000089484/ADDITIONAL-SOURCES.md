# MSV000089484 original author quantitative source assets

These entries use `glyhub_load(dataset, kind="raw")` to return an unchanged source file. "raw" denotes source-file storage, **not instrument-raw intensity**. Curated SE conversion is not performed; source record grain, alternative metrics and source missing/sentinel values remain intact.

Read `source-assets-additional.json` for exact columns, scale, experimental design, limitations, licence, URLs and SHA256. Reproduce with the listed original files in one input directory:

```r
# From repository root, in a shell:
# Rscript data-raw/MSV000089484/build-additional-sources.R <source-directory> <cache>
```

## `glyhub_MSV000089484_IgG_SourceQuantitativeRecords`

[Original source](https://media.springernature.com/original/springer-static/esm/art%3A10.1038%2Fs41467-022-35172-x/MediaObjects/41467_2022_35172_MOESM4_ESM.xlsx) · [Study](https://doi.org/10.1038/s41467-022-35172-x)

Original author Intensity measurements, untransformed

[{'sample_id': '20220323_IgG_Glycopeptide_1ug_Quant_test-rep1', 'age': None, 'sex': None, 'individual_donor_id': None, 'independence': 'technical acquisition, not independent clinical subject', 'source_group_code': 'human_IgG_1ug', 'source_technical_replicate': '1', 'clinical_group': None, 'material': 'human IgG glycopeptide 1ug technical quantification validation; no donor metadata supplied'}, {'sample_id': '20220323_IgG_Glycopeptide_1ug_Quant_test-rep2', 'age': None, 'sex': None, 'individual_donor_id': None, 'independence': 'technical acquisition, not independent clinical subject', 'source_group_code': 'human_IgG_1ug', 'source_technical_replicate': '2', 'clinical_group': None, 'material': 'human IgG glycopeptide 1ug technical quantification validation; no donor metadata supplied'}, {'sample_id': '20220323_IgG_Glycopeptide_1ug_Quant_test-rep3', 'age': None, 'sex': None, 'individual_donor_id': None, 'independence': 'technical acquisition, not independent clinical subject', 'source_group_code': 'human_IgG_1ug', 'source_technical_replicate': '3', 'clinical_group': None, 'material': 'human IgG glycopeptide 1ug technical quantification validation; no donor metadata supplied'}]

pGlycoQuant source spectrum/quant-record rows, not independent glycopeptide species

## Source grain

pGlycoQuant source spectrum/quant-record rows, not independent glycopeptide species
