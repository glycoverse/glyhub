# Literature cache recovery, 2026-11-07

This recovery updates staged registrations only. It does not publish assets,
create release URLs, or modify the 105 baseline release manifest rows and their
97 curated metadata rows. Reference commit: `18f7e58862eeac132357c2e6b950ce5de7c5c569`.

## Identity and provenance

`original-manifest.tsv` preserves the full frozen manifest from that commit
(SHA-256 `a46205348065e06f0db056d41b48d91e521bea4b846aee3af77c2ba445c94913`).
`asset-map.tsv` records historical and current hashes and sizes for all 79 staged
assets: 47 curated objects and 32 processed-source representations. Of these,
54 match the historical SHA-256 and size exactly: 27 curated RDS, three deidentified
raw-source RDS, and 24 original non-RDS source files. Twenty curated and five
raw-source RDS have genuinely new bytes. Their manifest, receipt, catalog and
reviewed-scale hash bindings are updated where applicable. No scientific catalog
fields, scale judgments, source-input checksums, or public URLs are changed.

Exact historical RDS were reconstructed with the documented earlier serialization
recipe. For the 27 curated objects this removed only scale metadata introduced by
the later builders, including embedded experiment scales. The registered loader
adds reviewed scale metadata without changing the disk bytes. Whole-object
identity after removing only those loader-added scale fields was verified.

The other 20 curated outputs did not match after the same justified operation.
Their residual historical-byte differences remain unexplained without the original
runtime or bytes. Recompression diagnostics yielded no additional matches. No
arbitrary metadata changes or guessed serialization settings were used to force a
match. New outputs are explicitly new artifacts, not recovered historical bytes.

## Reproduction and verification scope

Curated reconstruction used the study-specific builders at the reference commit,
with their SHA-verified quantitative inputs. The eight deidentified processed-source
RDS used the unchanged `build-source-derivatives.R` recipe and original source
specifications. Source URLs, input digests, licensing and conversion semantics stay
in the accession-specific receipts and source specifications under `data-raw/`.
Original human-subject files remain private local reproduction references; they are
not included in this report or intended for release. Deidentification is not a
claim of guaranteed unlinkability to public sources.

RDS serialization is not asserted to be byte-reproducible across R/dependency
versions. Current validated artifacts were built with R 4.6.1 and glyexp 0.18.0.
The current SHA-256 values identify the actual files tested. A subsequent rebuild
must verify its own digest and scientific content; it must never be renamed to an
old digest without a matching hash. The 54 exact historical artifacts retain their
original registrations rather than replacing them with later equivalent objects.

The complete test cache is assembled from verified files via hardlinks in an
independent workspace. Each of 79 files is checked against its current manifest
size and SHA-256 before linking. Staged loading requires this maintainer cache;
there is no published download URL. These staged entries do not promise ordinary
users automatic remote retrieval.

Validation results are recorded below after execution. Fixtures and synthetic
constructor tests are reported separately from actual cache validation. Older
released resources unavailable to the local check are not counted as real-data
coverage merely because unrelated fixture tests pass.

## Executed checks

On macOS with R 4.6.1, the complete testthat suite passed 1,545 assertions with
zero failures, errors or warnings under both glyexp 0.19.0.9000 (isolated library)
and glyexp 0.18.0. Sixteen tests for older released-resource maintainer source
assets were skipped because those separate files were unavailable. None of the
literature scientific tests were skipped. The actual-cache blocks include 628
matrix assertions, 99 processed-source loader assertions and 56 merged-experiment
roundtrip assertions. An additional whole-cache audit covered all 47 curated
objects, including 9,833,288 cells, raw-abundance preservation, zero/missing masks,
structural missingness, valid objects, dimensions, and reviewed scales.

Separate structural/builder checks passed 69 assertions under both dependency
versions. These include synthetic constructor tests and are not real-data proof.
The source-tree receipt check passed 348 assertions across all 79 staged receipts;
the package regression checks all 32 source-only metadata/provenance hash bindings
without confusing them with CPTAC's dual-kind registrations.

Re-run from the repository root with the complete cache and the intended glyexp
library available:

```sh
export GLYHUB_LITERATURE_CACHE=/absolute/path/to/verified-cache
Rscript -e 'devtools::test(stop_on_failure = TRUE)'
Rscript data-raw/_shared/scripts/test-literature-scales.R
Rscript data-raw/_shared/scripts/test-literature-receipts.R
Rscript -e 'devtools::check(document = FALSE, args = "--no-manual")'
air format --check .
```

Before using the cache, verify every file against `inst/extdata/manifest.tsv`.
The cache must use `<version>/<sha256>-<filename>` paths. The complete staged
cache totals 779,706,550 bytes. Source-input archives and human-subject originals
are not needed for offline loading and are not included in this cache.

Independent read-only privacy/content review checked the actual selected seven
human-subject curated objects and eight raw derivatives, including nested metadata,
feature annotations, source tables/records, masks, and every alternative assay.
All eight raw derivatives were checked against original input cells and NA/zero
states; five curated objects were compared directly with original quantitative
cells and the two ovarian ratio objects with independently checked raw derivatives
and their documented `2^x` transformation. No confirmed privacy defect was found.
This bounded review does not claim guaranteed anonymity or perfect detection of
all identifying text. No original subject identifiers, correspondence tables or
individual clinical covariates are intentionally included in the staged derivatives.

Final clean-source `R CMD check --as-cran --no-manual` with glyexp 0.19.0.9000
completed with **0 errors, 0 warnings, 0 notes** and status OK. `air format --check .`
passed. A generated README HTML preview was excluded before this final source
package was built. Devtools also printed a non-check Quarto version-probe warning
from sandboxed `sysctl`; it did not affect the R CMD check result.
