nc_path <- system.file("extdata", "mn200312-58_prh10.nc", package = "catsr")

test_that("reading sample data file is accurate", {
  actual <- read_nc(nc_path)
  expect_equal(actual, mn200312_58)
})

test_that("trying to read a nonexistent file fails", {
  expect_error(read_nc("foo.bar"))
})

test_data <- read_nc(nc_path)
test_that("correct dimensions", {
  expect_equal(ncol(test_data), 15)
  expect_equal(nrow(test_data), 147671)
})

test_that("triaxial data stored as matrices", {
  triax <- c("aw", "gw", "mw")
  for (col in triax)
    expect_true(inherits(test_data[[col]], "matrix"))
})
