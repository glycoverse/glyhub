# Data sources and reuse

The package code is distributed under MIT. That does not replace the licenses or terms associated with independently published data, supplementary documents, molecular drawings or third-party databases.

Each dataset identifies its article DOI, GlycoPOST accession, source table and original file checksum. Where available, the original license statement is retained in object provenance. Users should cite the original study and observe its applicable terms.

The expansion stores extracted quantitative facts and reviewed molecular annotations, with original sample codes and explicitly documented missingness. Complete publisher supplementary documents with uncertain or restrictive redistribution terms are kept at the original provider: `source-recovery.json` records an official download URL, exact archive member path where necessary and SHA-256. `recover-sources.R` validates recovered contents before a build. A missing or changed source stops reconstruction rather than silently using different data.

Clinical metadata in public cohorts retain coded sample identifiers and published field definitions; absence of a field means it was not available or could not be matched unambiguously. Do not interpret missing measurements or uncertain glycan annotations as biological absence. The package does not provide a legal determination of downstream reuse rights.
