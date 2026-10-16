# Site-resolved N-glycoform proportions during influenza infection of A549 cells

Complete source N-site glycoforms from Supplementary File 5: union of
ten organelle/secreted fraction panels at 0,6,12,18,24 hours after mock,
PR8(H1N1), or x31(H3N2) exposure. 3609 protein/site/glycan identities
across 90 biological sample observations.

## Usage

``` r
glyhub_GPST000671_N_Glycoproteomics
```

## Format

A
[glyexp::GlycoproteomicSE](https://glycoverse.github.io/glyexp/reference/GlycoproteomicSE.html)
with 3609 features and 90 observations. The abundance assay is in
site-normalized glycoform proportion (fraction). rowData has no
glycan_structure column because no feature has a supported structural
annotation.

## Source

GlycoPOST GPST000671. . Study:
<https://doi.org/10.1038/s42003-026-10759-y>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000671>. Quantitative source:
<https://www.nature.com/articles/s42003-026-10759-y>.

## Details

Assay values are author site-normalized proportions F:N, not raw signal
or whole-sample glycan abundance. All source rows assigned to this
glycan class are retained. Features are aligned only by the exact
Protein/site/Glycans triplet; source Concat was checked to match this
triplet in every row. No within-panel duplicate triplets occur. Union
cells for a feature absent from a source panel remain NA with
source_coverage=false; source blanks and actual zeros remain separately
recoverable. Only quantitative zeros become NA. No curation-stage
imputation, renormalization or replicate averaging occurs. O:W raw
intensities are preserved in columns O:W of the pinned source extraction
and original workbook. The three biological replicates per condition
follow the paper; replicate numbers 1:3 encode within-condition
source-column order, not demonstrated longitudinal pairing across time
or compartment. TMT channels are preserved because assignments change
with time. Human, bovine and influenza-virus protein assignments are all
retained exactly; the culture host is human A549, but row-level protein
organism must be used for protein provenance. Released glycomics is a
separate assay/object class.

Counts are parsed only from explicit author Glycans tokens. HexNAc, Hex,
Fuc and NeuAc are preserved; explicit Phospho and Sulfo are retained as
P and S substituents. Protein accession and site positions are author
assignments, not independently revalidated peptide localization. All
observed source sites are single N/S/T positions; ambiguous or multiple
source sites would remain untyped. Full glycan structures are not
inferred from composition or site.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
