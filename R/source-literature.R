#' Author quantitative literature source representations
#'
#' Selected author quantitative source representations preserve their signed scales and
#' record grain or alternative method outputs without forcing a curated matrix.
#'
#' @details
#' Use [glyhub_catalog] with `kind = "raw"` and [glyhub_load] with the same kind.
#' The result is a hash-verified file path, not an SE. These source-file entries
#' have no same-named convenience function; some have separate curated objects. Here
#' `"raw"` denotes the source asset, not raw spectra or unprocessed intensity.
#' Of the 32 newly staged source entries, 24 retain original source bytes and
#' eight are explicitly deidentified RDS derivatives. The latter contain unchanged
#' quantitative values and necessary analysis groups, but omit original subject
#' labels and individual clinical covariates. No original-to-new subject map is
#' published. This is not a guarantee against re-identification from public data.
#' Entries are locally staged with no release URL and require a seeded cache.
#'
#' PXD019914 provides `glyhub_PXD019914_N_Intact_AuthorProcessed` (15,512 by 129)
#' and `glyhub_PXD019914_N_SPEG_AuthorProcessed` (5,115 by 129). Each deidentified
#' RDS retains the selected numerical values and biological feature annotations.
#' Measurements are author-normalized log2 ratios: 119 TCGA tumors plus ten
#' explicitly labelled quality controls, not 129 independent patients. Original
#' negative values, zeros and missing values are unchanged. SPEG is deglycosite
#' data, not intact glycoform abundance. Separate `Intact_RelativeRatios` and
#' `SPEG_RelativeRatios` curated objects apply 2^x specifically to this study's
#' explicitly log2-normalized ratios, retaining original log2 values in metadata.
#' Source zero becomes one; missing values remain missing. This does not recover
#' raw intensity or undo the author's normalization. Other signed sources below
#' remain source-only without an inverse transformation.
#'
#' MSV000086576 provides `glyhub_MSV000086576_N_HCC_AuthorProcessed` (1,831 by 7)
#' and `glyhub_MSV000086576_N_PDAC_AuthorProcessed` (2,525 by 12). These are
#' deidentified RDS derivatives with logged, reference-relative and median-normalized
#' TMT measurements. HCC has four normal and three tumor channels; PDAC has six
#' explicitly labelled tumor/normal pairs. The author 75-percent detection filter
#' is not reapplied. Core-fucose and PNGaseF flags remain distinct annotations.
#'
#' MSV000084262 provides `glyhub_MSV000084262_N_XMEN_AuthorProcessed`
#' (2,073 by 6), a deidentified RDS derivative. Author UID-expanded
#' deamidated peptide/site rows are not collapsed to unique protein sites.
#' Three XMEN and three healthy T-cell samples retain study-local labels and
#' groups; clinical identities are not guessed. Signed values have undocumented
#' additional processing beyond the paper's log2 description, so they must not
#' be relabelled linear intensity or exponentiated.
#'
#' Additional source files preserve pGlyco3 multi-run GPSMs (including O-glyco
#' HEK293), mucinase enzyme-digest AUC records, alternative GlycanFinder search
#' outputs, HG-TCs reporter tables, NB4 per-sample tables, BOCTAG protein groups,
#' and OxoScan feature-by-participant records. Source identities and alternative
#' quantification metrics are not collapsed or interpreted as independent cohorts.
#'
#' Repository CC0 source files additionally include HCC/IgG quantitative records,
#' retina sWGA-enriched ordinary precursors, ConA-enriched muscle precursors,
#' and HCC 18O site groups. Four biofluid EV original files are withheld pending
#' clarification of subject linkage; they are not registered public source assets.
#' These enrichments do not prove every captured peptide is a localized glycosite.
#' Glyco-DIA TrueT and FakeT files are two library-search controls of one run;
#' FakeT hits are not asserted biological glycoforms. Historically skipped deSA
#' data are not reopened. Unknown glycan types are explicitly missing, not N.
#'
#' Installed provenance, source scales, mapping and licence evidence are also
#' available at `system.file("extdata", "literature-source-metadata.json", package="glyhub")`.
#' Exact input URLs, SHA-256, sheet/column coordinates, sample mapping, scale
#' caveats, licensing basis and build instructions are maintained in the
#' accession-specific `data-raw/` directories and source receipts in the repository.
#' PXD019914 and MSV000086576 use original-author CC BY 4.0 supplemental tables;
#' XMEN uses the independent MassIVE CC0 deposit, not the publisher's licence.
#'
#' @name glyhub_literature_sources
#' @seealso [glyhub_data_conventions], [glyhub_catalog], [glyhub_load]
NULL
