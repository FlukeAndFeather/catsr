#' Sample PRH data.
#'
#' The PRH for a humpback whale tagged in Antarctica on March 12, 2020.
#'
#' @format A tibble with columns:
#'   * dn (num) Matlab datenum of record
#'   * p (num) pressure, or approximate depth in meters
#'   * aw (num x 3) a 3 column matrix with x, y, and z accelerometry in whale frame
#'   * mw (num x 3) a 3 column matrix with x, y, and z magnetometry in whale frame
#'   * gw (num x 3) a 3 column matrix with x, y, and z gyroscope in whale frame
#'   * speed (num) speed of the whale in m/s (as estimated by the jiggle method)
#'   * pitch (num) pitch of the whale in radians
#'   * roll (num) roll of the whale in radians
#'   * head (num) heading of the whale in radians
#'   * dt (POSIXct) datetime of record
#'   * secs (numeric) seconds since start of deployment
#'   * jerk (num) norm of the jerk vector
#' And attributes:
#'   * whaleid (chr) e.g. "mn200312-58"
#'   * fs (num) sampling rate in Hz
#'   * tz (chr) local timezone e.g. "Etc/GMT+3" for UTC-3
#'
#' See \code{\link{read_nc}} for more details.
"mn200312_58"
