# Reviewed abundance scales for the staged literature resources

The explicit expected mapping is
`tests/testthat/fixtures/literature-scales.tsv`: 47 curated objects, comprising
37 `raw`, seven `log2`, and three `logx` assays. Its scope is the
`curated_object` entries in
`data-raw/literature-20261022/staged_resource_crosswalk.csv`, not the separate
source assets. It is a scientific expectation fixture, not a hash-verified
migration registry. Do not use it to relabel arbitrary files with matching
names. Existing staged files still require inspection and hash verification.

## Contract and provenance

`metadata$scale` describes the actual assay in the glyexp contract.
`metadata$assay_scale` is a descriptive provenance string, not a substitute
for that field. Setting either field does not transform values.

`raw` means linear coordinates. Normalized intensities, relative abundances,
ratios, and exponentiated log ratios can be linear without being raw instrument
signal. Conversely, positive numbers do not establish a linear scale. These
assignments follow the selected source columns and documented transformations,
not their numerical range or the word "raw" in a field name.

`log2` here identifies documented base-two log abundance coordinates, including
author-normalized or imputed log2 estimates. It does not restore pre-normalized
instrument measurements or make imputed cells observed measurements. `logx`
is used conservatively for log-like analysis coordinates for which a bare
`log2` label would hide a pseudocount or unresolved processing stage; it does
not promise ordinary log2 fold-change semantics.

`raw_abundance` means a retained provenance matrix in these builders, not
necessarily a linear matrix and not necessarily the actual assay scale.
Most builders preserve source values in both matrices. The exception is
PXD019914: `build.R:33,73-81` makes the assay `2^original` but retains source
normalized log2 ratios in `raw_abundance`. Both RelativeRatios assays are
therefore `raw`; source zeros become assay ones. Do not change these numbers
when adding scale metadata.

## Seven documented log2 assays

- PXD013627 HumanCellLines and MouseBCells: `sources.json:51,117` identifies
  author-normalized MSstats log2 protein abundance, and `convert.R:63,75-76`
  preserves that scale without inverse transformation. These are sample-level
  abundance estimates, not a selected CLR, VSN, or standardized residual
  matrix. The retained provenance does not identify a further log-like
  transformation of the selected quantities.
- MSV000088624 HeartSurfaceome: `source.json:26-27` identifies selected
  published log2 abundance estimates following equalize-median normalization,
  Tukey median-polish summarization, and AFT imputation. Those upstream steps
  must remain documented, but the source explicitly describes the output as
  log2 abundance rather than standardized residuals or VSN values. The 28
  supplied missing values remain missing. This does not claim recovery of
  original peptide intensities from protein summaries.
- PMC9287322 CellLineSurfaceome, DrugResistance, and SmallMolecule:
  `sources.json:54,744,1252` explicitly identifies `log2 LFQ`, corroborated by
  `assay_scale` and `author_processing` at lines 375/660, 973/1178, and
  1481/1686. Unlike the two input panels below, these selected matrices have
  no documented added pseudocount or further centered/log-like coordinate
  transformation. `build.R:29-32` checks exact source-cell preservation.
- IPX0011099000 MouseTissueAtlas:
  `mouse-atlas-source.json:193` and `build-mouse-atlas.R:94` identify
  total-intensity-normalized log2 expression, with author-filled zeros.
  Normalization and filling do not change the stated log2 coordinate unit.
  The zero-filled cells must not be reinterpreted as observed unit abundance
  or replaced. This is not the separate untransformed XIC-area build path.

These decisions are supported by the retained source provenance. They do not
assert an independent reanalysis of the authors' complete processing pipelines
or recover undocumented upstream choices.

## Three conservative logx assays

- PMC9287322 PrimaryMyelomaInputs: `sources.json:1747,1835,1900` identifies
  `log2(intensity+1)`. A difference is a log ratio of shifted quantities,
  not the ordinary log2 fold change of the original intensities. Record
  `logx` while preserving the exact expression in descriptive provenance.
- PMC9287322 AMO1Inputs: `sources.json:1950,2061,2150` similarly identifies
  `log2(iBAQ+1)`, so use `logx` for the same reason. The documented shift can
  inform a separate explicit conversion, but the scale label alone does
  not encode it and does not authorize conversion.
- PXD031071 Surfaceome: `source.json:118` describes log2 transformation,
  quantile normalization, LLS imputation and zero-centering for subsequent
  analyses, while leaving the exact stage of the published sheet unresolved.
  `build.R:70,106-107` preserves this uncertainty. `logx` is conservative:
  do not infer a precise inverse, baseline, or plain log2 fold-change meaning,
  and do not call the assay linear because its entries are positive.

## Thirty-seven linear assays

- MSV000097695 AdultWorm (one): `source.json:23` and `convert-site.R:108`
  select pGlycoQuant quantities before subsequent protein-ratio normalization,
  log transformation, filtering and imputation.
- PXD036791 GALNT_TCL and Secretome (two): `convert.R:116` identifies linear,
  author-normalized TMT6plex reporter abundance. Adjacent log2 contrasts are
  annotations, not the selected assay.
- PXD047982 age/lectin/run panels (16): `convert.R:72` identifies linear
  MonoArea per source PSM; runs are not aligned or normalized together.
- PXD016713 ChromatinProteins (one): `source.json:50,264` identifies linear,
  author-imputed MaxQuant intensity, not the adjacent log2 fold-change column.
- PXD019914 RelativeRatios (two): the explicit exponentiation above produces
  linear relative ratios, not original detector intensity.
- PMC12945689 LiverMicrosomeRhythm (one): `source.json:42` identifies
  non-log relative abundance. Its exact normalization origin remains unknown.
- PMC9306173 C1GALT1Silencing (one): its source record and crosswalk select
  positive linear author Intensity columns. Preserve source zeros.
- PMC9185890 AMLSurfaceome (one): `source.json:140` identifies linear source
  intensity/iBAQ-like values, not the later log2 normalization or figure log10
  averages mentioned in the paper. Exact upstream quantification remains
  qualified in the descriptive provenance.
- PXD023980 DDA/DIA panels (eight): `sources.json` supplies the scale consumed
  by `convert.R:88`. DDA precursor abundance is linear with normalization
  status unresolved; DIA uses linear median-normalized quantities and
  top-three peak-group summation. Do not infer DDA normalization history.
- THNO47066 UrineDeglycopeptides (one): `feature-sources.json:1173` documents
  division by sample total protein and scaling by median total protein,
  a linear normalization rather than a log transformation.
- PMC10983713 SerumDiseaseGroups (one): `feature-sources.json:668` identifies
  linear author glycopeptide abundance. Quantification implementation is not
  fully specified; do not claim raw detector signal. PSM counts are annotation.
- PXD017033 HGFTimecourse (one): `feature-sources.json:114,242` selects
  reporter-ion intensity rather than the separate normalized abundance or
  baseline-ratio columns.
- PXD013893 EVEnrichmentMethods (one): `build.R:82` identifies native MaxQuant
  site-group intensity, not LFQ or downstream imputed abundance.

## Embedded experiments and verification

The merged GALNT_TCL object contains nine original experiments (GALNT1, 2, 3,
6, 7, 10, 11, 14 and 18); HGFTimecourse contains two (SMMC7721 and HepG2).
`data-raw/literature-20261022/merged_resource_migration.csv` records all 11.
Every embedded `metadata(x)$source_experiments` object should also have explicit
`scale = "raw"`, independently of the parent field. These are preserved
original experiments, not additional entries in the 47-object fixture.

`merge-experiments.R:180-190` inherits metadata from the first source and
retains all source objects; its constructor at line 216 does not itself prove
that their scales agree. Validate all source scales before merging and reject
mixed or unknown scales rather than inheriting the first silently. Metadata
repair must preserve exact source-experiment round-trip values and structural
missingness; merged storage does not establish cross-batch comparability.

Tests should assert the exact expected scale for every fixture row, validate
all embedded objects, and preserve assay/source matrices and missing/zero
masks. Constructor tests should catch accidental default `raw` labels on
logarithmic inputs; checking `assay_scale` strings is insufficient. Any legacy
migration must independently bind its decision to verified dataset and file
hash, preserve existing explicit metadata, and leave cached bytes unchanged.
Separate source assets, including signed author-processed records, are outside
this mapping and must not inherit a scale merely from a related curated object.

## Runtime registry and rebuilds

`inst/extdata/literature-scales.tsv` pins the 47 top-level decisions to the existing staged resource SHA-256. Eleven extra rows describe the source experiments inside the two merged files; for these rows `sha256` is the **parent file's** checksum, `parent_dataset` identifies that parent, and `source_experiment` is its exact embedded-list key. Those old IDs do not become standalone loader aliases.

The loader adds only absent `scale` metadata, including in these checksum-pinned embedded experiments. Existing explicit fields are not overwritten. Cached files, manifest hashes, scientific measurements, privacy safeguards and provenance are unchanged. This is metadata compatibility, not a data release or a numerical inverse transformation.

Native constructors set explicit scales before validation; the shared source converters use an exact reviewed dataset lookup. Registration rejects an incorrect scale and keeps checksum bindings aligned when a future authorized rebuild creates new bytes. Experiment merges reject absent or mixed scales.
