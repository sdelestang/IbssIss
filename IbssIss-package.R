#' IbssIss: Assign Survey Positions for the Breeding Stock Survey
#'
#' Assigns observer GPS positions to named locations in the Inshore Breeding
#' Stock Survey (IBSS) and Inshore Survey (ISS).  Two assignment methods are
#' provided:
#'
#' - **Polygon-based** ([getlocpolyibss()], [getlocpolyiss()]): a point is
#'   assigned to the first matching polygon via [sp::point.in.polygon()].
#'   Points outside all polygons return `"notibss"` / `"notiss"`.
#'
#' - **Nearest-centroid** ([getlocspointibss()], [getlocspointiss()]): always
#'   assigns the closest polygon centroid — useful as a fallback when GPS
#'   positions sit just outside a polygon boundary.
#'
#' Survey polygon data are bundled as package datasets:
#'
#' - [ibsspoly] — IBSS site polygons
#' - [isspoly] — ISS site polygons
#'
#' @keywords internal
"_PACKAGE"
