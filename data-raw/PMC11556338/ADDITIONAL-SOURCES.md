# PMC11556338 original author quantitative source assets

These entries use `glyhub_load(dataset, kind="raw")` to return an unchanged source file. "raw" denotes source-file storage, **not instrument-raw intensity**. Curated SE conversion is not performed; source record grain, alternative metrics and source missing/sentinel values remain intact.

Read `source-assets-additional.json` for exact columns, scale, experimental design, limitations, licence, URLs and SHA256. Reproduce with the listed original files in one input directory:

```r
# From repository root, in a shell:
# Rscript data-raw/PMC11556338/build-additional-sources.R <source-directory> <cache>
```

## `glyhub_PMC11556338_HGTCs_SourceQuantification`

[Original source](https://www.ebi.ac.uk/europepmc/webservices/rest/PMC11556338/supplementaryFiles) · [Study](https://doi.org/10.1093/nsr/nwae341)

Original linear TMT reporter intensity, 5zero preserved, no missing/negative; no new normalization.

TMT126 cytoplasm control;127 cytoplasm100uM H2O2;128 cytoplasm100mM H2O2;129 nucleus control;130 nucleus100uM;131 nucleus100mM. HeLa metabolic GalNAz48h then H2O2 1h. PEAKSOnlineXpro1.6 MS2reporters; authors sum same-peptide reporters.

Article says2 experiments but only6 labelled channel quantities in author table with no explicit batch column. Preserve full source asset, curated SE hold pending replicate provenance. Do not invent12 biological samples. TableS14 selected differential176 proteins not complete.

## Source grain

Original author quantitative record grain, not independently aligned features
