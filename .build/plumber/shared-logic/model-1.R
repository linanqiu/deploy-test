library(dplyr)	

calculate_1 <- function(params) {	
  params$data %>% filter(Counter == params$counter)	
}