# Reviewed legacy abundance scales

`inst/extdata/legacy-scales.tsv` is a fixed migration registry for the current
`data-v0.1.0` resources. Match both dataset identifier and SHA-256. Never copy a
scale to a replacement resource merely because its identifier is unchanged.

The October 2026 resources predate glyexp 0.19's required `metadata$scale` field.
For example, the released `glyhub_GPST000738_N_B4GalT1.rda` was independently
downloaded and its SHA-256 verified as
`073eb107e51c8d8e9b42bfbe41f9cfbd54deaedae28005a72fef217ae194bf80`.
Its serialized metadata records glyexp 0.17.0 and contains no `scale` field.

The registry assigns 95 resources `raw` from their documented linear assay
quantities and current build paths, one resource `log2`, and leaves one
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

## GPST000667 source verification

The [original CSV](https://glycopost.glycosmos.org/data/GPST000667.0/N-glycan-identifications.csv)
identifies GlycoGenius abundance followed only by migration-time filtering. Its
SHA-256 is `e231c32a10354df8f5669f9489636d1f83926a8876da6e4cb9b2bf9cbba881c3`.
Its MD5 `2d29c14f297f1fe40a4e39f6ea1f35a1` matches the source spec. The
15,832-byte published RDA was also downloaded and matched the manifest hash
`995809ac07b328f6b31f0e62b6f65d3ccd542f7bb483789f89e1c487e2dc326f`;
its serialized provenance contains the same source URL and MD5.
The [study methods](https://doi.org/10.1016/j.mcpro.2026.101524) identify
GlycoGenius 1.3.1. The [software paper](https://www.nature.com/articles/s41467-025-65265-2)
defines peak abundance as area under the curve. Inspection of the published
[1.3.1 source archive](https://files.pythonhosted.org/packages/a8/ed/0abc9e316ecb1a136a2a7e8b66ae6b5bf4aa0314b95d1b1ee3cf5863d91b/glycogenius-1.3.1.tar.gz) confirms `Execution_Functions.py` writes AUC or AUC divided
by an internal-standard AUC to the composition abundance CSV, without a log
transform. This supports `raw` independently of the values' magnitude.

## Unresolved resource

- `glyhub_GPST000601_N_glycopeptides`: the source says "source grouped abundance
  (relative scale)" and preserves `Abundances (Grouped)` headings. The retained
  source description does not explicitly establish the transformation history.

This is plausibly linear, but this registry deliberately does not infer that.
Confirm source transformation history before replacing `NA`. Until then,
loading a legacy object without its own scale on glyexp 0.19 or later fails
with an explicit message. Older supported glyexp versions retain their existing
behavior because they do not require scale metadata.
An object's existing scale is never overwritten, including an explicitly
invalid value: ordinary glyexp validity checks still apply.

Migration only changes the returned object's missing metadata field. It does
not transform assays, overwrite caches, change manifest hashes, rebuild assets,
or publish data. Future asset builds should write explicit scale metadata.
