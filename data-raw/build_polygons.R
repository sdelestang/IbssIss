## data-raw/build_polygons.R
##
## Run this script once (via `source()` or `devtools::source_file()`) to
## rebuild the package datasets from the original polygon definitions.
##
## Usage (from package root):
##   source("data-raw/build_polygons.R")
##
## ibsspoly is defined inline in data-raw/ibsspoly_source.R (extracted from
## the original LoadNewIbssIss.R).  isspoly is loaded from the .rda file in
## this directory (copy isspoly.rda here before running).

# ---- ibsspoly ---------------------------------------------------------------
source("data-raw/ibsspoly_source.R")   # defines ibsspoly in this env
usethis::use_data(ibsspoly, overwrite = TRUE, compress = "xz")

# ---- isspoly ----------------------------------------------------------------
# isspoly was originally stored only as a pre-built .rda.
# Place a copy at data-raw/isspoly.rda then run this script.
load("data-raw/isspoly.rda")           # loads isspoly into this env
usethis::use_data(isspoly, overwrite = TRUE, compress = "xz")

message("Datasets rebuilt successfully.")
