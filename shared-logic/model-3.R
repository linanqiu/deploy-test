library(dplyr)	

calculate_3 <- function(params) {
  counter_new = params$counter + 1
  params$data %>% filter(Counter == counter_new) %>% mutate(counter_new = counter_new)	
}