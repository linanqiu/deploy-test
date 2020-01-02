library(dplyr)	

calculate_2 <- function(params) {	
  params$data %>% filter(Counter == params$counter) %>% mutate(added_column = 5)	
}