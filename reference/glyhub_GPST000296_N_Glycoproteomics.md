# Site-specific N-glycoproteome of oral squamous-cell carcinoma tissues

Quantitative N-glycopeptide profiles of 30 oral squamous-cell carcinoma
tumour tissues, comprising 12 node-negative and 18 node-positive
samples.

## Usage

``` r
glyhub_GPST000296_N_Glycoproteomics(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 3117 features and 30 observations. The abundance assay is in
pooled-reference-normalized and channel-total-normalized reporter-ion
abundance (fraction). rowData has no glycan_structure column because no
feature has a supported structural annotation.

## Source

GlycoPOST GPST000296. . Study:
<https://doi.org/10.1016/j.mcpro.2023.100586>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000296>. Quantitative source:
<https://www.ebi.ac.uk/europepmc/webservices/rest/PMC10336694/supplementaryFiles>.

## Arguments

- kind:

  `"curated"` returns a data object; `"raw"` returns the path to a
  verified source archive. Raw archives are currently available for
  CPTAC.

- cache_dir:

  Cache directory, defaulting to `tools::R_user_dir("glyhub", "cache")`.
  Set option `glyhub.cache_dir` to change the default.

- refresh:

  Download the pinned resource again, even if cached.

- offline:

  Prohibit downloads; require a verified local resource.

## Details

The 3,117 author-grouped UniProt, protein-site and glycan-composition
features are retained. Reporter ion intensities were divided by the
pooled reference channel within each TMT experiment and normalized to
each channel total. Source NaN values remain missing; numerical zeros
become NA. No reaggregation or imputation is applied. The companion
released-glycan dataset has a different molecular observation unit and
is retained separately.

Compositions are transcribed directly from the Glycan field. Protein
positions come from the author glycopeptide identifier and agree with
every reported Glycosite entry. Peptide-relative positions and peptide
starts are retained separately; all reported start plus
relative-position coordinates agree with the protein absolute position.
Representative peptide sequences cannot consistently validate every
PSM-relative position, so original fields and a residue-consistency flag
are retained without changing the author site. No site-specific glycan
topology is inferred from companion released-glycan diagrams.

## Access

Use `glyhub_load("glyhub_GPST000296_N_Glycoproteomics")` to load this
dataset.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
