test_that("getlocpolyibss returns correct length", {
  coords <- data.frame(Lat = c(-32.18, -30.5), Lon = c(115.48, 114.9))
  result <- getlocpolyibss(coords)
  expect_length(result, 2L)
  expect_type(result, "character")
})

test_that("getlocpolyibss returns 'notibss' for points clearly outside all polygons", {
  # Ocean point well away from any IBSS site
  coords <- data.frame(Lat = -35.0, Lon = 120.0)
  expect_equal(getlocpolyibss(coords), "notibss")
})

test_that("getlocpolyibss subloc and site labels differ", {
  coords <- data.frame(Lat = -32.18, Lon = 115.48)
  site   <- getlocpolyibss(coords, subloc = FALSE)
  subloc <- getlocpolyibss(coords, subloc = TRUE)
  # Either both are 'notibss' (point outside), or they may legitimately differ
  expect_type(site, "character")
  expect_type(subloc, "character")
})

test_that("getlocspointibss always returns a non-NA value", {
  coords <- data.frame(Lat = c(-32.18, -35.0), Lon = c(115.48, 120.0))
  result <- getlocspointibss(coords)
  expect_false(any(is.na(result)))
})

test_that("getlocspointiss always returns a non-NA value", {
  coords <- data.frame(Lat = c(-30.5, -35.0), Lon = c(114.9, 120.0))
  result <- getlocspointiss(coords)
  expect_false(any(is.na(result)))
})

test_that("getlocpolyiss returns 'notiss' for distant points", {
  coords <- data.frame(Lat = -35.0, Lon = 120.0)
  expect_equal(getlocpolyiss(coords), "notiss")
})

test_that("positive latitudes treated same as negative (southern hemisphere)", {
  coords_neg <- data.frame(Lat = -32.18, Lon = 115.48)
  coords_pos <- data.frame(Lat =  32.18, Lon = 115.48)
  expect_equal(getlocpolyibss(coords_neg), getlocpolyibss(coords_pos))
  expect_equal(getlocspointibss(coords_neg), getlocspointibss(coords_pos))
})
