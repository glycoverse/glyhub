# PXD057512 original quantitative source assets

Load with `glyhub_load(dataset, kind="raw")`. This returns an unchanged source file, not instrument-raw data or a curated SE. SHA256, licences, mapping, original scale and limitations are in `source-assets-additional.json`.

Reproduce from the listed original files, preserving the relative directory names:

```sh
Rscript data-raw/PXD057512/build-additional-sources.R <source-directory> <cache>
```

## `glyhub_PXD057512_PE_DGP_SourceQuantification`

[Original source](https://www.iprox.cn/page/project.html?id=IPX0010057000) · [Study](https://doi.org/10.1038/s41467-025-63075-0)

Full enriched deglycopeptide export rows, some peptides lacklocalizeddeamidation; preserve source peptide/AScore/PTM/protein group without declaring all rows certain glycosites.

Original linear author processed per-sample intensity/area, sourcezeros and blankmissing retained; no new normalization/imputation.

EVGpro magneticnanochain enrichedbiofluidEV samples:CSF,pleuraleffusion,saliva,urine. Eachseparatecomplete2acquisitiontable; Sample1/2exactlabels andSourceFilecolumnretain; do not assumeindependent donors or align acrossbiofluids.

Fourcompleteindependent depositedtables validated; otherexperiments available inlargeauthorsearcharchives stillpending/no fabricated completewhole-studyclaim. NCNDpublisherworkbooks not redistributed underCC0.

## `glyhub_PXD057512_URINE_DGP_SourceQuantification`

[Original source](https://www.iprox.cn/page/project.html?id=IPX0010057000) · [Study](https://doi.org/10.1038/s41467-025-63075-0)

Full enriched deglycopeptide export rows, some peptides lacklocalizeddeamidation; preserve source peptide/AScore/PTM/protein group without declaring all rows certain glycosites.

Original linear author processed per-sample intensity/area, sourcezeros and blankmissing retained; no new normalization/imputation.

EVGpro magneticnanochain enrichedbiofluidEV samples:CSF,pleuraleffusion,saliva,urine. Eachseparatecomplete2acquisitiontable; Sample1/2exactlabels andSourceFilecolumnretain; do not assumeindependent donors or align acrossbiofluids.

Fourcompleteindependent depositedtables validated; otherexperiments available inlargeauthorsearcharchives stillpending/no fabricated completewhole-studyclaim. NCNDpublisherworkbooks not redistributed underCC0.

## `glyhub_PXD057512_SALIVA_DGP_SourceQuantification`

[Original source](https://www.iprox.cn/page/project.html?id=IPX0010057000) · [Study](https://doi.org/10.1038/s41467-025-63075-0)

Full enriched deglycopeptide export rows, some peptides lacklocalizeddeamidation; preserve source peptide/AScore/PTM/protein group without declaring all rows certain glycosites.

Original linear author processed per-sample intensity/area, sourcezeros and blankmissing retained; no new normalization/imputation.

EVGpro magneticnanochain enrichedbiofluidEV samples:CSF,pleuraleffusion,saliva,urine. Eachseparatecomplete2acquisitiontable; Sample1/2exactlabels andSourceFilecolumnretain; do not assumeindependent donors or align acrossbiofluids.

Fourcompleteindependent depositedtables validated; otherexperiments available inlargeauthorsearcharchives stillpending/no fabricated completewhole-studyclaim. NCNDpublisherworkbooks not redistributed underCC0.

## `glyhub_PXD057512_CSF_DGP_SourceQuantification`

[Original source](https://www.iprox.cn/page/project.html?id=IPX0010057000) · [Study](https://doi.org/10.1038/s41467-025-63075-0)

Full enriched deglycopeptide export rows, some peptides lacklocalizeddeamidation; preserve source peptide/AScore/PTM/protein group without declaring all rows certain glycosites.

Original linear author processed per-sample intensity/area, sourcezeros and blankmissing retained; no new normalization/imputation.

EVGpro magneticnanochain enrichedbiofluidEV samples:CSF,pleuraleffusion,saliva,urine. Eachseparatecomplete2acquisitiontable; Sample1/2exactlabels andSourceFilecolumnretain; do not assumeindependent donors or align acrossbiofluids.

Fourcompleteindependent depositedtables validated; otherexperiments available inlargeauthorsearcharchives stillpending/no fabricated completewhole-studyclaim. NCNDpublisherworkbooks not redistributed underCC0.
