# PXD011063 original quantitative source assets

Load with `glyhub_load(dataset, kind="raw")`. This returns an unchanged source file, not instrument-raw data or a curated SE. SHA256, licences, mapping, original scale and limitations are in `source-assets-additional.json`.

Reproduce from the listed original files, preserving the relative directory names:

```sh
Rscript data-raw/PXD011063/build-additional-sources.R <source-directory> <cache>
```

## `glyhub_PXD011063_O_TrueT_LibraryBenchmarkSource`

[Original source](https://ftp.pride.ebi.ac.uk/pride/data/archive/2019/11/PXD011063/20180430_Serum_ShortJacalin_4h_Cell_T_LB_Report.xls) · [Study](https://doi.org/10.1038/s41592-019-0504-x)

Original DIA method/negative-control library-search records; FakeT hits are not asserted biological glycoforms. Do not align, aggregate or treat library alternatives as independent cohorts.

native author Spectronaut intensity/quantity columns; no conversion or aggregation

One common source acquisition processed against alternative TrueT and FakeT libraries; not two biological samples.

True and deliberately FakeT library reports share ONE acquisition. Do not interpret FakeT candidates as validated biological glycofeatures, do not create two cohorts. Historical 6xR_deSA source not reopened.

## `glyhub_PXD011063_O_FakeT_LibraryBenchmarkSource`

[Original source](https://ftp.pride.ebi.ac.uk/pride/data/archive/2019/11/PXD011063/20180430_Serum_ShortJacalin_4h_Cell_FakeT_LB_Report.xls) · [Study](https://doi.org/10.1038/s41592-019-0504-x)

Original DIA method/negative-control library-search records; FakeT hits are not asserted biological glycoforms. Do not align, aggregate or treat library alternatives as independent cohorts.

native author Spectronaut intensity/quantity columns; no conversion or aggregation

One common source acquisition processed against alternative TrueT and FakeT libraries; not two biological samples.

True and deliberately FakeT library reports share ONE acquisition. Do not interpret FakeT candidates as validated biological glycofeatures, do not create two cohorts. Historical 6xR_deSA source not reopened.
