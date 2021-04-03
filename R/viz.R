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
