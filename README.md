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
mn200312_58_from_nc
#> # A tibble: 147,671 x 15
#>         dn       p aw[,1]  [,2]  [,3] mw[,1]  [,2]  [,3]  gw[,1]    [,2]    [,3]
#>      <dbl>   <dbl>  <dbl> <dbl> <dbl>  <dbl> <dbl> <dbl>   <dbl>   <dbl>   <dbl>
#>  1 737863. -0.0494 -0.797 -8.06  6.32  -23.1 -21.5  19.0 -0.0524 -0.0436  0.0300
#>  2 737863. -0.0295 -0.343 -8.44  6.40  -23.0 -21.7  18.6  0.0686 -0.0645  0.0282
#>  3 737863. -0.0262 -0.341 -9.04  6.34  -22.8 -21.4  18.9  0.296  -0.127  -0.0438
#>  4 737863. -0.0465 -0.675 -7.93  5.46  -22.7 -20.8  20.1  0.256  -0.145  -0.0796
#>  5 737863. -0.0468 -0.281 -7.29  5.76  -22.1 -20.9  20.6  0.0505 -0.0854 -0.0175
#>  6 737863. -0.0441 -0.130 -7.37  6.52  -22.0 -21.0  20.6  0.0696 -0.0973 -0.0175
#>  7 737863. -0.0456 -0.191 -7.03  5.77  -21.7 -20.5  21.5  0.114  -0.115  -0.0201
#>  8 737863. -0.0478 -0.249 -7.52  5.17  -21.2 -20.2  21.6 -0.0664 -0.0496  0.0386
#>  9 737863. -0.0304 -0.464 -7.58  5.07  -21.7 -20.2  21.4 -0.0306 -0.0151  0.0199
#> 10 737863. -0.0256 -0.405 -7.03  5.05  -21.7 -20.3  21.3 -0.0925  0.0373  0.0460
#> # … with 147,661 more rows, and 10 more variables: speed <dbl>, pitch <dbl>,
#> #   roll <dbl>, head <dbl>, x <dbl>, y <dbl>, z <dbl>, dt <dttm>, secs <dbl>,
#> #   jerk <dbl>
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
