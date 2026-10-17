# Source data and reproduction

Run all commands from the package root.

- `GPST*/`: one GlycoPOST source project per directory, including original
  source files, matrix specifications, build scripts and provenance.
- `PXD*/`, `IPX*/`, `MSV*/`: one source project per directory, including its
  builders, converters, receipts and project-specific license evidence.
  Multiple experimental objects from the same project stay together.
- `CPTAC/`: all CPTAC cohorts and their shared build/validation pipeline.
- `_shared/`: cross-project build utilities, inventories, provenance summaries,
  documentation and validation logs. `_shared/noncptac/` contains the shared
  orchestration, conversion helpers and release records for PRIDE/iProX/
  MassIVE/jPOST projects; project-specific scripts live in the accession folders.
- `_shared/bundled-build/` and `_shared/releases/`: ignored build and release
  staging outputs. `_shared/noncptac/assets/` is also an ignored staging area.

## Build and validate

```sh
Rscript data-raw/_shared/build.R
Rscript data-raw/_shared/test-compact-specs.R
Rscript data-raw/_shared/noncptac/build.R ../evidence ../noncptac-cache
Rscript data-raw/CPTAC/build.R
```

See [_shared/noncptac/README.md](_shared/noncptac/README.md) and
[CPTAC/README.md](CPTAC/README.md) for source prerequisites and verification
commands. Building datasets requires the original source inputs described there.
The shared staging directories are generated outputs, not additional datasets.
