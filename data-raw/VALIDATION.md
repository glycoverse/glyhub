# Validation — 14 October 2026

- Both accession build scripts run from the package root with pinned source
  checksums, using data-raw/build.R as the shared entry point.
- validate-reproduction.R compares all eleven rebuilt objects: assay values,
  canonical structure/composition annotations, colData and complete provenance.
  Scientific contents are identical. Byte hashes are not a reproducibility
  criterion because serialized igraph structures contain runtime identifiers.
- devtools::test(): 173 passed, zero failures, warnings or skips.
- devtools::document() and pkgdown::check_pkgdown(): passed.
- Installed into /tmp/glyhub-current-lib: eleven datasets listed; all eleven are
  accessible with package::object and satisfy methods::validObject().
- R CMD check --no-manual, R 4.6.1/macOS arm64: 0 errors, 0 warnings, 0 notes.
  Full log: 00check.log. This verifies packaging, not author-level source validity.
- README.Rmd was rendered to README.md against that installed package using
  rmarkdown::render. devtools::build_readme was attempted but pak could not resolve
  glyexp from its package index, despite the working local installation. This
  dependency-index limitation remains; it did not prevent rendering or R CMD check.
- README relative links resolve and the approved PNG checksum is unchanged.
- data-raw groups inputs/scripts under GPST000643/ and GPST000738/, with shared
  entry points and audit documents at its root; no date-based directories.
  Rejected-study raw
  inputs and obsolete staging copies were moved to recoverable macOS Trash;
  cleanup-receipt.tsv records the destinations. No Trash was permanently emptied.
- No commit, push, PR, CI rerun, release or deployment was performed.

## Scientific limits

GPST000738 has explicitly masked source-table conflicts and unmatched processed
observations; it is not a complete recovery of the final author analysis matrix.
GPST000643 includes seven complete SI tables (S10B and S10C split N/O), not every study
experiment. Two source annotation count conflicts and two unparsed composition
labels are marked. Putative structures remain putative, and sample identity or
biological replicate status has not been invented. See AUDIT.md.

## Accession-directory reorganization verification

After moving inputs and scripts into GPST000643/ and GPST000738/:

- The shared build.R entry point rebuilt all ten objects successfully.
- validate-reproduction.R confirmed assays, canonical annotations, conditions
  and complete provenance identical to the objects before the move.
- All 151 tests passed again (zero failures/warnings/skips).
- README.md was regenerated from README.Rmd; relative links and git diff --check
  passed. No excluded sources were restored and cleanup history was preserved.
- The R CMD check result above is from the preceding data-content validation;
  this directory-only change was verified with rebuild/content checks and tests.

## Dataset documentation validation

- Ten distinct dataset descriptions and experiment-specific Details were
  generated from dataset-descriptions.json by document-data.R.
- All ten reference pages rendered with Details, Source and a working link to
  the shared measurement/annotation conventions. README and local site were
  regenerated. No vignette directory is present.
- Measurement matrices, canonical molecular annotations, colData, source tables,
  original values, masks and counts match the preceding objects. Changes to
  objects are restricted to explanatory zero-handling text, one processing-reason
  label and the source-license scope wording.
- Instruction-origin phrases were absent from README, R/Rd documentation,
  rendered pages, build scripts, ledgers and the revised explanatory metadata.
- Tests: 151 passed. Final R CMD check --no-manual: 0 errors, 0 warnings, 0 notes
  (00check.log). Documentation index and cross-references passed.
- This preceding documentation-only check was superseded by the S10C split below.

## S10C partition validation

- Exact source matches assign S10C rows 8–10 to O and 11–12 to N; see AUDIT.md.
- Eleven objects are now distributed. S10C O is 3 × 15 and N is 2 × 15.
- Compared with the saved five-row object, all 75 measurement positions,
  canonical molecular annotations, observation columns, original values,
  source tables, ledger records, masks and counts are conserved. The other
  nine objects retain their scientific contents and provenance.
- Source annotation list containers are canonicalized as plain lists for
  comparison: S4Vectors may select different list subclasses depending on
  loaded namespaces. This does not change annotation values.
- All 173 tests pass without failures, warnings or skips.
- The shared rebuild reproduced all eleven objects with identical scientific
  contents and complete provenance; conservation checks passed again afterward.
- Installed dataset access and validity checks passed for all eleven objects.
- Final R CMD check --no-manual: 0 errors, 0 warnings, 0 notes (00check.log).
- README and eleven dataset reference pages regenerated; relative links,
  package documentation index and git diff --check passed. Approved logo hash
  is unchanged. No commit, push or deployment was performed.
