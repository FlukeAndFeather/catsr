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

Read a CATS PRH file in NetCDF format. The .nc file for deployment
mn200312-58 is included in the package.

``` r
library(catsr)
nc_path <- system.file("extdata", "mn200312-58_prh10.nc", package = "catsr")
mn200312_58_from_nc <- read_nc(nc_path)
```

## Visualizing data

Examine PRH variables (e.g. depth, pitch, and roll) in an interactive
plot. This package also provides deployment mn200312-58 directly for use
in R (`mn200312_58`).

``` r
view_cats(mn200312_58, c("p", "pitch", "roll"))
```

![interactive figure with CATS data](man/figures/README-plot-1.gif)

Triaxial variables (such as accelerometry - `aw`) are represented in
multiple colors.

``` r
view_cats(mn200312_58, c("p", "aw", "mw"))
```

![interactive figure with triaxial
data](man/figures/README-plot_triax-1.gif)

Explore the animal’s 3d movement trajectory.

``` r
view_cats_3d(mn200312_58)
```

![3d movement trajectory of a whale](man/figures/README-plot_3d-1.gif)
