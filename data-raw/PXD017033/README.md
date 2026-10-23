# HGF time-course glycoproteomics

Complete author TMT reporter-intensity tables for SMMC-7721 and HepG2. Each of six timepoints is one measured pool of three biological replicates, not three measured samples. See `feature-sources.json` for channel mapping, source checksum, attribution, scale, and existing-file reuse conditions. No additional normalization, imputation, or zero replacement is applied.

## Annotation consistency

The author composition column and alternative structure codes disagree in seven source rows (SMMC-7721 Excel rows 136, 425, 635, 1135; HepG2 rows 145, 537, 538). Both original annotations are retained; `source_structure_composition_conflict` marks these records and their canonical composition is unknown. No abundance, row, or original annotation is changed. Multiple structure candidates are not treated as verified unique topologies. Compact F is represented conservatively as dHex, with the original fucose annotation retained.

## Conservative merged storage

`glyhub_PXD017033_N_HGFTimecourse` is a 2,318-by-12 union using all ten original
feature-definition columns, including both composition and source structure
coding. This represents author intact-glycopeptide annotation groups, not
confirmed charge-specific precursors or unique isomers. The 18,936 source
values are unchanged; 8,880 structural NA cells identify features absent from
a cell-line source table. Cell line and TMT batch remain explicit; no cross-batch
normalization is performed. Seven conflict features and 21 unique dehydrated
features have unknown canonical composition (28 total).

Complete original experiments and row/column maps are retained in metadata,
including source PSM counts and statistical annotations. The four masks separate
coverage, structural missingness, native missingness and source zeros.
`merged-resource-map.json` maps the two superseded unpublished IDs to the new
object and cell-line selectors, without silent loader aliases.
