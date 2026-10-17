# CPTAC JHU glycoform-peptide resources

Build from the supplied `glycoproteome` directory (with `data/` and
`description/` children), from the glyhub package root:

```sh
Rscript data-raw/CPTAC/test-convert.R
Rscript data-raw/CPTAC/build.R /path/to/glycoproteome
```

`assets/` is ignored by Git. The build emits byte-preserving `.tsv.gz` sources,
validated `GlycoproteomicSE` RDS objects, the source documentation and manifest.
All files are distributed externally through the consolidated `glyhub-data-v1`
release. Run `Rscript data-raw/_shared/package-resources.R` after building to refresh the
unified manifest and stage all resources. The CPTAC source manifest retains the
original data-version provenance; the unified manifest supplies current URLs.

The manifest records the source SHA-256, local source MD5, asset SHA-256, asset
bytes, dimensions, storage and pinned URL. Code changes alone do not overwrite
published assets. To revise data, choose a new data tag in `build.R`, rebuild,
validate, then publish a new release and commit its manifest with the code.

## Quantitative representation

JHU documentation defines abundance as log2 reference intensity plus normalized
log2 ratio. The assay therefore uses `2^source_value` to satisfy glyexp's
non-negative linear-abundance contract. This inversion does not undo upstream
normalization or reconstruct raw MS intensities. Original log2 values remain in
`metadata(x)$raw_abundance`. `None` becomes `NA`; zero becomes 1 in the assay.
No filtering, imputation, aggregation or new normalization is applied.
Original tables remain byte-identical inside the gzip archives.

`Intensity.Reference` is a feature annotation, not an observed patient.
Source measurement names remain intact. Only explicit `.T`/`.N` suffixes
(including ` - set ...` repetitions) yield tissue/participant labels. Reference
and QC labels are recognized separately; other roles remain unresolved.
Source sequences are retained; duplicate row names receive unique suffixes.
N/H/F/S/G composition notation is interpreted as HexNAc/Hex/Fuc/Neu5Ac/Neu5Gc.
No structures or absolute protein sites are inferred. The gene column does not
supply protein accession IDs, so `protein` and `protein_site` remain `NA`.

## Provenance boundaries

CCRCC, HNSCC, LSCC, LUAD and UCEC match the accompanying original MD5 list.
COAD and PDAC match CRC and PDA after reversing cohort prefixes in sample names.
HGSC does not match that list; its source fractionation identity is unverified.
We archive the supplied local files rather than claiming every archive is an
unchanged upstream download. SHA-256 protects the distributed local versions.

Source portal: https://pdc.cancer.gov/pdc/cptac-pancancer
Data-use guidelines: https://pdc.cancer.gov/pdc/data-use-guidelines
Source data are not covered by glyhub's MIT code license. Cite the relevant
CPTAC primary studies and acknowledge the consortium as requested by PDC.
The source documentation is distributed with the release for provenance.

After building, run `Rscript data-raw/_shared/package-resources.R` to refresh the unified
manifest and stage all external resources. Public access uses `glyhub_load()`.
