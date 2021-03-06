#!/bin/bash
set -e

# To make fex work
apt-get update && apt-get install -y --no-install-recommends libio-socket-ssl-perl

Rscript \
  -e 'if (!require(pak, quietly = TRUE)) utils::install.packages("pak", repos = sprintf("https://r-lib.github.io/p/pak/stable/%s/%s/%s", .Platform$pkgType, R.Version()$os, R.Version()$arch))' \
  -e 'pak::pkg_install(c(
    ifelse(
      test = grepl("\\.9000", Sys.getenv("UMR1283_VERSION")),
      yes = "umr1283/umr1283",
      no = paste0("umr1283/umr1283@v", Sys.getenv("UMR1283_VERSION"))
    )
  ))' \
  -e 'pak::pak_cleanup(force = TRUE)'

# Clean up
apt-get autoremove -y
apt-get autoclean -y
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/*

strip /usr/local/lib/R/site-library/*/libs/*.so
