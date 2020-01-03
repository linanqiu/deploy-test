library(dplyr)	

calculate_1 <- function(data, counter) {	
  data %>% filter(Counter == counter)	%>% calculate_1_single
}

calculate_1_single <- function(row) {
  mutate(row, Output = RV1)
}