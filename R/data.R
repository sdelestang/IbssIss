#' IBSS survey polygons
#'
#' A named list of polygon definitions for all sites in the Inshore Breeding
#' Stock Survey (IBSS).  Each element defines the boundary of one survey
#' sub-location and is used by [getlocpolyibss()] and [getlocspointibss()] to
#' assign GPS positions to named survey locations.
#'
#' @format A named list with one element per sub-location polygon.  Element
#'   names are short codes (e.g. `"FW"`, `"FR"`, `"JB"`, `"DN"`, …).
#'   Each element is itself a list with the following fields:
#'
#'   \describe{
#'     \item{`ID`}{Full descriptive identifier for the polygon (character).}
#'     \item{`Site`}{Main site label returned when `subloc = FALSE`
#'       (character).}
#'     \item{`SubLoc`}{Sub-location label returned when `subloc = TRUE`
#'       (character).}
#'     \item{`SiteCode`}{Code used for filtering via the `survey` argument of
#'       the assignment functions (character).}
#'     \item{`Longitude`}{Factor storing the raw degree-minute longitude
#'       strings from the original data entry (factor).}
#'     \item{`Latitude`}{Factor storing the raw degree-minute latitude strings
#'       from the original data entry (factor).}
#'     \item{`x`}{Polygon vertex longitudes in decimal degrees (numeric
#'       vector, closed — first and last point identical).}
#'     \item{`y`}{Polygon vertex latitudes in decimal degrees, negative =
#'       south (numeric vector, closed).}
#'     \item{`id`}{Polygon identifier string, same as `ID` (character).}
#'   }
#'
#' @details
#' Polygons are stored as simple closed rings; the `x`/`y` vectors are passed
#' directly to [sp::point.in.polygon()].  Polygon vertices were originally
#' derived from the historical IBSS site boundary definitions used at DPIRD.
#'
#' The following sub-locations are included (short code — sub-location name):
#'
#' | Code | Sub-location |
#' |------|-------------|
#' | FW   | Fremantle Weed IBSS |
#' | FR   | Fremantle Rock IBSS |
#' | JB   | Jurien Bay IBSS |
#' | JBB  | Jurien Between Banks IBSS |
#' | DM   | Dongara Middle IBSS |
#' | DN   | Dongara North IBSS |
#' | DS   | Dongara South IBSS |
#' | DC   | Dongara Close IBSS |
#' | DNWC | Dongara NW Corner IBSS |
#' | MA   | Marshalls IBSS |
#' | ASG  | Abrolhos Southern Group IBSS |
#' | ANI  | Abrolhos North Island IBSS |
#' | AWG  | Abrolhos Wallabi Group IBSS |
#' | BBNC | Big Bank North Closure IBSS |
#' | BBSC | Big Bank South Closure IBSS |
#'
#' @source DPIRD Invertebrate Fisheries, Western Australia.
#'
#' @seealso [getlocpolyibss()], [getlocspointibss()], [isspoly]
"ibsspoly"


#' ISS survey polygons
#'
#' A named list of polygon definitions for all sites in the Inshore Survey
#' (ISS).  Each element defines the boundary of one survey sub-location and is
#' used by [getlocpolyiss()] and [getlocspointiss()] to assign GPS positions
#' to named survey locations.
#'
#' @format A named list with one element per sub-location polygon.  Element
#'   names are short codes.  Each element is a list with the same fields as
#'   those documented in [ibsspoly]:
#'   `ID`, `Site`, `SubLoc`, `SiteCode`, `Longitude`, `Latitude`, `x`, `y`,
#'   `id`.
#'
#' @details
#' Structure and conventions are identical to [ibsspoly]; see that help page
#' for field descriptions.  Polygons cover the ISS sites along the Western
#' Australian coast.
#'
#' @source DPIRD Invertebrate Fisheries, Western Australia.
#'
#' @seealso [getlocpolyiss()], [getlocspointiss()], [ibsspoly]
"isspoly"
