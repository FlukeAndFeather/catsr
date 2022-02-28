#' Read a CATS PRH from a NetCDF file
#'
#' @param nc_path path to the CATS PRH
#'
#' @return A tibble with columns:
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
#'   * x (num) x coordinate of dead-reckoned track, relative to deployment location (m; eastings)
#'   * y (num) y coordinate of dead-reckoned track, relative to deployment location (m; northings)
#'   * z (num) z coordinate of dead-reckoned track, relative to deployment location (m; depth)
#'
#' And attributes:
#'   * whaleid (chr) e.g. "mn200312-58"
#'   * fs (num) sampling rate in Hz
#'   * tz (chr) local timezone e.g. "Etc/GMT+3" for UTC-3
#' @export
#'
#' @examples
#' \dontrun{
#' nc_path <- system.file("extdata", "mn200312-58_prh10.nc", package = "catsr")
#' mn200312_58 <- read_nc(nc_path)
#' }
read_nc <- function(nc_path) {
  stopifnot(file.exists(nc_path))
  nc <- ncdf4::nc_open(nc_path)
  fs <- ncdf4::ncatt_get(nc, "P", "sampling_rate")$value
  whaleid <- ncdf4::ncatt_get(nc, 0, "depid")$value
  tz0 <- ncdf4::ncatt_get(nc, 0, "dephist_device_tzone")$value
  tz <- sprintf("Etc/GMT%+d", -tz0)
  calc_jerk <- function(amat) {
    diff_amat <- apply(amat, 2, lead) - amat
    apply(diff_amat, 1, function(xyz) sqrt(sum(xyz^2)))
  }
  geotrack <- if ("geoPtrack" %in% names(nc$var)) {
    ncdf4::ncvar_get(nc, "geoPtrack")
  } else {
    matrix(NA, ncol = 3)
  }
  result <- tibble(
    dn = as.vector(ncdf4::ncvar_get(nc, "DN")),
    p = as.vector(ncdf4::ncvar_get(nc, "P")),
    aw = as.matrix(ncdf4::ncvar_get(nc, "Aw")),
    mw = as.matrix(ncdf4::ncvar_get(nc, "Mw")),
    gw = as.matrix(ncdf4::ncvar_get(nc, "Gw")),
    speed = as.vector(ncdf4::ncvar_get(nc, "speedJJ")),
    pitch = as.vector(ncdf4::ncvar_get(nc, "pitch")),
    roll = as.vector(ncdf4::ncvar_get(nc, "roll")),
    head = as.vector(ncdf4::ncvar_get(nc, "head")),
    x = as.vector(geotrack[, 1]),
    y = as.vector(geotrack[, 2]),
    z = as.vector(geotrack[, 3])
  ) %>%
    mutate(dt = as.POSIXct((dn - 719529) * 86400,
                           origin = "1970-01-01",
                           tz = "UTC") %>%
             lubridate::with_tz(tz),
           secs = as.numeric(dt - min(dt), unit = "secs"),
           jerk = calc_jerk(aw))
  attr(result, "whaleid") <- whaleid
  attr(result, "fs") <- fs
  attr(result, "tz") <- tz
  result
}

get_whaleid <- function(prh) {
  attr(prh, "whaleid")
}

get_fs <- function(prh) {
  attr(prh, "fs")
}

get_tz <- function(prh) {
  attr(prh, "tz")
}

set_prh_attrs <- function(new, old) {
  attrs <- c("whaleid", "fs", "tz")
  for (a in attrs) {
    attr(new, a) <- attr(old, a)
  }
  new
}
