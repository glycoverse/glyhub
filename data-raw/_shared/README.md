# Shared data infrastructure

This directory contains cross-project infrastructure. Dataset-specific sources,
converters and evidence live in the accession directories under `data-raw/`.
Run commands from the package root.

| Location | Contents |
|---|---|
| `build.R` | Entry point for the historical GlycoPOST build pipeline |
| `scripts/` | Shared builders, source recovery, compression, documentation and validation tools |
| `metadata/` | Build inputs: dataset descriptions, panel mappings and source checksums |
| `reports/` | Audit reports, generated inventories, validation results and historical records |
| `logs/` | Check and validation logs |
| `artifacts/` | Generated local build and release staging files; ignored by Git |

The `noncptac/` subdirectories within these categories hold shared infrastructure
for PRIDE, iProX, MassIVE and jPOST projects. For example, scripts are in
`scripts/noncptac/`, release manifests and source decisions in
`metadata/noncptac/`, and validation results in `reports/noncptac/`.
Some reports are consumed by release verification; retain them with the inputs.

## Commands

```sh
Rscript data-raw/_shared/build.R
Rscript data-raw/_shared/scripts/test-compact-specs.R
Rscript data-raw/_shared/scripts/noncptac/build.R ../evidence ../noncptac-cache
```

See the [non-CPTAC guide](reports/noncptac/README.md) for source prerequisites
and release verification, and [storage documentation](reports/RESOURCE-STORAGE.md)
for resource distribution. Directory organization does not alter dataset values.
