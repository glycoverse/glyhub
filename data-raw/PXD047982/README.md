# PXD047982: source-run PSM quantities

Run `Rscript data-raw/PXD047982/build.R /path/to/PXD047982 /path/to/cache`
from the package root after acquiring the 16 exact files pinned in `sources.json`.
The builder checks every SHA-256 and makes no network requests.

Each of 16 objects is one actual source run and one MonoArea measurement column.
All 5,745 PSM rows remain separate, including repeated molecular features.
GlySpec, Scan, IsotopeArea, corrected quantities and negative annotation sentinels
are retained verbatim. Quantitative metrics are not extra biological samples.
There is no molecular alignment, aggregation, filtering, filling or normalization;
these objects are not an aligned cross-run study matrix.

Age, lectin enrichment and source replicate labels are traceable to deposited
files. Authors report four biological replicates within each age/lectin group;
matching across lectins is not established, so 16 independent animals must not
be inferred. The actual internal RawName is retained alongside deposition labels.
Source composition and plausible-structure notation remain available, without
an unverified conversion to typed glycans or absolute protein sites.

iProX's specific dataset policy applies CC0 to all datasets submitted after
2023-03-23. The public project endpoint verifies this deposit's submission as
2023-12-20 15:15:15.0. `sources.json` records policy and project evidence hashes,
identity, date, URL and the generic website-content clause's scope ambiguity.
The specific dataset grant is the basis for these repository files, not an
invented per-file licence tag. It does not cover the publisher's NCND supplements
or copying website prose. No new release is published.
