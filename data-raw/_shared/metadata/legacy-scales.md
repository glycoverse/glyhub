# Reviewed legacy abundance scales

`inst/extdata/legacy-scales.tsv` is a fixed migration registry for the current
`data-v0.1.0` resources. Match both dataset identifier and SHA-256. Never copy a
scale to a replacement resource merely because its identifier is unchanged.

The October 2026 resources predate glyexp 0.19's required `metadata$scale` field.
For example, the released `glyhub_GPST000738_N_B4GalT1.rda` was independently
downloaded and its SHA-256 verified as
`073eb107e51c8d8e9b42bfbe41f9cfbd54deaedae28005a72fef217ae194bf80`.
Its serialized metadata records glyexp 0.17.0 and contains no `scale` field.

The registry assigns 94 resources `raw` from their documented linear assay
quantities and current build paths, one resource `log2`, and leaves two
unresolved (`NA`). `raw` describes linear coordinates; it does not assert that
measurements are unnormalized, absolute, unbiased, or suitable for every
analysis. Percentages, fractions, ratios, peak areas, and linearized quantities
remain linear. Non-negative values alone are not evidence of scale.

## Cases requiring particular care

- `glyhub_PXD065283_N_DiscoverySelected` is `log2`. Its current hash is
  `af4377e6aa7f6b4ad38f9fadc2e386b0bef35686511d47c3219b6ff5078513f7`.
  `data-raw/PXD065283/convert-hcc.R` explicitly retains source median-normalized,
  log2-transformed, normally imputed quantities without exponentiation.
- The eight CPTAC assays are `raw`: `data-raw/CPTAC/convert.R` computes `2^raw`.
  Their retained `raw_abundance_scale = "log2"` describes provenance matrices,
  not the actual assay.
- `glyhub_PXD052447_N_Tissues` is `raw` in the current manifest. Its receipt at
  `data-raw/PXD052447/glyhub_PXD052447_N_Tissues-receipt.json` pins hash
  `b04a942f1404a456cc4d409caddd1ab915aa91076f7dfd3f6025ac4fd482b3f1`
  to `Mouse_tissues_N_glyco_psm.tsv`. The active `build-raw-psm.R` and
  `convert-raw-psm.R` preserve untransformed PSM reporter intensities. The old
  VSN adapter in `_shared/scripts/noncptac/convert.R` is not this asset's build
  path and must not be used to label it `logx`.
- GPST000578 repeatability retains linear glycan intensity. Its description of
  a log2 plot axis does not mean the stored assay was log2-transformed.

The remaining reviewed linear quantities are documented in
`inst/extdata/catalog-metadata.tsv`, their individual `R/data.R` help sections,
and corresponding `data-raw` build inputs. The shared matrix builder copies
source cells, optionally marking source zero values missing; it does not
log-transform or infer an abundance scale.

## Unresolved resources

- `glyhub_GPST000601_N_glycopeptides`: the source says "source grouped abundance
  (relative scale)" and preserves `Abundances (Grouped)` headings. The retained
  source description does not explicitly establish the transformation history.
- `glyhub_GPST000667_N`: the source says "GlycoGenius abundance". The available
  method description names the software but does not explicitly establish the
  output scale.

Both are plausibly linear, but this registry deliberately does not infer that.
Confirm source transformation history before replacing `NA`. Until then,
loading a legacy object without its own scale fails with an explicit message.
An object's existing scale is never overwritten, including an explicitly
invalid value: ordinary glyexp validity checks still apply.

Migration only changes the returned object's missing metadata field. It does
not transform assays, overwrite caches, change manifest hashes, rebuild assets,
or publish data. Future asset builds should write explicit scale metadata.
