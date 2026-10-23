# PMC10550946 original author quantitative source assets

These entries use `glyhub_load(dataset, kind="raw")` to return an unchanged source file. "raw" denotes source-file storage, **not instrument-raw intensity**. Curated SE conversion is not performed; source record grain, alternative metrics and source missing/sentinel values remain intact.

Read `source-assets-additional.json` for exact columns, scale, experimental design, limitations, licence, URLs and SHA256. Reproduce with the listed original files in one input directory:

```r
# From repository root, in a shell:
# Rscript data-raw/PMC10550946/build-additional-sources.R <source-directory> <cache>
```

## `glyhub_PMC10550946_Gp1bDigest_SourceQuantification`

[Original source](https://www.ebi.ac.uk/europepmc/webservices/rest/PMC10550946/supplementaryFiles) · [Study](https://doi.org/10.1038/s41467-023-41756-y)

Original extracted-ion chromatogram area under curve, linear, ND = not detected (per workbook Legend). Preserve ND as missing and zeros as zero. No author transformation reported.

SmE, IMPa, OgpA, Trypsin respective enzyme-digest runs, not biological replicates. +Sia is separate sialidase protocol, +PNGase PNGaseF protocol. MOESM10 TIM1 and MOESM11 TIM4 single combined glycoprotease AUC profiling source; retain source files if exact source-run allocation unresolved.

MOESM4 C1-INH has malformed original quantity 1.43+E07: retain source only, do not silently repair. MOESM6/8/9 YES/NO detection sheets are not abundance. Use complete source-table rows listed in validation, excluding formatting-only padding.

## `glyhub_PMC10550946_TIM3Digest_SourceQuantification`

[Original source](https://www.ebi.ac.uk/europepmc/webservices/rest/PMC10550946/supplementaryFiles) · [Study](https://doi.org/10.1038/s41467-023-41756-y)

Original extracted-ion chromatogram area under curve, linear, ND = not detected (per workbook Legend). Preserve ND as missing and zeros as zero. No author transformation reported.

SmE, IMPa, OgpA, Trypsin respective enzyme-digest runs, not biological replicates. +Sia is separate sialidase protocol, +PNGase PNGaseF protocol. MOESM10 TIM1 and MOESM11 TIM4 single combined glycoprotease AUC profiling source; retain source files if exact source-run allocation unresolved.

MOESM4 C1-INH has malformed original quantity 1.43+E07: retain source only, do not silently repair. MOESM6/8/9 YES/NO detection sheets are not abundance. Use complete source-table rows listed in validation, excluding formatting-only padding.

## `glyhub_PMC10550946_TIM1AUC_SourceQuantification`

[Original source](https://www.ebi.ac.uk/europepmc/webservices/rest/PMC10550946/supplementaryFiles) · [Study](https://doi.org/10.1038/s41467-023-41756-y)

Original extracted-ion chromatogram area under curve, linear, ND = not detected (per workbook Legend). Preserve ND as missing and zeros as zero. No author transformation reported.

SmE, IMPa, OgpA, Trypsin respective enzyme-digest runs, not biological replicates. +Sia is separate sialidase protocol, +PNGase PNGaseF protocol. MOESM10 TIM1 and MOESM11 TIM4 single combined glycoprotease AUC profiling source; retain source files if exact source-run allocation unresolved.

MOESM4 C1-INH has malformed original quantity 1.43+E07: retain source only, do not silently repair. MOESM6/8/9 YES/NO detection sheets are not abundance. Use complete source-table rows listed in validation, excluding formatting-only padding.

## `glyhub_PMC10550946_TIM4AUC_SourceQuantification`

[Original source](https://www.ebi.ac.uk/europepmc/webservices/rest/PMC10550946/supplementaryFiles) · [Study](https://doi.org/10.1038/s41467-023-41756-y)

Original extracted-ion chromatogram area under curve, linear, ND = not detected (per workbook Legend). Preserve ND as missing and zeros as zero. No author transformation reported.

SmE, IMPa, OgpA, Trypsin respective enzyme-digest runs, not biological replicates. +Sia is separate sialidase protocol, +PNGase PNGaseF protocol. MOESM10 TIM1 and MOESM11 TIM4 single combined glycoprotease AUC profiling source; retain source files if exact source-run allocation unresolved.

MOESM4 C1-INH has malformed original quantity 1.43+E07: retain source only, do not silently repair. MOESM6/8/9 YES/NO detection sheets are not abundance. Use complete source-table rows listed in validation, excluding formatting-only padding.

## Source grain

Original observed glycopeptide sequence rows with source localized and unlocalized glycan annotations, charge, RT; not inferred unique structures.
