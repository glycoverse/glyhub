# Non-CPTAC data sources and reproduction

Eight DQGlyco/Glyco-DIA objects are distributed in the existing `data-v0.1.0` release, based on explicit PRIDE project CC0 licenses. Five additional factual numerical objects are published at the user's explicit request after disclosure that source attachment or repository redistribution scope remains unresolved. Publication does not establish or grant a new license. Source numbers are preserved. See `publication-decisions.tsv` for the exact per-object decisions.

## Load

```r
devtools::load_all()
x <- glyhub_PXD052447_N_Tissues()
SummarizedExperiment::assay(x)
S4Vectors::metadata(x)$assay_scale
```

All these objects use catalog `kind = "curated"` to mean a standardized object; this does **not** mean its intensities were normalized, its confidence thresholds were changed, or every row is a confirmed biological glycopeptide. The separate catalog `kind = "raw"` still refers to existing CPTAC source archives.

## Source choices

| Dataset | Source rows × measurement columns | Assay scale |
|---|---:|---|
| `glyhub_PXD070547_N_HumanAtlas` | 57,884 × 219 | Source Skyline extracted-ion chromatogram quantification; raw relative signal |
| `glyhub_PXD052447_N_Solubility` | 89,115 × 18 | Deposited untransformed PSM-level TMT reporter intensities |
| `glyhub_PXD065283_N_QC` | 8,030 × 30 | Source linear MBR-derived glycosite/glycan quantities; upstream normalization not independently established |
| `glyhub_PXD065283_N_DiscoverySelected` | 1,038 × 140 | Source median-normalized, log2-transformed, normally imputed abundance; DE-selected features |
| `glyhub_PXD052447_N_TwoFF` | 91,409 × 18 | Deposited untransformed PSM-level TMT reporter intensities |
| `glyhub_PXD052447_N_Microbiome` | 160,699 × 18 | Deposited untransformed PSM-level TMT reporter intensities |
| `glyhub_PXD011063_O_Dilution` | 15,890 × 10 | Source FG.MS2TotalPeakArea; untransformed summed MS2 fragment chromatographic peak area |
| `glyhub_PXD052447_N_Tissues` | 205,904 × 18 | Deposited untransformed PSM-level TMT reporter intensities |
| `glyhub_PXD052447_N_PNGase` | 118,216 × 18 | Deposited untransformed PSM-level TMT reporter intensities |
| `glyhub_PXD052447_N_ProteinaseK` | 125,755 × 18 | Deposited untransformed PSM-level TMT reporter intensities |
| `glyhub_IPX0011099000_N_Brain` | 20,191 × 60 | Source untransformed chromatographic Area |
| `glyhub_PXD046637_N_Lung` | 39,079 × 165 | Deposited untransformed ion-level TMT reporter intensities; author software aggregated PSMs to ions |
| `glyhub_PXD011063_O_SerumSA` | 93,442 × 6 | Source FG.MS2TotalPeakArea; untransformed MS2 chromatographic peak area |

Reporter channels, library-analysis outputs, technical replicates and QC injections are not independent people or animals. Counts above are stored rows and columns, not unique molecular species or cohort sizes.

- DQGlyco: original deposited PSM reporter tables replace VSN/protein-corrected tissue outputs and NP40/SDS ratios. Preserve all source rows (including missing glycan annotation), reporter zeros and all 18 channels. Surface-accessibility and solubility experiments have only eight explicitly annotated channels; other roles remain unknown. PNGase and proteinase K are separate acquisitions identified by source Spectrum prefixes, not merged by repeated channel labels.
- Human atlas: choose `Raw expression matrix`, not normalized/KNN/ComBat alternatives. Thirty unmatched annotation IDs remain unknown. Source S means unspecified sialic acid, not necessarily NeuAc. Cohort age/sex summaries are not copied into individual samples.
- Mouse brain: preserve deposited Glyco-Decipher Area, including zeros and separate FAIMS voltages. Exactly 48 runs map to the published sample table, while 12 remain unclassified. Unassigned glycan mass offsets stay in source text.
- Lung: choose deposited ion reporter intensities. Fifteen batches × eleven channels do not map automatically to 132 clinical specimens. The authors' protein-corrected 12,480 × 132 matrix is retained in `metadata(x)$processed_clinical_alternative` with its scale and labels. No verified channel-to-patient or ion-to-processed-row map exists in inspected annotations; never join by row/column order. Upstream PSM-to-ion aggregation was performed by author software, not repeated here.
- Glyco-DIA dilution: use `FG.MS2TotalPeakArea`, with MS1 peak areas retained in metadata. Source decoys and confidence fields are preserved. Different libraries are alternative analyses. Do not infer glycan identity solely from rounded modification masses.
- Glyco-DIA serum SA: 93,442 precursor/library/decoy keys across six source runs; all 563,129 source associations are retained. Exactly 2,477 repeated associations share a quantitative cell only after exact MS2/MS1 equality is confirmed. The deSA CSV contains a repository-confirmed 28,672-byte NUL region and an unparsable quantitative record; it is excluded without deleting rows or inventing replacements. This object is not the complete SA/deSA comparison.
- HCC QC: source linear MBR-derived quantities are available, but upstream normalization has not been independently established. HCC clinical: only the verified 1,038-feature × 140-sample discovery table is included. It follows source missingness filtering, median normalization, log2, normal-distribution interpolation and differential-feature selection. It is **not** raw intensity, the complete 8,902-feature matrix, or the 60-person validation cohort. Do not use it for unbiased feature discovery/classifier evaluation. The earliest unnormalized clinical matrix was not available through the inspected sources; the QC table is a different experiment and cannot substitute for clinical samples.

`metadata(x)$raw_abundance` always means the original numerical matrix selected from the author source. It does not certify that a processed-only source was unprocessed. No inverse transformation is used to claim recovered raw intensity. Source blank/NA/NaN entries are retained as missing; numerical zeros are not given a guessed missingness interpretation.

Full machine-readable rationale, exact source URLs, hashes, known processing and unresolved points: [source-selection.json](source-selection.json), [source-selection.tsv](source-selection.tsv), [candidate-decisions.tsv](candidate-decisions.tsv). Source terms and code license are distinct. The PRIDE CC0 evidence applies to the deposited source files, not automatically to publisher supplementary workbooks. The five additional objects retain the unresolved source-license status; only outdated local-staging wording and publication metadata were updated.

## Rebuild and verify

Acquire the public files under the evidence layout recorded in the provenance, or reuse this task's `../evidence` directory. All required input paths and SHA-256 checksums are listed in [input-checksums.tsv](input-checksums.tsv). Build performs no network requests and only writes this checkout plus the supplied cache.

```sh
Rscript data-raw/noncptac/build.R ../evidence ../noncptac-cache
Rscript data-raw/noncptac/prepare-release.R
Rscript data-raw/noncptac/prepare-additional-release.R
Rscript data-raw/noncptac/verify-all.R ../evidence ../noncptac-cache
Rscript data-raw/noncptac/update-docs.R
air format R/noncptac.R
```

The original 91 catalog rows remain unchanged. Rebuilding historical package resources can replace the manifest; rerun the local builder afterward. Do not overwrite existing published assets.

Validation results are in [validation-all.json](validation-all.json). Exact source comparisons completed during individual builders can be reused only for matching asset hashes in `completed-source-checks.json`; changed objects are checked again. The loader verifies every staged asset hash before offline use. Tests for historical GlycoPOST assets may skip when their maintainer-only staging files are absent; those skips do not validate historical source data.

Superseded processed tissue, solubility, dilution and lung objects remain in the task's `../evidence/processed-alternatives` as alternatives, not duplicate active cohorts. The provisional pGlycoQuant object was retired because -1 encoding remains unresolved; it is not in the active manifest or exported interface. GPST000216/GPST000109 remain excluded.

## Data release tags

Future package version tags and data tags use matching versions, for example `v0.2.0` and `data-v0.2.0`. Do not create separate project or batch data tags. The current data release remains `data-v0.1.0`; this convention does not authorize creating a package tag or initiating a future release.
