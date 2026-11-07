# Mixed O-enrichment source table

`glyhub_MSV000097695_OEnrichment_MixedSourceSites` is a `kind="raw"` source path, not a curated SE. The unchanged CC0 MassIVE 2025-12-01 author site table contains 674 records and six intensity measurements, including N contamination. It is **not** the filtered 258-row pure-O publisher table; no filter, transformation, inferred dictionary or topology is applied. Female/male run mapping and unknown replicate type are recorded in `source-assets-additional.json`. Glycan type is explicitly unknown/mixed. This repository grant does not apply to the publisher NC-ND supplement.

Retrieve the exact source URL/hash recorded in the JSON, then run `Rscript data-raw/MSV000097695/build-additional-sources.R <source-directory> <cache>`. Source zeros and all annotation/blank columns remain unchanged.
