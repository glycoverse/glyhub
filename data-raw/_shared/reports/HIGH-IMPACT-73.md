# Review of 73 GlycoPOST projects

Initial review on 2026-10-15, updated on 2026-10-16, against a frozen 73-project journal-tier selection. Journal metrics were used only to define the screening set; inclusion depends on recoverable quantitative data and interpretable source annotations.

The [complete accession ledger](high-impact-73-ledger.csv) includes every reviewed project, article DOI, disposition, dataset mapping and reason. Fourteen projects were already represented in the package and were not duplicated. Thirty further projects currently contribute 41 datasets. Twenty-nine projects are excluded; no project-level inclusion decisions remain unresolved. The three pre-existing projects outside this selection are retained.

## Quantitative and molecular annotation review

- Only complete source tables or complete source-defined profiles are represented. Quantitative observations, experimental samples and biological replicates are distinguished in each help page.
- Source zero values become missing values in the distributed linear abundance assays. Source values and coverage remain available in metadata; no undocumented normalization or imputation is performed.
- Molecular composition and source-supported structural topology are represented independently. Unknown bonds and unresolved branch attachment remain uncertain. Inconsistent source annotations are retained verbatim but affected typed annotations are missing.
- GPST000294 includes 202 N-glycan rows across four culture/release profiles. Exact percentages and censored inequalities are distinguished; retention times are not treated as abundance.
- GPST000296 additionally includes 3,117 site-resolved glycopeptide rows across 30 coded tumor samples, with original coordinate ambiguities retained. Its N-glycome provides 82 proposed partial structures and one composition-only glycan explicitly unconfirmed in the original spectral atlas.
- GPST000297 contains source-composition/diagram disagreements in N-glycan rows 10 and 11. Both typed fields are missing for those rows; all abundance values and original evidence remain available.
- GPST000240 contains one GSL source-composition/diagram disagreement (GP34). The uncertain typed annotation is missing rather than resolved by assumption.
- GPST000625 reports chromatographic peaks and a separately deconvoluted pooled structural list. Peak-level quantities are retained without assigning an unsupported single molecular identity.
- GPST000604 and GPST000562 retain exact author disaccharide codes where the current glyrepr vocabulary cannot faithfully encode unsaturated uronic-acid chemistry.

GPST000712 is excluded because the transformed matrix cannot be returned to linear abundance without its missing centering/scaling parameters and transform order. No source payload is retained.

GPST000405 is excluded because peptide-crosslinked peptidoglycan oligomers cannot be represented faithfully by the current glycan object types. No source payload is retained.

## Newly recovered Mgat3 study sources

GPST000027 brain and GPST000031 kidney now contribute one source-preserving N-glycan study object with 338 feature rows and six observation columns. The 51 × 2 brain table and 287 × 4 kidney table retain disjoint chromatographic feature spaces, their separate labelling protocols and original scales. The union includes 1,250 measured cells; 778 cross-panel cells are explicitly unmeasured. The 32 ambiguous kidney compositions remain typed NA without losing their source measurements. Brain run associations are only filename-based candidates, and the published two-column table does not establish individual biological replicates. See the accession directories for extraction evidence and limitations.

GPST000216 was reviewed from its supplied Supplementary Data 2: a complete 43 × 3 jointly desialylated and degalactosylated panel exists, but sparse labels do not establish per-row molecular identities. The user chose not to include an all-composition-missing feature-only object. No dataset or source payload is included.

GPST000041 is excluded from the current import after review of eight supplied supplemental PDFs. They contain HCD/ETD glycopeptide identifications and annotated fragment spectra, not a sample-level quantitative matrix; spectral "Relative Abundance" is not sample glycan abundance. The conclusion is limited to the eight reviewed PDFs, not every unreviewed archive member. Their filenames, page counts and SHA-256 values are recorded in the JSON ledger without retaining the PDFs.

## Final disposition of previously unresolved records

GPST000027 and GPST000031 are accepted together; GPST000041 and GPST000216 are excluded for the scoped reasons above. GPST000109 is excluded at the user's direction, without obtaining or evaluating the candidate quantitative supplement. This is a scope decision, not a claim of absent usable data or poor data quality. All five previously unresolved project-level inclusion decisions are now closed. Molecular annotation uncertainties and the stated limits of accepted datasets remain explicit.

GPST000562 has an accepted CS/DS disaccharide matrix; an additional long-form glycopeptide supplement is not claimed to be curated by that object.

## Sources and licensing

Original public source files, their publisher or repository URLs and checksums are recorded beside each accepted accession. Externally hosted publisher supplements with verified recovery endpoints are restored by `source-recovery.json` and `recover-sources.R`; they are not relicensed as MIT. The supplied GPST000027/GPST000031 originals are excluded from Git and require manual placement with pinned SHA-256 checks because automatic recovery was not verified; article-version CC BY 4.0 evidence is distinct from supplement redistribution and repository download availability. The MIT license covers package code. Original data attribution and applicable source terms are retained in each object's provenance. Numerical facts and transcribed molecular evidence are kept distinct from redistribution of complete publisher documents.

No source payload for an excluded or unresolved accession is included. Existing curated datasets remain unchanged in scientific content; the build and validation report records the comparison.
