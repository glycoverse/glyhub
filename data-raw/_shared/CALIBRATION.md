# Current follow-up status

Four additional project decisions have been implemented after the initial calibration: GPST000125 includes three original-workbook-verified N/O/GSL profiles, GPST000381 uses the expression-table labels, GPST000578 includes nine complete panels in three compatible measurement groups, and GPST000602 includes five explicitly annotated-only, source-peak containers. The current catalog has **34 datasets from 17 projects**, of which 30 datasets are from fifteen newly accepted pilot projects. GPST000168 is deferred from this batch; no Other-type schema extension is proposed. Four projects remain excluded for lack of an eligible quantitative matrix or identification-only content. These additions do not make the original purposive calibration a representative sample.

GPST000125 contributes N 41 × 16, O 14 × 16 and GSL 12 × 16 percent-relative-abundance profiles. All 1,072 primary quantities are verified against the preserved original `mmc5.xlsx`; the 304 assay zeros become NA while original values remain recoverable. Its 67 features have 66 supported compositions and 25 single-source, registry-backed structures. Six original annotation-conflict flags remain, including unresolved N feature 17, whose composition and structure stay NA without dropping its measurements. The eight conditions each have two biological replicates according to the article methods. No explicit reuse license for this publisher supplement has been independently verified.

GPST000602 has 1,607 retained annotated source peaks, 729 excluded unannotated records, and 11,534 explicitly unmeasured off-spectrum matrix entries. Its rows must not be interpreted as a cross-sample aligned molecular feature table. All original values and exclusions remain traceable. Eighty-two source mass-error review indicators are recorded without correcting their measurements or silently filtering them.

GPST000578 has 1,516 selected source cells. Ten Figure 4b cells are read from an independently verified worksheet-only BIFF snapshot because readxl/libxls can substitute embedded chart-cache values. The original XLS is unchanged, and a standard-library BIFF verifier plus ten-cell regression fixture are included. The article license and unmatched Panorama CC BY deposit license are recorded separately; neither establishes a verified independent license for these publisher-hosted Source Data matrices. GPST000602 source-license scope is likewise explicit. Package code licensing does not replace source-data terms.

GPST000599 retains its primary quantitative workbook, clinical source-cell snapshot and clinical sample mapping in Git. The unchanged 20,679,775-byte `mmc4.xlsx` is excluded from Git and recoverable through the documented public archive URL and SHA-256-pinned script in `GPST000599/SOURCE-RECOVERY.md`. The build requires the original and stops on download or checksum failure. Public-download verification is pending; no successful recovery is claimed here. Current retained-source byte counts in the ledger exclude this separately stored workbook.

The initial calibration below is retained as a dated historical record. Its inclusion fraction, storage measurements and 22-object count describe that earlier snapshot, not the current catalog. The current ledger and object inventory supersede its per-project statuses and dimensions.

---

# Initial twenty-project calibration (07:58 UTC snapshot)

Twenty deliberately selected public projects were reviewed, prioritizing higher-impact publications while spanning publication years, glycan classes and table formats. The review is not a random sample of GlycoPOST and its acceptance rate is not a population estimate.

Eleven projects supply accepted full source-defined quantitative matrices. Together they contribute 18 datasets after study/type consolidation. Existing GPST000643 contributes two consolidated datasets; the two GPST000738 enzyme datasets remain separate because their relative-abundance denominators are different. The package contains 22 datasets from 13 projects. Inclusion does not imply that every experiment from each paper has been reconstructed.

The remaining nine candidates are recorded individually in `pilot20-ledger.csv`: three lack a complete source-defined sample matrix (GPST000580, GPST000301, GPST000297), one is an identification library (GPST000038), one has unavailable supplementary data (GPST000125), one has unresolved sample-label contradictions (GPST000381), one lacks reliable feature alignment (GPST000602), one requires an unsupported peptidoglycan representation (GPST000168), and one has usable technical matrices but unresolved redistribution terms (GPST000578). The last status is not a finding that its data are defective or legally prohibited.

## Data conventions and consolidation

Only quantitative assay zeros become NA. Original values, source nonnumeric/missing entries, conservative conflict exclusions and unmeasured union combinations remain separately recoverable. No raw-MS reprocessing, imputation or replicate averaging is performed. Unknown annotations do not remove measured rows. Composition, structure, protein site and replicate metadata are recorded only at the precision supported by the source.

- GPST000035: 415 source features align to 153 author glycan-number keys using composition, retention-time and relative-area evidence. Another 78 retain distinct source identities. The result is 231 features across 66 observations, including three fetuin QC observations.
- GPST000213: 130 cerebellum peaks share an explicit author M444 reference between sexes. Other panels remain separately identified within N/O union matrices. Four fully duplicated source columns are conservatively quarantined in the quantitative assay; their 520 original values remain available. Duplication alone does not establish an author error or misconduct.
- GPST000643: only unique, internally specified structural identities are aligned. Source composition/structure conflicts remain distinct and documented. All former panels can be reconstructed through `metadata(x)$panel_maps`.
- GPST000431: source composition-defined features align across dose, starting-amount and precision experiments. Blank samples and experimental distinctions remain in colData.
- GPST000374: O-Xyl/O-Man/O-GalNAc peak areas combine across the same seven source observations. Original subtype-normalized percentages remain source annotations and are not treated as total-O relative abundance. Source structures with floating attachment candidates preserve that uncertainty.
- GPST000676: the eight author HS-disaccharide labels align across two zebrafish experiments. Repository raw-file sample counts do not support a reliable one-to-one mapping to all published observations.

Each merged object retains its panel-level rowData, colData, metadata and original measurements. `panel-name-mapping.csv` records name changes. Obsolete panel data objects are not distributed in parallel.

## Reproduction

From the repository root, run `source("data-raw/_shared/build.R")`, then `source("data-raw/_shared/document-data.R")`. Required R packages include glyexp, glyrepr, jsonlite, readxl, S4Vectors and SummarizedExperiment. glyexp/glyrepr are available from the glycoverse r-universe; Bioconductor supplies the Bioconductor classes. `validate-reproduction.R` checks canonical scientific contents across a complete rebuild. The GPST000035 alignment and GPST000128 source-JSON reconstruction also have independent Python checks.

Primary sources and accession-specific mappings are retained under `data-raw/<accession>/`. Each file is checksum-pinned. Source terms are documented independently of the package code license. Sources and derived objects for nonincluded projects are absent from the distributed repository; the ledger retains URLs and reasons.

## Timing and scaling limits

Object-build elapsed times and compressed sizes are measured in `object-inventory.csv`; `panel-inventory.csv` retains the panel measurements. Review start/end timestamps are retained where observed. Active review and downloaded-byte counters were not uniformly instrumented: blank values mean unavailable, not zero. Retained-source byte counts are storage measurements, not network traffic.

The calibration includes one-time environment setup and a mid-batch study/type consolidation. A naive extrapolation of total elapsed time across all 456 public projects would conflate setup, literature access, annotation complexity and extraction work. Use the observed 11/20 inclusion result and object sizes only as a purposive-sample scenario, not as a forecast or confidence interval. Additional reviewed batches are needed for a stable throughput estimate.

The 18 newly accepted data files total approximately 0.88 MiB (917,756 bytes in the checked build). Per accepted project, compressed data range from 5,648 to 321,640 bytes; the median is 35,252 bytes and mean is 83,432 bytes. All 22 distributed data files total about 1.18 MiB. Accession source files, mappings and audit material occupy about 36 MiB before archive compression, dominated by the clinical supplementary workbook. Serialized structure runtime IDs can slightly change byte sizes between equivalent builds.

As a storage-only illustration, applying the observed 55% acceptance fraction and mean accepted-project size to 456 public projects gives about 20 MiB of compressed data objects; assuming all 456 yielded comparably sized accepted data gives about 36 MiB. These are explicitly conditional scenarios, not bounds: glycopeptide matrices, larger cohorts, richer annotation and source retention could increase sizes substantially. Source archives and human review costs are not captured by these data-object figures. The measured new-panel construction subtotal is about 13.4 seconds; this excludes source retrieval, scientific review, structure interpretation, environment setup and study-level merging and must not be presented as end-to-end throughput.
