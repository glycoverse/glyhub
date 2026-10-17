# Compact matrix specs

The GPST000671 and GPST000296 glycoproteomics specs use the versioned
`glyhub-compact-specs-v1` envelope. Other specs retain their existing format.
Use `read_matrix_specs()` from `build-matrix-specs.R` to read either format.
In Python, `unpack()` in `compact-specs.py` provides the equivalent decoder.

This is a storage change only. The builder expands the specs before processing,
source-value validation or metadata construction. No measurements, missingness,
source coordinates, annotations or provenance are discarded.

* `runs`: a rectangular matrix is flattened in row order and stored as
  `[count, value]` runs with its original dimensions. Null, zero and other values
  remain distinct. This compresses repeated missing positions and coordinates.
* `records`: annotation keys are stored once, followed by ordered value rows.
  Nested values and explicit null fields are preserved.
* A field is encoded only when that encoding is smaller than the original.

After regenerating either spec with its original representation, run:

```sh
python3 data-raw/_shared/compact-specs.py data-raw/GPST000671/glycoproteomics-matrix-specs.json data-raw/GPST000296/glycoproteomics-matrix-specs.json
Rscript data-raw/_shared/test-compact-specs.R
```

The compactor verifies a lossless Python round-trip before writing and can be
rerun on compact files. Update their entries in `source-checksums.csv` after any
byte-level change. Source workbook checksums inside the specs are unchanged.
Do not apply this format to other specs without updating their direct readers.
