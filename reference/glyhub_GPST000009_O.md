# Atlantic salmon epithelial mucin O-glycans

O-glycan relative abundances from Atlantic salmon skin, pyloric caeca
and distal-intestinal mucins across six geographic and husbandry cohorts
from Tasmania, Sweden and Norway.

## Usage

``` r
glyhub_GPST000009_O
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 169 features and 57 observations. The abundance assay is in
relative abundance (%). rowData includes a typed glycan_structure
column; features without a supported structure are NA.

## Source

GlycoPOST GPST000009. Sheet1. Study:
<https://doi.org/10.1074/mcp.ra119.001319>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000009>.

## Details

All compatible tissue and cohort measurements are retained in one
matrix. Original retention times, peak areas, suggested structures and
per-sample MS1-only asterisks remain available in source annotations.
Relative abundance is preserved as reported; ionisation differences
limit interpretation across different glycan species. Typed structures
describe native residue topology with analytical reducing-end reduction
documented separately. Unresolved linkages remain unknown; malformed or
sulfated structure strings remain as source annotations pending
unambiguous representation.

Source-derived compositions and original labels are retained. 152
source-supported structures are typed; unspecified bonds remain unknown.
Unresolved or conflicting structures remain missing with source
provenance.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
