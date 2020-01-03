library(dplyr)	

calculate_2 <- function(data, counter) {	
  data %>% filter(Counter == counter)	%>% calculate_2_single
}

calculate_2_single <- function(row) {
  mutate(row, Output = RV1/2, AdditionalColumn = 'blah')	
}