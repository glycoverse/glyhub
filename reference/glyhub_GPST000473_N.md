# N-glycan remodeling after TANGO2 loss

Relative abundances of 82 released N-glycan features in TANGO2 knockout
and control cells, with three quantitative columns per genotype.

## Usage

``` r
glyhub_GPST000473_N
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 82 features and 6 observations. The abundance assay is in relative
abundance fraction. rowData includes a typed glycan_structure column;
features without a supported structure are NA.

## Source

GlycoPOST GPST000473. Supplementary Data 3, glycomics. Study:
<https://doi.org/10.1038/s41467-025-60563-1>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000473>.

## Details

PGC-LC-MS profiling of PNGase F-released, reduced N-glycans examines
cellular glycosylation changes associated with TANGO2 loss and altered
cytoskeletal organization. The six individual source columns are
retained; the figure caption reports five biological replicates for a
broader panel but this table contains three per genotype. Likely source
topologies are retained with unmarked linkages and bracketed attachments
unresolved. The FA3 feature has conflicting shorthand and diagram
annotations and therefore lacks typed glycan annotations.

Likely SNFG topologies transcribed from the source diagrams; uncertain
linkages and bracketed terminal parents remain ambiguous. Source row 38
has a label/diagram conflict.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
