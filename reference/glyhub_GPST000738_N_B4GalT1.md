# Galactosylation of bovine fetuin N-glycans in an enzyme reactor

N-glycan profiles from bovine fetuin treated with an immobilised B4GalT1
reactor. The experiment examines galactose addition to desialylated,
degalactosylated fetuin over repeated injections at two flow rates. It
contains nine glycan and isomer features measured across 18 source
observations.

## Usage

``` r
glyhub_GPST000738_N_B4GalT1
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 9 features and 18 observations. The abundance assay is in
percentage within the source glycan family. rowData includes a typed
glycan_structure column; features without a supported structure are NA.

## Source

GlycoPOST GPST000738. Supplementary Table 1, sheets 1 and 2; composition
comparisons in sheets 5 and 6; Figure S3. Study:
<https://doi.org/10.3389/fmolb.2026.1932584>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000738>.

## Details

The substrate is foetal bovine serum fetuin treated with sialidase and
galactosidase. Four substrate-control columns are followed by two
observations at each of 2, 4 and 8 hours at 25 microlitres/minute, and
at 0, 2, 4 and 8 hours at 75 microlitres/minute. The first 25
microlitres/minute injection was excluded in the source study because of
acquisition loss and poor signal.

Abundance is expressed as a percentage within the A2 or A3 glycan
family, not of the total glycome. Flow and time are recorded in colData.
The repeated control table is represented once; the columns do not
establish biological replication or pairing.

Twelve A2/A2G1 treatment cells with duplicated, non-closing source
values and twelve A3 control cells with unresolved cross-table
correspondence are NA. Six additional zero measurements are NA. Original
values and the separate masks remain in metadata. Summing the available
values therefore need not give 100.

Nine typed compositions retain distinct source isomer labels. Four fully
localized structures from Supplementary Figure S3 are encoded; ambiguous
antennae and unresolved isomer mappings retain diagram evidence.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
