# PXD013627: N-glyco-enriched protein abundance

```sh
Rscript data-raw/PXD013627/build.R /path/to/supplements /path/to/cache
```

Run from the package root. Retrieve the two `archive_member` files in
`sources.json` from its public Europe PMC supplementary archive URL. Preserve
their original filenames. SHA-256 is checked before reading; the builder makes
no network requests. Generated RDS files are ignored; staged entries have no
public release URL.

The complete author `Sample quantities` tables are 892 protein groups by 33 human
cell-line samples and 147 protein groups by 28 mouse B-cell samples. They retain
the author's normalized MSstats **log2** abundances, not reconstructed raw
intensity. All values happen to be nonnegative and fit the container contract
without inverse transformation. Literal source `NA` remains missing; 12,452 and
2,358 missing cells are retained, respectively.

These are protein-level measurements from N-glyco-enrichment, not intact-glycan
or site-specific quantitative features. Glycan compositions and protein sites
are unknown; qualitative glycosite tabs are not attached as quantitative keys.
The author's protein-group and primary-entry annotations are both retained.
Technical runs were consolidated upstream. The mouse methods mention 31 samples,
but the supplied complete table has 28 columns; no missing columns are invented.

The original-author supplemental tables accompany a CC BY 4.0 article. No
separate restriction was identified in the selected files; the article's
third-party exception is not assumed to license unrelated comparison data.
Source URLs, hashes, license evidence and attribution are recorded. Changes are
limited to container representation and explicit missing-value parsing.

`validation.json` records exact comparisons of all 33,552 source cells. Total
proteome controls and group/statistical summaries are not additional datasets.
