# Review of 73 GlycoPOST projects

Reviewed on 2026-10-15 against a frozen 73-project journal-tier selection. Journal metrics were used only to define the screening set; inclusion depends on recoverable quantitative data and interpretable source annotations.

The [complete accession ledger](high-impact-73-ledger.csv) includes every reviewed project, article DOI, disposition, dataset mapping and reason. Fourteen projects were already represented in the package and were not duplicated. Twenty-eight further projects currently contribute 40 datasets. Twenty-four projects do not supply an eligible complete quantitative matrix; seven remain unresolved. The three pre-existing projects outside this selection are retained.

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

## Unresolved records

- GPST000027, GPST000031, GPST000041 and GPST000109: complete supplementary quantitative tables could not be retrieved from the available official endpoints.
- GPST000405: a complete muropeptide table exists, but its peptide-crosslinked peptidoglycan oligomers need an appropriate representation rather than an incorrect glycan class.
- GPST000712: the supplied log10-labelled data additionally show feature-wise centering/scaling. Original parameters are unavailable, so a scientifically valid inverse transformation cannot be reconstructed.
- GPST000216: additional structure-to-quantification review could not be completed because access to the relevant content was restricted.

GPST000562 has an accepted CS/DS disaccharide matrix; an additional long-form glycopeptide supplement is not claimed to be curated by that object.

## Sources and licensing

Original public source files, their publisher or repository URLs and checksums are recorded beside each accepted accession. Externally hosted publisher supplements are restored by `source-recovery.json` and `recover-sources.R`; they are not relicensed as MIT. The MIT license covers package code. Original data attribution and applicable source terms are retained in each object's provenance. Numerical facts and transcribed molecular evidence are kept distinct from redistribution of complete publisher documents.

No source payload for an excluded or unresolved accession is included. Existing curated datasets remain unchanged in scientific content; the build and validation report records the comparison.
