# Source data and reproduction

Run all commands from the package root.

- `GPST*/`: one GlycoPOST source project per directory, including original
  source files, matrix specifications, build scripts and provenance.
- `PXD*/`, `IPX*/`, `MSV*/`: one source project per directory, including its
  builders, converters, receipts and project-specific license evidence.
  Multiple experimental objects from the same project stay together.
- `CPTAC/`: all CPTAC cohorts and their shared build/validation pipeline.
- [`_shared/`](_shared/README.md): cross-project infrastructure, organized into
  `scripts/`, `metadata/`, `reports/`, `logs/` and `artifacts/`.
  Each category has a `noncptac/` subdirectory where needed for shared
  PRIDE/iProX/MassIVE/jPOST workflows. Generated artifacts are ignored by Git.

## Build and validate

```sh
Rscript data-raw/_shared/build.R
Rscript data-raw/_shared/scripts/test-compact-specs.R
Rscript data-raw/_shared/scripts/noncptac/build.R ../evidence ../noncptac-cache
Rscript data-raw/CPTAC/build.R
```

See [the non-CPTAC guide](_shared/reports/noncptac/README.md) and
[CPTAC/README.md](CPTAC/README.md) for source prerequisites and verification
commands. Building datasets requires the original source inputs described there.
The shared staging directories are generated outputs, not additional datasets.
