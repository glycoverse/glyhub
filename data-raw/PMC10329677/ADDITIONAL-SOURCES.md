# PMC10329677 original author quantitative source assets

These entries use `glyhub_load(dataset, kind="raw")` to return an unchanged source file. "raw" denotes source-file storage, **not instrument-raw intensity**. Curated SE conversion is not performed; source record grain, alternative metrics and source missing/sentinel values remain intact.

Read `source-assets-additional.json` for exact columns, scale, experimental design, limitations, licence, URLs and SHA256. Reproduce with the listed original files in one input directory:

```r
# From repository root, in a shell:
# Rscript data-raw/PMC10329677/build-additional-sources.R <source-directory> <cache>
```

## `glyhub_PMC10329677_IgGOrbitrap_SourceQuantification`

[Original source](https://www.ebi.ac.uk/europepmc/webservices/rest/PMC10329677/supplementaryFiles) · [Study](https://doi.org/10.1038/s41467-023-39699-5)

Original GlycanFinder Area, comparator pGlyco3 MonoArea. Preserve blank missing area and zero; corrected -1 alternatives not selected.

Original commercial human IgG IgG1-4 enriched tryptic glycopeptides, measured separately Orbitrap and timsTOF under PXD039787; Source File/RawName exact acquisition mapping in table. No assumed biological replicates.

MOESM5 yeast/MOESM6 mouse/MOESM9 HGI are reanalysis of previously deposited datasets, exclude as duplicate original source; do not align GPSMs artificially across instruments or engines.

## `glyhub_PMC10329677_IgGTimsTOF_SourceQuantification`

[Original source](https://www.ebi.ac.uk/europepmc/webservices/rest/PMC10329677/supplementaryFiles) · [Study](https://doi.org/10.1038/s41467-023-39699-5)

Original GlycanFinder Area, comparator pGlyco3 MonoArea. Preserve blank missing area and zero; corrected -1 alternatives not selected.

Original commercial human IgG IgG1-4 enriched tryptic glycopeptides, measured separately Orbitrap and timsTOF under PXD039787; Source File/RawName exact acquisition mapping in table. No assumed biological replicates.

MOESM5 yeast/MOESM6 mouse/MOESM9 HGI are reanalysis of previously deposited datasets, exclude as duplicate original source; do not align GPSMs artificially across instruments or engines.

## Source grain

Author GPSM/precursor rows in full source workbook, alternative search-engine outputs kept as alternatives not independent datasets. Preserve site/protein ambiguity.
