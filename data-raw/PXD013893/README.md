# Plasma EV enrichment method comparison

```sh
Rscript data-raw/PXD013893/build.R /path/to/verified-members /path/to/cache
```

Use `source.json` to retrieve and verify the PRIDE CC0 archive and exact MaxQuant
member. The offline builder checks the member SHA-256. The repository project
matches the article title and investigators; its references field is empty, so
this is not presented as an explicit repository DOI citation.

The 1,527 author deamidation site-group records contain six technical
measurements: three glyco-only and three sequential phospho-then-glyco enrichments
of human plasma extracellular vesicles. These are not six independent patients.
The complete native intensity matrix contains 2,485 zeros and no missing cells.
No downstream Perseus processing, normalization, filtering or imputation is added.

Source rows include **15 reverse controls and 19 potential contaminants, with no
overlap**. `row_role`, `source_reverse` and `source_potential_contaminant` make
these explicit; not all rows represent confirmed biological glycosites. Typed
protein/site fields are unknown for these controls. Ambiguous source protein/site
groups remain unchanged rather than being expanded or arbitrarily assigned.
The complete author table is retained, including multiplicity alternatives,
localization scores and control flags. Scores/counts are not used as abundance,
and multiplicity channels do not become extra samples. No glycans are inferred.
