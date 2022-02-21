#' Plotting item information curves
#'
#' This function takes a fitted mirt-model and visualizes items information curves.
#' 
#' 
#' @param model an object of class `SingleGroupClass` returned by the function `mirt()`. 
#' @param data the data frame used to estimate the IRT model.
#' @param facet Should all items be shown in one plot, or each item received its individal facet?
#' @param theta_range range to be shown on the x-axis
#' @param title title for the plot (defaults to "Item Characteristic Curves")
#'
#' @return a ggplot
#' @import ggplot2
#' @import dplyr
#' @import tidyr
#' @import mirt
#' @export
#'
#' @examples
#' library(mirt)
#' library(ggmirt)
#' data <- expand.table(LSAT7)
#' (mod <- mirt(data, 1))
#' 
#' itemInfoPlot(mod, data)
#'
itemInfoPlot <- function(model,
                         data, 
                         facet = FALSE,
                         title = "Item Information Curves",
                         theta_range = c(-4,4)) {
  
  theta_range = seq(theta_range[1], theta_range[2], by = .01)
  
  test <- NULL
  for(i in 1:length(data)){
    theta <- matrix(theta_range)
    test[[i]] <- testinfo(mod, Theta = theta, which.items = i)
  }
  
  names(test) <- paste('item', 1:length(test))
  test <- as.data.frame(test, theta) %>%
    tibble::rownames_to_column("theta") %>%
    gather(key, value, -theta) %>%
    mutate(theta = as.numeric(theta))
  
  # final plot
  if(isFALSE(facet)) {
    ggplot(test, aes(theta, value, colour = key)) + 
      geom_line() + 
      labs(x = expression(theta), 
           y = expression(I(theta)), 
           title = title,
           color = "Item") +
      theme_minimal()
    
  } else {
    ggplot(test, aes(theta, value)) + 
      geom_line() + 
      facet_wrap(~key) +
      labs(x = expression(theta), 
           y = expression(I(theta)), 
           title = title) +
      theme_minimal()
  }
}

