# Consolidation of unpublished literature objects

Storage alignment is not additional normalization, imputation or evidence of
cross-batch comparability. The released baseline is unchanged.

| Source | Active representation | Reason |
|---|---|---|
| PXD036791 total-cell lysates | One 6,789 × 54 union, nine explicit sixplex batches | Exact eight-field key includes sequence, modification and theoretical mass; 121,872 source cells preserved, 244,734 structural NA cells |
| PXD036791 secretome | Separate 987 × 6 object | Different fraction and source feature definition; shared WT channels retained once |
| PXD017033 HGF | One 2,318 × 12 union, two cell-line batches | Exact ten-field annotation key; 18,936 source cells and 8,880 structural NA cells; each timepoint remains one measured pool |
| PXD047982 | Sixteen source-run objects | Author PSM identities are run-specific; no validated cross-run molecular alignment or aggregation |
| PMC9287322 CSC panels | Separate panels in one study family | Shared-control run reuse and method/scale comparability not fully resolved; no independence inferred |
| PXD023980 GproDIA | Separate acquisition/method panels | DDA/DIA, gradients and processing layers differ; alternatives are not extra biological cohorts |
| PXD013627 | Human and mouse remain separate | Different species and experimental designs |
| PXD019914 | Intact and SPEG remain separate | Intact glycoforms and deglycopeptide features are different measurement layers |

The eleven superseded IDs were local, unpublished staging identifiers.
`merged_resource_migration.json` maps each to its canonical ID and explicit
column selector. There are no silent aliases. To recover an original experiment
including source row order, sample names, annotations and author attribution,
use the `access_original_experiment` recipe in that map. Selecting union columns
alone retains union rows, including structural NA; it is not the original row set.

The merged `processing_masks` distinguish `source_coverage`,
`structural_missing`, `source_missing` and `source_zero`. Row and column maps
retain every source coordinate. Twenty-three GALNT source-gene disagreements
are unknown in the consensus, with original labels retained per experiment.
Seven HGF composition/alternative-structure conflicts remain flagged and have
unknown canonical composition. No molecular variant is selected by first-row
preference, inferred mass modification, or numeric similarity.
