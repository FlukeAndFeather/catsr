#' Visualize CATS data
#'
#' @param prh A CATS PRH object (see \code{\link{read_nc}})
#' @param vars A vector of columns in `prh` to plot. "p" by default (depth).
#'
#' @return A plotly figure, with subplots in one column. One PRH variable per
#' subplot. Triaxial variables (e.g. `aw`) represented as multiple colors in one
#' subplot.
#' @export
#'
#' @examples
#' view_cats(mn200312_58, c("p", "pitch", "aw"))
view_cats <- function(prh, vars = "p") {
  # Check prh is a PRH and vars are columns in prh
  stopifnot(
    "whaleid" %in% names(attributes(prh)),
    vars %in% colnames(prh)
  )

  subplots <- lapply(vars, make_subplot, prh = prh)
  plotly::subplot(subplots,
                  nrows = length(vars),
                  shareX = TRUE,
                  titleY = TRUE)
}

#' Helper function for making subplots
#'
#' @param var Variable for subplot
#' @param prh PRH object
#'
#' @return A plotly object
make_subplot <- function(var, prh) {
  # Handle tri-axial cases
  if (var %in% c("aw", "gw", "mw")) {
    newnames <- stringr::str_replace(var, "w", c("x", "y", "z"))
    for (i in 1:3) prh[[newnames[i]]] <- prh[[var]][, i]
    fig <- prh %>%
      tidyr::pivot_longer(cols = all_of(newnames),
                          names_to = "axis",
                          values_to = "vals") %>%
      ggplot(aes(dt, vals, color = axis))
  } else {
    fig <- ggplot(prh, aes(dt, !!sym(var)))
  }

  # Return figure
  (fig +
      geom_line(size = 0.2) +
      (if (var == "p") scale_y_reverse()) +
      labs(y = var) +
      theme_minimal() +
      theme(axis.title.x = element_blank(),
            legend.title = element_blank())) %>%
    plotly::ggplotly(dynamicTicks = TRUE)
}

#' Plot a georeferenced track in 3d
#'
#' @param prh A CATS PRH object
#' @param width Width of the track (in meters)
#'
#' @return A plotly 3d mesh figure
#' @export
#'
#' @examples
#' view_cats_3d(mn200312_58, width = 10)
view_cats_3d <- function(prh, width = 1) {
  # Calculate points for a 3d ribbon path
  prh$z <- -prh$z
  wx <- lead(prh$x) - prh$x
  wy <- lead(prh$y) - prh$y
  wz <- lead(prh$z) - prh$z
  wnorm <- apply(cbind(wx, wy, wz), 1, function(vec) sqrt(sum(vec^2)))
  wx <- wx / wnorm * width
  wy <- wy / wnorm * width
  wz <- wz / wnorm * width
  cosp <- cos(prh$pitch)
  cosr <- cos(prh$roll)
  sinp <- sin(prh$pitch)
  sinr <- sin(prh$roll)
  px <- head(wy * cosp * sinr - wz * cosr, -1)
  py <- head(wz * sinp * sinr - wx * cosp * sinr, -1)
  pz <- head(wx * cosr - wy * sinp * sinr, -1)
  x0 <- head(prh$x, -1)
  y0 <- head(prh$y, -1)
  z0 <- head(prh$z, -1)
  x <- c(x0 + px, x0 - px)
  y <- c(y0 + py, y0 - py)
  z <- c(z0 + pz, z0 - pz)
  n <- nrow(prh) - 1
  i <- rep(1:(n - 1), each = 2) + rep(c(0, n), n - 1) - 1
  j <- rep(1:(n - 1), each = 2) + rep(c(n, 1), n - 1) - 1
  k <- rep(2:n, each = 2) + rep(c(0, n), n - 1) - 1
  plotly::plot_ly(type = "mesh3d",
                  x = x, y = y, z = z,
                  i = i, j = j, k = k)
}
