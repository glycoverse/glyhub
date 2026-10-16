# Source attachments remain external to Git because supplement-specific
# redistribution terms have not been independently verified.
records <- list(
  list(
    path = "data-raw/GPST000027/152506_2_supp_372524_pvkzw0.pdf",
    sha256 = "a9393edfc7c67eb19e6d5e59919813fd18e4369489744e84950cbca048b1df72"
  ),
  list(
    path = "data-raw/GPST000031/152506_2_supp_372529_pvkzs0.xls",
    sha256 = "854f238cc3507723d095d810bb6b8e40f6d21c98ebb8a1d51c2f08429e2e7ad2"
  )
)
for (record in records) {
  if (!file.exists(record$path)) {
    stop(
      "Source attachment required: ",
      record$path,
      ". Place the lawfully obtained original at this path before rebuilding. ",
      "See data-raw/GPST000027/README.md. No verified automatic download is available.",
      call. = FALSE
    )
  }
  actual <- digest::digest(
    file = record$path,
    algo = "sha256",
    serialize = FALSE
  )
  if (!identical(actual, record$sha256)) {
    stop("Source SHA-256 mismatch: ", record$path, call. = FALSE)
  }
}
