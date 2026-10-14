# Fucosidase treatment of porcine colonic mucin O-glycans and related study experiments

LC-MS profiles of porcine colonic mucin oligosaccharides exposed to
individual Bacteroides thetaiotaomicron fucosidases. This experiment
compares the effects of GH95 and GH29 enzymes on a complex O-glycan
substrate containing different fucosylated epitopes. Supplementary Table
S5 provides 108 features and 22 observations. Combined O-glycan
quantitative profiles from GPST000643. 365 union features and 71 source
observations are represented.

## Usage

``` r
glyhub_GPST000643_O
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 365 features and 71 observations. The abundance assay is in
percentage of source total glycan AUC. rowData includes a typed
glycan_structure column; features without a supported structure are NA.

## Source

GlycoPOST GPST000643. Supplementary Table S5 (media-6.xlsx). Study:
<https://doi.org/10.64898/2026.03.26.714468>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000643>.

## Details

Source experiments are identified in colData and original panel-specific
metadata, annotations and measurements are retained in metadata. Feature
identities are aligned only when supported by author identifiers or
explicit molecular structures; other features retain source-specific
identities. The source_coverage matrix distinguishes unmeasured
combinations from measured missing values. Units: source-reported
percentage of total glycan AUC.

Fucosidase treatment of porcine colonic mucin O-glycans: The conditions
are a no-enzyme control and BT1777, BT3155, BT3173, BT1842, BT3665,
BT1625, BT4136, BT3798, BT3956 and BT4713. Each condition has columns
labelled Replicate 1 and Replicate 2; these labels alone do not identify
biological versus technical replicates.

The source supplies glycan AUCs, retention times and percentages
normalized to total glycan AUC per observation. The abundance assay uses
the percentages. Fucose, sulfation and blood-group annotations are
retained as source annotations, including their zero-valued categorical
flags. Features include substrate glycans and enzymatic products;
O-derived denotes their experimental origin.

GH89 treatment of porcine gastric mucin O-glycans: The no-enzyme
control, BT0438 treatment and BT4359 treatment each have two
source-labelled replicates. The assay contains total-AUC-normalized
percentages; original AUC and retention-time entries are retained
separately in metadata.

Source row 46 has a disagreement between its reported composition and
putative structure residue counts. Rows 69 and 70 contain the unresolved
composition token HexHAc, so their typed compositions are NA. Original
labels and the annotation_consistency field identify these cases. Their
quantitative measurements are retained; uncertain molecular assignments
should be considered before feature-level interpretation.

GH2 treatment of bovine submaxillary mucin O-glycans: The seven source
columns represent a control and separate treatments with BT1626, BT3179,
BT3340, BT4050, BT4241 and BT4684. No replicate labels are supplied for
these columns. This table concerns bovine submaxillary mucin without the
sialidase/fucosidase pretreatment used in the separate S9C experiment.

Abundances are percentages of total source glycan AUC. Source galactose,
sialylation, sulfate and fucose annotations accompany the molecular
labels. A single column per condition should not be interpreted as
replicated evidence for treatment effects.

GH20 activity on O-glycans from pretreated PSGL-1: The protein substrate
was pretreated with BT0455 sialidase and the galactosidases BT1626 and
BT4241 to expose terminal N-acetylglucosamine. The eight conditions are
control, BT1621, BT1627, BT3178, BT3598, BT3868, BT4394 and BT4681.
There is one source column per condition; biological replicate type and
expression-system species are not established by these table columns.

Only the source O-glycan section is included here. Its N-glycan section
is available as glyhub_GPST000643_N_S10B. Percentages retain the
denominator supplied in the workbook; separating the sections does not
renormalize either matrix. Source mass/isomer labels are local to the
table and are not universal glycan identifiers.

Replicated GH20 measurements of PSGL-1 O-glycan core features: The
conditions are control, BT3178, BT3598, BT3868 and BT4681, each with
Sample 1, Sample 2 and Sample 3. PSGL-1 expressing core 4 was pretreated
with an enzyme mix. The expression-system species and biological versus
technical replicate type are not established by these table columns.
Percentages retain the source total-AUC denominator without
renormalization after separation by glycan class.

The retained mass-labelled features are 425-2, 628 and 716 (source rows
8-10). Their composition and full putative-structure labels match the
explicitly labelled O-glycan section of S10B. The two N-glycan features
from S10C are available in glyhub_GPST000643_N_S10C. Both objects
describe the same observation columns; they are complementary feature
partitions, not separate biological samples.

Colonic mucin O-glycan degradation by enzyme mixtures: Three
source-labelled samples are reported for each of a no-enzyme control, an
eleven-enzyme mixture and the same mixture supplemented with BT3868. The
base mixture contains BT0455, BT4243, BT1625, BT3173, BT1636, BT1624,
BT1626, BT4241, BT1628, BT4681 and BT0438. This is the S11B mixture; it
does not include the additional BT4394 used in the distinct S11C
experiment.

Measurements are percentages of source total glycan AUC. O-derived
features include remaining substrate glycans and released enzymatic
products. Sample 1-3 labels are retained without assigning a biological
replicate type or pairing the conditions.

Gastric mucin oligosaccharides remaining after bacterial growth: The
source conditions are Control (gMO), the double alpha-1,2-fucosidase
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

All 108 source composition labels are retained as typed compositions.
Forty-seven source putative structures have explicit encodings;
remaining structural descriptions are preserved as text without
completing unspecified linkages.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
