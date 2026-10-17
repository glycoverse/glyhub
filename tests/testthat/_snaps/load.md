# raw resources download once and support offline cache and refresh

    Code
      glyhub_load(entry$dataset, "raw", cache_dir = cache, offline = TRUE)
    Condition
      Error:
      ! No verified cached glyhub file is available in offline mode.

# invalid downloads never replace a valid cache entry

    Code
      glyhub_load(entry$dataset, "raw", cache_dir = cache, refresh = TRUE)
    Condition
      Error:
      ! Downloaded glyhub file failed SHA-256 or size verification.

# interrupted downloads are cleaned up

    Code
      glyhub_load("glyhub_CPTAC_CCRCC", cache_dir = cache)
    Condition
      Error in `.glyhub_download_file()`:
      ! Interrupted test transfer

# unknown identifiers and invalid options fail before downloads

    Code
      glyhub_load("unknown")
    Condition
      Error:
      ! Unknown dataset or unavailable resource kind: unknown (curated).

---

    Code
      glyhub_load("glyhub_GPST000738_N_B4GalT1", kind = "raw")
    Condition
      Error:
      ! Unknown dataset or unavailable resource kind: glyhub_GPST000738_N_B4GalT1 (raw).

---

    Code
      glyhub_load("glyhub_CPTAC_CCRCC", refresh = TRUE, offline = TRUE)
    Condition
      Error:
      ! Cannot refresh in offline mode.

---

    Code
      glyhub_load("glyhub_CPTAC_CCRCC", offline = NA)
    Condition
      Error:
      ! `refresh` and `offline` must be TRUE or FALSE.

