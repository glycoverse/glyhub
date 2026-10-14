# Gastric mucin oligosaccharides remaining after bacterial growth

LC-MS profiles of oligosaccharides in culture supernatants after growth
of Bacteroides thetaiotaomicron on porcine gastric mucin O-glycans.
Wild-type and fucosidase-deficient strains are compared with the glycan
substrate control to examine the contribution of fucose removal to mucin
utilization. Supplementary Table S12 contains 140 features and four
observations.

## Usage

``` r
glyhub_GPST000643_O_S12
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 140 features and 4 observations. The abundance assay is in
percentage of source total glycan AUC.

## Source

GlycoPOST GPST000643. Supplementary Table S12, sheet named Table 12
(media-13.xlsx). Study: <https://doi.org/10.64898/2026.03.26.714468>.
Repository: <https://glycopost.glycosmos.org/entry/GPST000643>.

## Details

The source conditions are Control (gMO), the double alpha-1,2-fucosidase
deletion strain lacking bt3173 and bt4682, that double deletion with an
additional bt1842 deletion, and wild-type B. thetaiotaomicron. These are
culture-supernatant glycan profiles, not bacterial counts or
gene-expression measurements. One percentage column is available for
each condition; no biological replicate type is assigned.

Percentages are normalized to source total glycan AUC. Feature row 48
has conflicting composition and putative-structure residue counts; both
source assignments are retained and flagged in annotation_consistency.
Digestion products and residual substrate glycans should be interpreted
together in this extracellular measurement space.

Typed compositions retain source mass/isomer labels, and 95 putative
structures are encoded. Ambiguous source structures remain as text.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
