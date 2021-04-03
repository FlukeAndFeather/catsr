## code to prepare `mn200312_58` dataset goes here

mn200312_58 <- read_nc("inst/extdata/mn200312-58_prh10.nc")

usethis::use_data(mn200312_58, overwrite = TRUE)
