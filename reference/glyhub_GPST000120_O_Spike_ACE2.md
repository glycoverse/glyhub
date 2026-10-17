# Released O-glycans of recombinant SARS-CoV-2 Spike and ACE2

The study characterizes the glycosylation of recombinant Spike and
soluble human ACE2. This complete source O-glycan table reports percent
of total profile for 16 glycan features in each protein preparation.
Columns are protein-level profiles, not biological replicates.

## Usage

``` r
glyhub_GPST000120_O_Spike_ACE2(
  kind = c("curated", "raw"),
  cache_dir = getOption("glyhub.cache_dir", tools::R_user_dir("glyhub", "cache")),
  refresh = FALSE,
  offline = FALSE
)
```

## Format

A
[glyexp::GlycomicSE](https://glycoverse.github.io/glyexp/reference/GlycomicSE.html)
with 16 features and 2 observations. The abundance assay is in percent
of total O-glycan profile. rowData includes a typed glycan_structure
column; features without a supported structure are NA.

## Source

GlycoPOST GPST000120. Sheet1. Study:
<https://doi.org/10.1016/j.chom.2020.08.004>. Repository:
<https://glycopost.glycosmos.org/entry/GPST000120>. Quantitative source:
<https://glycopost.glycosmos.org/data/GPST000120.0/olinked3.xlsx>.
Annotation evidence: <https://ts.glytoucan.org/sparql>.

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

The entire 16-feature source O-glycan table is retained. The two columns
are protein-level profiles for recombinant Spike and soluble human ACE2,
with no biological replicate identity inferred. Original nd/nd\* markers
and measurements are retained; abundance zeros and not-detected entries
are represented as NA without renormalization.

All 16 source GlyTouCan accessions were resolved to WURCS records from
the official GlyTouCan SPARQL service. The registered structures were
converted with glyparse 0.8.1, reparsed and validated with glyrepr
1.1.0, and compositions derived from those structures. This preserves
the source accession assignments and does not infer structures from mass
or infer new experimental linkage evidence.

## Access

Use `glyhub_load("glyhub_GPST000120_O_Spike_ACE2")` to load this
dataset.

## See also

[glyhub_data_conventions](https://glycoverse.github.io/glyhub/reference/glyhub_data_conventions.md)
for missing-value handling, annotations and access to original
measurements and source coordinates.
