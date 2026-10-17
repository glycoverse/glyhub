CPTAC JHU GENCODEv34 N-glycoform-peptide abundance resources for glyhub.

Eight supplied cohorts: CCRCC, COAD, HGSC, HNSCC, LSCC, LUAD, PDAC and UCEC.
Each cohort has a byte-preserving source TSV gzip archive and a curated
GlycoproteomicSE RDS. manifest.tsv contains pinned filenames, SHA-256 hashes,
sizes, dimensions and upstream verification status. The accompanying JHU
README, methods document and MD5 list are included for provenance.

The curated assay is 2^source log2 abundance; the complete original log2 matrix
is retained in metadata. None becomes NA. No features or measurement columns
are filtered or aggregated. Reference and QC columns remain annotated.
Protein accessions and absolute sites are unavailable and remain NA.

Five files match the upstream MD5 list exactly. COAD and PDAC match CRC and PDA
after reversing cohort-prefix renaming. HGSC is a supplied local version that
has not been matched to that list; fractionation identity remains unverified.

Data source: https://pdc.cancer.gov/pdc/cptac-pancancer
Data-use and attribution: https://pdc.cancer.gov/pdc/data-use-guidelines
The package's MIT code license does not license the source data.

These assets are versioned separately from software releases. Existing assets
must not be overwritten; corrections require a new data version and manifest.
