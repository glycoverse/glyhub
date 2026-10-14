# Initial five-project curation audit

This historical audit describes the original five-project screen. For the later
20-project calibration and consolidated dataset names, see [CALIBRATION.md](CALIBRATION.md)
and [panel-name-mapping.csv](panel-name-mapping.csv).

## Scope and retained data

The official GlycoPOST public list was checked on 14 October 2026, ordered by
announcement date (same-day ties retained official order). The five studies were
GPST000739.0 (12 October), GPST000643.0 and GPST000634.0 (8 October),
GPST000738.0 (30 September), and GPST000735.1 (24 September).
Only GPST000738 and GPST000643 are included. This audit does not claim that every
experiment in either publication has been reconstructed.

Retained inputs, scripts and processing ledgers are grouped in
data-raw/GPST000643/ and data-raw/GPST000738/. Shared build/validation entry points
and overall audit records remain at data-raw/. No date directories are used.
Run source("data-raw/build.R") from the package root. The accession scripts
verify input checksums and write data/.
The original XLSX files remain byte-identical. Whole source workbooks are retained
where they contain an included table, including their ancillary sheets and notes;
unused sheets are not converted into extra datasets. Source licenses are recorded
in each object and below; the package code license does not relicense source data.

## Uniform measurement policy

Zero-valued abundances are represented as NA in the distributed objects.
Only the abundance assay is transformed; the original measurements remain available.
Original numerical values and text, original AUC/RT where supplied, source tables,
per-cell decisions, boolean masks and counts remain in metadata and CSV ledgers.
Zero time, categorical zero flags and composition counts are unchanged. No values
are imputed, no unknown sample identities assigned, and no percentages rescaled.

Masks can overlap: for example an original zero may have an accompanying n.d.
retention time. GPST000738 source n.d., missing cells, conflict NA and zero-to-NA
are separate masks. GPST000643 zero-to-NA and source RT n.d. are separate masks.
raw_abundance is provenance in metadata, not another quantitative assay.

## GPST000738

[Project](https://glycopost.glycosmos.org/entry/GPST000738), revision 0.
[DeBono et al., Frontiers 2026](https://doi.org/10.3389/fmolb.2026.1932584).
The published Table 1.xlsx and repository Supplementary_Table_IMER_20260707.xlsx
have the same MD5: f83b7c3e4e5d33a367ce2a23999a7757.
The [publisher attachment manifest](https://www.frontiersin.org/api/v4/articles/1932584/supplemental-data)
is retained locally. The supplementary DOCX has MD5
0238a8f8de4dff161a4dcb9bb7c42bd1.

Two objects retain all feature rows from raw/isomer sheets 1–4:

| Object suffix | Features × observations | Unit | Curated NA |
|---|---:|---|---:|
| N_B4GalT1 | 9 × 18 | percentage within each glycan family | 30 |
| N_ST6GAL1 | 10 × 28 | fraction within each glycan family | 23 |

Different enzyme experiments have different feature spaces and units, so remain
separate. Reactor flow and time are colData fields. The identical repeated control
table is represented once per enzyme, with both source locations recorded. This
removes duplicate table presentation, not an inferred biological individual.
Biological identity, replicate type and raw-file mapping remain unknown.

The paper's methods and supplementary Figure S3 support within-family abundance.
Its Figure 2 explains exclusion of the first B4GalT1 25 µL/min injection because
of acquisition loss/poor signal. ST6Gal1 combines flows in its published analysis;
the objects preserve flow conditions instead of averaging them.

Conservative conflict handling:

- B4GalT1 25 µL/min A2 and A2G1 duplicate six treatment values and the family
  fails to close. Both affected rows at those six observations become NA (12
  cells), without choosing which row is correct or calculating a residual.
- The A3 block has four raw controls but three processed controls. The first two
  corresponding positions agree; raw control positions 3–4 have unresolved
  correspondence. Their six A3 features become NA (12 cells), without guessing
  that processed control 3 is raw control 4. Original tables remain intact.
- Six other B4GalT1 zeros become NA under zero-value conversion, giving 30 NA cells.
- ST6GAL1 has 13 original n.d. cells. Its ten 25 µL/min 0-hour values are omitted
  from processed sheet 7, without an explicit exclusion explanation; these ten
  cells become conflict NA. Their original values remain available in metadata.
- Processed ST6GAL1 control rep 8 has no raw-table identity. Six source cells
  across sheets 7 and 8 are retained as unmatched_processed_observations, not
  paired with raw observations or counted as new independent individuals.

The scripts compare observed composition blocks, never their summary-statistic
rows. For A3 isomers, comparison uses the explicitly corresponding sum while the
assay retains separate source isomer rows. source_tables and processing_ledger
record every source value and decision. A family can no longer sum to 100/1 after
NA conversion; no renormalization is performed. These are usable partial repairs
with complete raw feature coverage, not a recovered final author analysis matrix.

Annotation: typed compositions retain source isomer names. Fully localized Figure
S3 structures were transcribed after viewing the source diagrams; reducing-end
anomers remain unspecified. Bracketed ambiguous antennae and unresolved a/b
isomer mappings are not guessed. Each object has four typed structural rows;
source Figure S3 PNG evidence is embedded in metadata and retained in
data-raw/GPST000738/.

[GlycoPOST terms](https://glycopost.glycosmos.org/terms) permit use and redistribution;
uploads are not relabelled CC0. The Frontiers article and supplementary evidence
retain their CC BY attribution.

## GPST000643

[Project](https://glycopost.glycosmos.org/entry/GPST000643), revision 0.
[Paper/preprint](https://doi.org/10.64898/2026.03.26.714468),
[PMC13042051](https://pmc.ncbi.nlm.nih.gov/articles/PMC13042051/).
The official Europe PMC supplementaryFiles archive was retrieved completely and
all ZIP entries passed CRC verification. File checksums and direct source URLs
are in GPST000643/GPST000643-source-manifest.csv. Only workbooks containing included tables
are retained; the downloaded archive and unused standalone workbooks were trashed.

| Source table | Glycan type | Features × observations | Typed structures |
|---|---|---:|---:|
| S5, cMO fucosidases | O-derived | 108 × 22 | 47 |
| S7, gastric mucin GH89 | O-derived | 77 × 6 | 67 |
| S9B, BSM GH2 | O-derived | 56 × 7 | 40 |
| S10B, pretreated PSGL-1 GH20, O section | O | 9 × 8 | 9 |
| S10B, pretreated PSGL-1 GH20, N section | N | 3 × 8 | 3 |
| S10C, pretreated PSGL-1 GH20, O rows | O | 3 × 15 | 3 |
| S10C, pretreated PSGL-1 GH20, N rows | N | 2 × 15 | 2 |
| S11B, cMO enzyme mixtures | O-derived | 60 × 9 | 27 |
| S12, gastric mucin culture supernatant | O-derived | 140 × 4 | 95 |

Each object contains the entire selected quantitative feature block, including
zeros now represented as NA. Digestion products retain their source annotations;
O-derived describes the experiment's substrate, not a claim that every released
fragment remains protein-linked. Source percentages are normalized to source total
AUC; AUC and retention time remain separate provenance matrices. N/O splitting
in S10B and S10C does not change the original percentage denominator.

These are separate experiments/substrates or independently labelled N/O spaces;
replicate columns and treatment conditions stay within each object. Source sample
and replicate labels are preserved verbatim; biological replicate identity and
cross-table correspondence are not inferred. The GlycoPOST raw-file list alone
cannot establish an individual match to each SI column.

Not converted in this pass: defined free oligosaccharides, keratan-sulfate/TLC
products, RNA expression, enzyme kinetics and primer lists are outside the selected
N/O glycomics resource scope. S3D, S6 and S8 contain conflicting enzyme header
entries. S9C/S9D and S11C contain additional or inconsistent percentage/RT/AUC
headers requiring separate reconciliation. They are not silently assigned sample
identities or measurement units, and this collection is not presented as all
quantitative experiments from the study.

Structures: original putative-structure text is preserved for every feature.
Only notation changes with explicit linkages/localized sulfate positions are
converted to typed glyrepr structures; ambiguous or unparseable expressions stay
as source text with typed NA. No unspecified linkage or topology is supplied.
Source compositions are token-mapped (Hex, HexNAc, deHex, NeuAc, NeuGc, Sul) to
known glyrepr types; source labels remain alongside them. Two source rows (S7
row 46 and S12 row 48) have composition/structure count conflicts; both original
claims are retained and flagged in annotation_consistency. S7 rows 69–70 use an
unresolved HexHAc token, so typed compositions remain NA rather than guessing.
These annotation limitations are independent of the quantitative zero-value representation.

Original license: Creative Commons Attribution-NoDerivatives 4.0 International,
[license link](https://creativecommons.org/licenses/by-nd/4.0/), as stated in the
article XML. Original XLSX bytes and attribution are retained. Numerical facts
are reorganized, the zero-value conversion is explicitly marked, and no source
relicensing or author endorsement is asserted. The original putative annotations
remain traceable even when their notation is translated.

## Excluded studies

Only lightweight identifiers, links and reasons remain for:

- [GPST000739](https://glycopost.glycosmos.org/entry/GPST000739): inspected result
  files did not establish a sample-level glycan abundance matrix; candidate
  identification TIC and fragment intensities were not reused as glycan abundance.
- [GPST000634](https://glycopost.glycosmos.org/entry/GPST000634): available table
  reports group summaries, without underlying experimental observations.
- [GPST000735](https://glycopost.glycosmos.org/entry/GPST000735): aggregate profile
  without sample-resolved measurements, with unresolved annotation/unit issues.

Only inputs for the included accessions are distributed in data-raw/.
No raw MS acquisition files are included.

## S10C glycan-class evidence

S10C rows 11-12 (1317-1 and 1520) match S10B rows 25-26 in mass label,
composition and complete putative-structure text. S10B explicitly places these
rows below its N-glycans heading (row 21). S10C rows 8-10 match S10B O-glycan
rows 10, 14 and 15 in the same fields. Build-time assertions verify these exact
source correspondences. The published supplementary workbook, rather than mass
alone, establishes the assignments.

The S10C O (3 x 15) and N (2 x 15) objects partition all five original rows.
They retain identical observation names/colData and the original percentages,
AUC/RT, missing-value masks, reasons and source coordinates. Their denominators
are unchanged. Dataset-level counts are the respective sums of the partitioned
masks. Other objects were screened for explicit N/O section labels and N-core
structural assignments: no additional supported misclassification was found.
Unassigned or ambiguous structures were not classified by absence of evidence.
