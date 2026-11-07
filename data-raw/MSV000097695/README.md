# MSV000097695: adult-worm N-site quantitative output

Run from the package root:

```sh
Rscript data-raw/MSV000097695/build.R /path/to/MSV000097695 /path/to/cache
```

Acquire the exact deposited file named in `source.json` using its public URL.
Keep the recorded hash-prefixed local filename, or rename the verified source
file to that filename. The builder verifies SHA-256 before reading and performs
no network requests. RDS outputs are ignored under the shared artifacts folder;
the catalog entry is staged without a public download URL.

The selected complete 3,274-by-6 matrix is the author's latest N-site output,
not the later normalized/imputed publisher table. All 1,129 numeric zeros remain
zero. Female/male labels follow the depositor's explicit prefix mapping. Replicate
independence is not established; these are whole adult worms, not separate
mass-spectrometry tissue samples.

The 585 multi-protein/site groups remain intact, with scalar protein/site fields
unknown rather than guessed. Source composition notation is retained. H/N/F/X/HA
have supported composition mappings; the 16 rows involving A/G retain unknown
typed compositions pending explicit token definitions. No structures are inferred.

MassIVE labels the deposited dataset CC0-1.0. This does not transfer that license
to the publisher's CC BY-NC-ND supplements. Related protein and modification
outputs are alternative aggregation levels, not additional cohorts. The O-output
requires separate interpretation because it precedes the author's N-contaminant
filter and differs numerically from the final supplement; it is not silently
included as a pure-O matrix.

`validation.json` records an independent reread and exact comparison of all 19,644
matrix cells. The receipt pins the resulting RDS hash. Cite the original study
and accession when reusing these data.
