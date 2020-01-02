#
# This is a Plumber API. You can run the API by clicking
# the 'Run API' button above.
#
# Find out more about building APIs with Plumber here:
#
#    https://www.rplumber.io/
#

library(plumber)
library(pins)
library(dplyr)

source('shared-logic/model-1.R')
source('shared-logic/model-2.R')

board_register('rsconnect', server = Sys.getenv('CONNECT_SERVER'), key = Sys.getenv("CONNECT_API_KEY"))

#* @apiTitle Plumber Example API

#* Returns pinned data
#* @get /pinned
function() {
  data_scheduled <- pin_get('pins-test-scheduled-data', board = 'rsconnect')
  data_scheduled
}

#* Returns a particular row of the pinned data
#* @param counter Row counter
#* @get /pinned_counter
function(counter = 1) {
  data_scheduled <- pin_get('pins-test-scheduled-data', board = 'rsconnect')
  params <- list('data' = data_scheduled, 'counter' = 1)
  output <- list('prod' = calculate_1(params), 'rc' = c(calculate_2(params), calculate_3(params)))
  output
}

#* Echo back the input
#* @param msg The message to echo
#* @get /echo
function(msg = "") {
  list(msg = paste0("The message is: '", msg, "'"))
}

#* Plot a histogram
#* @png
#* @get /plot
function() {
  rand <- rnorm(100)
  hist(rand)
}

#* Return the sum of two numbers
#* @param a The first number to add
#* @param b The second number to add
#* @post /sum
function(a, b) {
  as.numeric(a) + as.numeric(b)
}