#' Assign IBSS positions using polygon lookup
#'
#' Tests whether GPS coordinates fall within any of the predefined IBSS survey
#' polygons and returns the corresponding site or sub-location label.  Points
#' that do not fall inside any polygon are labelled `"notibss"`.
#'
#' @param x A data frame or matrix whose **first column is latitude** (decimal
#'   degrees, south values may be supplied as positive or negative) and
#'   **second column is longitude** (decimal degrees east).
#' @param subloc Logical.  If `TRUE` the sub-location label is returned
#'   (e.g. `"Fremantle Weed IBSS"`); if `FALSE` (default) the main site label
#'   is returned (e.g. `"Fremantle IBSS"`).
#' @param survey Character string used to filter polygons by `SiteCode`.  An
#'   empty string (default) matches all polygons.  Matching is
#'   case-insensitive and uses [base::grepl()].
#'
#' @return A character vector of length `nrow(x)` giving the assigned IBSS
#'   location for each input coordinate.  Points outside all polygons are
#'   returned as `"notibss"`.
#'
#' @seealso [getlocspointibss()] for nearest-centroid assignment,
#'   [getlocpolyiss()] for the ISS equivalent, [ibsspoly] for the underlying
#'   polygon data.
#'
#' @export
#' @importFrom sp point.in.polygon
#'
#' @examples
#' # Single point inside the Fremantle Weed polygon
#' coords <- data.frame(Lat = -32.18, Lon = 115.48)
#' getlocpolyibss(coords)
#'
#' # Return sub-location labels, filtered to Fremantle polygons only
#' getlocpolyibss(coords, subloc = TRUE, survey = "Fremantle")
getlocpolyibss <- function(x, subloc = FALSE, survey = "") {
  lat <- -abs(x[, 1])
  lon <- x[, 2]
  tmp <- rep(NA_character_, length(lat))

  for (i in seq_along(ibsspoly)) {
    poly <- ibsspoly[[i]]
    if (survey == "" || grepl(survey, poly$SiteCode, ignore.case = TRUE)) {
      inside <- sp::point.in.polygon(lon, lat, poly$x, poly$y) == 1L
      label  <- if (subloc) as.character(poly$SubLoc[1L]) else as.character(poly$Site[1L])
      tmp[inside] <- label
    }
  }

  tmp[is.na(tmp)] <- "notibss"
  tmp
}


#' Assign ISS positions using polygon lookup
#'
#' Tests whether GPS coordinates fall within any of the predefined ISS survey
#' polygons and returns the corresponding site or sub-location label.  Points
#' that do not fall inside any polygon are labelled `"notiss"`.
#'
#' @inheritParams getlocpolyibss
#' @param survey Character string used to filter polygons by `SiteCode`.  An
#'   empty string (default) matches all polygons.
#'
#' @return A character vector of length `nrow(x)` giving the assigned ISS
#'   location.  Points outside all polygons are returned as `"notiss"`.
#'
#' @seealso [getlocspointiss()] for nearest-centroid assignment,
#'   [getlocpolyibss()] for the IBSS equivalent, [isspoly] for the underlying
#'   polygon data.
#'
#' @export
#' @importFrom sp point.in.polygon
#'
#' @examples
#' coords <- data.frame(Lat = -30.5, Lon = 114.9)
#' getlocpolyiss(coords)
#'
#' getlocpolyiss(coords, subloc = TRUE, survey = "Jurien")
getlocpolyiss <- function(x, subloc = FALSE, survey = "") {
  lat <- -abs(x[, 1])
  lon <- x[, 2]
  tmp <- rep(NA_character_, length(lat))

  for (i in seq_along(isspoly)) {
    poly <- isspoly[[i]]
    if (survey == "" || grepl(survey, poly$SiteCode, ignore.case = TRUE)) {
      inside <- sp::point.in.polygon(lon, lat, poly$x, poly$y) == 1L
      label  <- if (subloc) as.character(poly$SubLoc[1L]) else as.character(poly$Site[1L])
      tmp[inside] <- label
    }
  }

  tmp[is.na(tmp)] <- "notiss"
  tmp
}


#' Assign IBSS positions using nearest-centroid lookup
#'
#' For each input coordinate, computes the Euclidean distance to the centroid
#' of every IBSS polygon and returns the label of the closest polygon.  Unlike
#' [getlocpolyibss()], this function always assigns a location — useful for
#' points that are just outside a polygon boundary due to GPS imprecision.
#'
#' Distances are computed in degrees (not metres) which is adequate for the
#' spatial scales of the IBSS sites.
#'
#' @inheritParams getlocpolyibss
#' @param survey Character string used to filter the candidate polygon set by
#'   `Site` name (default `"IBSS"`).  Set to `""` to consider all polygons.
#'
#' @return A character vector of length `nrow(x)` giving the closest IBSS
#'   location for each input coordinate.
#'
#' @seealso [getlocpolyibss()] for the strict polygon-based equivalent,
#'   [getlocspointiss()] for the ISS version, [ibsspoly] for the polygon data.
#'
#' @export
#'
#' @examples
#' coords <- data.frame(Lat = -32.18, Lon = 115.48)
#' getlocspointibss(coords, subloc = TRUE)
getlocspointibss <- function(x, subloc = FALSE, survey = "IBSS") {
  if (missing(x) || (!is.data.frame(x) && !is.matrix(x))) {
    stop("`x` must be a data frame or matrix with latitude in column 1 and longitude in column 2.")
  }

  wmin <- function(d) which.min(d)[1L]

  lat <- -abs(x[, 1])
  lon <- x[, 2]

  names_main   <- vapply(ibsspoly, function(p) as.character(unique(p$Site)),   character(1L))
  names_subloc <- vapply(ibsspoly, function(p) as.character(unique(p$SubLoc)), character(1L))
  cx <- vapply(ibsspoly, function(p) mean(p$x), numeric(1L))
  cy <- vapply(ibsspoly, function(p) mean(p$y), numeric(1L))

  # Filter to survey subset
  keep <- if (nzchar(survey)) grepl(survey, names_main, ignore.case = TRUE) else rep(TRUE, length(ibsspoly))
  cx           <- cx[keep]
  cy           <- cy[keep]
  names_main   <- names_main[keep]
  names_subloc <- names_subloc[keep]

  dist <- outer(lon, cx, `-`)^2 + outer(lat, cy, `-`)^2
  pos  <- apply(dist, 1L, wmin)

  if (subloc) names_subloc[pos] else names_main[pos]
}


#' Assign ISS positions using nearest-centroid lookup
#'
#' For each input coordinate, computes the Euclidean distance to the centroid
#' of every ISS polygon and returns the label of the closest polygon.  Unlike
#' [getlocpolyiss()], this function always assigns a location.
#'
#' @inheritParams getlocspointibss
#' @param survey Character string used to filter the candidate polygon set by
#'   `Site` name (default `"ISS"`).  Set to `""` to consider all polygons.
#'
#' @return A character vector of length `nrow(x)` giving the closest ISS
#'   location for each input coordinate.
#'
#' @seealso [getlocpolyiss()] for the strict polygon-based equivalent,
#'   [getlocspointibss()] for the IBSS version, [isspoly] for the polygon data.
#'
#' @export
#'
#' @examples
#' coords <- data.frame(Lat = -30.5, Lon = 114.9)
#' getlocspointiss(coords, subloc = TRUE)
getlocspointiss <- function(x, subloc = FALSE, survey = "ISS") {
  if (missing(x) || (!is.data.frame(x) && !is.matrix(x))) {
    stop("`x` must be a data frame or matrix with latitude in column 1 and longitude in column 2.")
  }

  wmin <- function(d) which.min(d)[1L]

  lat <- -abs(x[, 1])
  lon <- x[, 2]

  names_main   <- vapply(isspoly, function(p) as.character(unique(p$Site)),   character(1L))
  names_subloc <- vapply(isspoly, function(p) as.character(unique(p$SubLoc)), character(1L))
  cx <- vapply(isspoly, function(p) mean(p$x), numeric(1L))
  cy <- vapply(isspoly, function(p) mean(p$y), numeric(1L))

  keep <- if (nzchar(survey)) grepl(survey, names_main, ignore.case = TRUE) else rep(TRUE, length(isspoly))
  cx           <- cx[keep]
  cy           <- cy[keep]
  names_main   <- names_main[keep]
  names_subloc <- names_subloc[keep]

  dist <- outer(lon, cx, `-`)^2 + outer(lat, cy, `-`)^2
  pos  <- apply(dist, 1L, wmin)

  if (subloc) names_subloc[pos] else names_main[pos]
}
