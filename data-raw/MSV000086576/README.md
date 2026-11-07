# MSV000086576: deidentified author-processed source representations

The published source entry is now a **deidentified RDS derivative**, not the original human attachment. Selected quantitative values, signed scale, zeros, missing values and necessary study design are retained; original participant labels and individual clinical covariates are excluded. New study-local labels are not a guarantee against re-identification from public data.

Rebuild using `Rscript data-raw/privacy-review/build-source-derivatives.R /path/to/verified-original-inputs /path/to/cache`. Original attachments are SHA-verified local inputs only, not publishable assets. See `data-raw/privacy-review/README.md` and `source-derivatives.json` for the exact selected assay and provenance.

`glyhub_load(id, kind="raw")` returns the verified derivative file path, not instrument raw intensity or a curated SE. Signed source values remain unchanged. PXD019914 alone has separate curated objects using its documented `2^log2-ratio` conversion; this does not alter its source derivative.

No data release is created. Source licence and attribution apply to the derivative and remain in the provenance and receipt.
