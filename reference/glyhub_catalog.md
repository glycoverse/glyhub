# List available glyhub datasets

List released and locally staged datasets without downloading any files.
Data assets are excluded from the package. A staged entry has no
download URL and requires the maintainer's verified local cache.

## Usage

``` r
glyhub_catalog(kind = c("curated", "raw", "all"))
```

## Arguments

- kind:

  List `"curated"` datasets (default), `"raw"` source archives, or
  `"all"` resources. Raw archives are currently available for CPTAC
  only.

## Value

A data frame containing dataset identifiers, source, file format,
storage, compressed bytes, SHA-256, version, URL and dimensions.

## Examples

``` r
glyhub_catalog()[, c("dataset", "storage", "bytes")]
#>                                               dataset storage    bytes
#> 1                         glyhub_GPST000738_N_B4GalT1 release    85324
#> 2                         glyhub_GPST000738_N_ST6GAL1 release    86980
#> 3                                 glyhub_GPST000643_O release   136920
#> 4                                 glyhub_GPST000643_N release    10320
#> 5                                 glyhub_GPST000213_N release   273048
#> 6                                 glyhub_GPST000213_O release    46920
#> 7                           glyhub_GPST000271_N_CAL51 release    26868
#> 8                           glyhub_GPST000271_O_CAL51 release     5336
#> 9                        glyhub_GPST000533_N_Released release     9584
#> 10                  glyhub_GPST000533_N_Glycopeptides release    23040
#> 11                     glyhub_GPST000120_O_Spike_ACE2 release     6096
#> 12                                glyhub_GPST000035_O release   115016
#> 13                      glyhub_GPST000128_n_precursor release    13096
#> 14                      glyhub_GPST000128_o_precursor release     6292
#> 15                                glyhub_GPST000183_n release    22564
#> 16                                glyhub_GPST000183_o release    12764
#> 17                          glyhub_GPST000599_serum_n release   160492
#> 18                                glyhub_GPST000431_N release    78080
#> 19                       glyhub_GPST000374_sssmug_gsl release     9028
#> 20                         glyhub_GPST000374_sssmug_n release    92264
#> 21                                glyhub_GPST000374_O release    10492
#> 22                              glyhub_GPST000676_GAG release     5576
#> 23                     glyhub_GPST000381_N_Prosaposin release     6124
#> 24                           glyhub_GPST000602_Sh_GSL release    99632
#> 25                           glyhub_GPST000602_Sm_GSL release    35072
#> 26                             glyhub_GPST000602_Sh_N release    86112
#> 27                             glyhub_GPST000602_Sm_N release    45568
#> 28                             glyhub_GPST000602_Sh_O release    28920
#> 29                glyhub_GPST000578_N_total_peak_area release    89408
#> 30 glyhub_GPST000578_N_source_repeatability_intensity release    20704
#> 31                glyhub_GPST000578_N_Fetuin_TwoSites release     6860
#> 32                         glyhub_GPST000125_N_HEK293 release    35484
#> 33                         glyhub_GPST000125_O_HEK293 release    25864
#> 34                       glyhub_GPST000125_GSL_HEK293 release    25468
#> 35                                glyhub_GPST000170_N release    10548
#> 36                                glyhub_GPST000170_O release    10488
#> 37                                glyhub_GPST000190_N release    58800
#> 38                                glyhub_GPST000211_O release     7168
#> 39                                glyhub_GPST000296_N release    70660
#> 40                                glyhub_GPST000460_N release   157900
#> 41                                glyhub_GPST000473_N release    19744
#> 42                                glyhub_GPST000534_N release     5880
#> 43                                glyhub_GPST000584_N release  1271612
#> 44                                glyhub_GPST000647_N release    34272
#> 45                                glyhub_GPST000650_O release     8280
#> 46                                glyhub_GPST000625_N release     8504
#> 47                  glyhub_GPST000601_N_glycopeptides release   746400
#> 48                                glyhub_GPST000601_N release    37880
#> 49                                glyhub_GPST000585_N release    22404
#> 50                                glyhub_GPST000403_N release    54388
#> 51                                glyhub_GPST000299_N release     9984
#> 52                              glyhub_GPST000299_GSL release     8632
#> 53                              glyhub_GPST000239_GSL release    28808
#> 54                                glyhub_GPST000079_N release    42148
#> 55                                glyhub_GPST000009_O release   130268
#> 56                               glyhub_GPST000604_HS release    17756
#> 57                            glyhub_GPST000604_CS_DS release    13280
#> 58                                glyhub_GPST000240_N release    29676
#> 59                              glyhub_GPST000240_GSL release    24960
#> 60                                glyhub_GPST000297_O release     4300
#> 61                                glyhub_GPST000297_N release     7036
#> 62                            glyhub_GPST000562_CS_DS release     3692
#> 63                                glyhub_GPST000667_N release    15832
#> 64                glyhub_GPST000671_N_Glycoproteomics release  1896836
#> 65                glyhub_GPST000671_O_Glycoproteomics release   937284
#> 66                                glyhub_GPST000671_N release    88844
#> 67                                glyhub_GPST000671_O release    25688
#> 68                                glyhub_GPST000596_N release    14060
#> 69                                glyhub_GPST000351_N release    64880
#> 70           glyhub_GPST000294_O_Celegans_Development release     6540
#> 71                  glyhub_GPST000214_N_AML_CellLines release    26028
#> 72                  glyhub_GPST000214_O_AML_CellLines release    11036
#> 73                    glyhub_GPST000294_N_Celegans_L4 release    54616
#> 74                glyhub_GPST000296_N_Glycoproteomics release  2303556
#> 75                            glyhub_GPST000027_031_N release    49124
#> 76                                 glyhub_CPTAC_CCRCC release 47437468
#> 77                                  glyhub_CPTAC_COAD release  5653760
#> 78                                  glyhub_CPTAC_HGSC release  2501440
#> 79                                 glyhub_CPTAC_HNSCC release 19378376
#> 80                                  glyhub_CPTAC_LSCC release 22958288
#> 81                                  glyhub_CPTAC_LUAD release 27852408
#> 82                                  glyhub_CPTAC_PDAC release 36204104
#> 83                                  glyhub_CPTAC_UCEC release  4556352
#> 84                      glyhub_PXD070547_N_HumanAtlas release  6197183
#> 85                      glyhub_PXD052447_N_Solubility release 21226446
#> 86                              glyhub_PXD065283_N_QC release  1888158
#> 87               glyhub_PXD065283_N_DiscoverySelected release  2142532
#> 88                           glyhub_PXD052447_N_TwoFF release 29882235
#> 89                      glyhub_PXD052447_N_Microbiome release 50422517
#> 90                        glyhub_PXD011063_O_Dilution release 11414190
#> 91                         glyhub_PXD052447_N_Tissues release 65947199
#> 92                          glyhub_PXD052447_N_PNGase release 29596300
#> 93                     glyhub_PXD052447_N_ProteinaseK release 31302092
#> 94                       glyhub_IPX0011099000_N_Brain release  3181648
#> 95                            glyhub_PXD046637_N_Lung release 33574842
#> 96                         glyhub_PXD011063_O_SerumSA release 18902343
```
