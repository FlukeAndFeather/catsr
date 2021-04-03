test_viz <- view_cats(mn200312_58, c("p", "pitch", "aw"))

test_that("view_cats() produces a plotly object", {
  expect_s3_class(test_viz, "plotly")
})

test_that("view_cats() has the right number of axes", {
  expect_equal(sum(stringr::str_detect(names(test_viz$x$layout), "xaxis")), 1)
  expect_equal(sum(stringr::str_detect(names(test_viz$x$layout), "yaxis")), 3)
})

test_that("view_cats() fails for invalid columns", {
  expect_error(view_cats(mn200312_58, "foo"),
               "vars %in% colnames(prh) is not TRUE",
               fixed = TRUE)
})

test_that("view_cats() fails for non-PRHs", {
  expect_error(view_cats(iris),
               "\"whaleid\" %in% names(attributes(prh)) is not TRUE",
               fixed = TRUE)
})
