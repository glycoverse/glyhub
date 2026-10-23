# PMC12852849 original author quantitative source assets

These entries use `glyhub_load(dataset, kind="raw")` to return an unchanged source file. "raw" denotes source-file storage, **not instrument-raw intensity**. Curated SE conversion is not performed; source record grain, alternative metrics and source missing/sentinel values remain intact.

Read `source-assets-additional.json` for exact columns, scale, experimental design, limitations, licence, URLs and SHA256. Reproduce with the listed original files in one input directory:

```r
# From repository root, in a shell:
# Rscript data-raw/PMC12852849/build-additional-sources.R <source-directory> <cache>
```

## `glyhub_PMC12852849_NB4SampleTables_SourceQuantification`

[Original source](https://www.ebi.ac.uk/europepmc/webservices/rest/PMC12852849/supplementaryFiles) · [Study](https://doi.org/10.1038/s41467-025-68270-7)

Byologic5.4.10 MS1-based intactN-glycopeptide intensities after author score>150; untransformed per-sheet quantities with true sourcezeros, no missing/negative.

20original sample sheets:0nM,10nM,100nM,1uM,10uM arsenic trioxide eachreplicates1-4 NB4cells; do not align independent author row sets or pretend concentration levels are individual abundance.

Do not import phosphoproteome/proteome S27/S28 as glyco; other source tables mostly selected figures/contrasts. Complete NB4S26 is eligible, no invented join.

## Source grain

Proteinname/Nglycan site/Sequence/Glycans source rows per sample, author original unsynchronized run tables; raw sourceasset preserves all20sheets.
