# Changelog

## glyhub 0.1.0

- Initial release with 97 curated glycomics and glycoproteomics
  datasets: 75 from GlycoPOST, eight from CPTAC, and 14 from other
  published studies.
- [`glyhub_catalog()`](https://glycoverse.github.io/glyhub/reference/glyhub_catalog.md)
  lists datasets as a tibble with source, experiment and glycan types,
  structure availability, quantification descriptions, dimensions, and
  download metadata.
- [`glyhub_load()`](https://glycoverse.github.io/glyhub/reference/glyhub_load.md)
  and 97 dataset-specific loaders retrieve `GlycomicSE` or
  `GlycoproteomicSE` objects from a versioned data release, verify file
  size and SHA-256 checksums, and support cached offline loading. CPTAC
  loaders also provide verified raw source archives.
- Dataset documentation describes source annotations, abundance scales,
  missing-value conventions, processing records, and source-data
  licenses. Curated objects retain source numerical values and
  provenance in metadata.
