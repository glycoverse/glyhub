source("data-raw/CPTAC/convert.R")
f <- tempfile(fileext = ".tsv")
writeLines(
  c(
    "Sequence\tGene\tIntensity.Reference\tTEST.P1.T - set 1 126\tTEST.P1.N\tTEST.Reference Sample 1\tTEST.QC1\tTEST.unknown",
    "NVTK-N2H3F0S0G0\tGENE|ENSG1\t10\t0\t-1\tNone\t2\t3",
    "NVTK-N2H3F0S0G0\tGENE|ENSG1\t11\t1\t2\tNone\t4\t5"
  ),
  f
)
x <- cptac_convert(f, "TEST", list())
a <- SummarizedExperiment::assay(x)
rd <- SummarizedExperiment::rowData(x)
cd <- SummarizedExperiment::colData(x)
stopifnot(
  methods::validObject(x),
  identical(dim(x), c(2L, 5L)),
  identical(a[, 1], c("NVTK-N2H3F0S0G0" = 1, "NVTK-N2H3F0S0G0.1" = 2)),
  a[1, 2] == 0.5,
  all(is.na(a[, 3])),
  !anyDuplicated(rownames(x)),
  identical(
    cd$sample_role,
    c("biological", "biological", "reference", "QC", "unresolved")
  ),
  identical(cd$participant_id[1:2], c("P1", "P1")),
  all(is.na(rd$protein)),
  all(is.na(rd$protein_site)),
  glyrepr::is_glycan_composition(rd$glycan_composition),
  identical(a, 2^S4Vectors::metadata(x)$raw_abundance)
)
unlink(f)
message("Conversion fixture passed")
