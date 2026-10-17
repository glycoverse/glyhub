# download caches verified files and supports offline reads and refresh

    Code
      glyhub_cptac_download(entry$cohort, entry$kind, cache, offline = TRUE)
    Condition
      Error:
      ! No verified cached CPTAC file is available in offline mode.

# bad downloads never replace a valid cached file

    Code
      glyhub_cptac_download(entry$cohort, entry$kind, cache, refresh = TRUE)
    Condition
      Error:
      ! Downloaded CPTAC file failed SHA-256 or size verification.

# invalid requests fail before attempting network access

    Code
      glyhub_cptac_download("unknown")
    Condition
      Error:
      ! Unknown CPTAC cohort: unknown

---

    Code
      glyhub_CPTAC_CCRCC(offline = TRUE, refresh = TRUE)
    Condition
      Error:
      ! Cannot refresh in offline mode.

---

    Code
      glyhub_CPTAC_CCRCC(offline = NA)
    Condition
      Error:
      ! `refresh` and `offline` must be TRUE or FALSE.

# interrupted downloads leave no cache entry

    Code
      glyhub_CPTAC_CCRCC(cache_dir = cache)
    Condition
      Error in `.cptac_download_file()`:
      ! Interrupted test transfer

