# Mgat3 mouse brain and kidney N-glycan source profiles

Source-preserving study-level N-glycan resource from Mgat3 wild-type and
knockout mouse brain and kidney. It contains the complete published
51-feature brain table and 287-feature kidney workbook as distinct
source panels.

## Usage

``` r
glyhub_GPST000027_031_N
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 338 features and 6 observations. The abundance assay is in source
EIC peak intensity (panel-specific instrument units). rowData has no
glycan_structure column because no feature has a supported structural
annotation.

## Source

GlycoPOST GPST000027 and GPST000031. Supplementary Figure S2C (PDF page
4) and Supplemental Table S2 (WT&Mgat3KO sheet). Study:
<https://doi.org/10.1074/mcp.RA119.001534>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000027> and
<https://glycopost.glycosmos.org/entry/GPST000031>. Quantitative source:
<https://pmc.ncbi.nlm.nih.gov/articles/PMC6773561/>.

## Details

The object is a disjoint union of 338 source-specific chromatographic
features across six source observations: two genotype-labelled brain
profiles and four kidney sample/run columns. Of the 2,028 storage cells,
1,250 are measured source cells and 778 cross-panel combinations are
unmeasured; source_coverage and processing_masks distinguish these from
the 324 source zeros represented as NA. The original brain and kidney
matrices, annotations, sample metadata and exact maps remain in
metadata(x)\$panels, panel_row_data, panel_col_data and panel_maps. No
rows are aligned across tissues using composition, mass or author
numbering.

The one abundance assay retains EIC peak intensities in panel-specific
instrument units. Brain uses aminoxyTMT6 whereas kidney uses
aminoxyTMT0; combining storage does not establish calibrated numerical
comparability across tissues or protocols. Original percentages remain
metadata(x)\$source_relative_abundance, not a second assay. Both source
percentage blocks use high-mannose intensity sums as denominators rather
than total glycome. Brain values retain the published one-decimal
precision; kidney values retain Excel precision. No averaging,
imputation or normalization is added.

Kidney workbook run IDs exactly match four GPST000031 raw filenames.
Brain S2C supplies no run or replicate IDs; its raw-file links are
explicitly marked genotype-and-filename-based candidates in GPST000027.
Although the article reports three independent brain WT/KO pairs, only
two genotype columns are published in S2C; these are not expanded or
labelled as independent individual mice. Biological replication,
pairing, age and sex are not inferred. This object represents the
complete published tables, not every raw detected peak or every
experiment in the paper.

306 features have a single source composition, retaining generic
residues plus the explicitly stated Man3GlcNAc2 core. For 32 ambiguous
kidney features, typed composition is NA while every original candidate
string/count and all quantitative cells remain. Chromatographic subpeaks
stay distinct even when composition and mass match. Diagnostic MS/MS
scan identifiers do not establish complete topology; no glycan_structure
column is present. Source file attribution and article-version CC BY 4.0
license evidence are retained separately from the package code license;
no supplement-specific license declaration was independently verified.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
