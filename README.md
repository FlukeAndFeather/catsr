catsr\_readme
================

<!-- README.md is generated from README.Rmd. Please edit that file -->

# catsr

<!-- badges: start -->

[![R-CMD-check](https://github.com/FlukeAndFeather/catsr/workflows/R-CMD-check/badge.svg)](https://github.com/FlukeAndFeather/catsr/actions)
[![codecov](https://codecov.io/gh/FlukeAndFeather/catsr/branch/master/graph/badge.svg?token=006B4PEFI0)](https://codecov.io/gh/FlukeAndFeather/catsr)
<!-- badges: end -->

catsr reads and visualizes CATS PRH files.

## Installation

You can install catsr from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("FlukeAndFeather/catsr")
```

## Reading data

Read a CATS PRH file in NetCDF format.

``` r
library(catsr)
nc_path <- system.file("extdata", "mn200312-58_prh10.nc", package = "catsr")
mn200312_58 <- read_nc(nc_path)
```

Examine PRH variables (e.g. depth, pitch, and roll) in an interactive
plot. GitHub READMEs don’t support interaction, so a screenshot is
supplied instead.

``` r
view_cats(mn200312_58, c("p", "pitch", "roll"))
```

<img src="man/figures/README-plot-1.png" width="100%" />

Triaxial variables (such as accelerometry - `aw`) are represented in
multiple colors.

``` r
view_cats(mn200312_58, c("p", "aw", "mw"))
```

<img src="man/figures/README-plot_triax-1.png" width="100%" />
