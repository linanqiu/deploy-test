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
source('shared-logic/model-3.R')

board_register(
  'rsconnect',
  server = Sys.getenv('CONNECT_SERVER'),
  key = Sys.getenv("CONNECT_API_KEY")
)

#* @apiTitle Plumber Example API

#* Returns pinned data
#* @get /pinned
function() {
  data_scheduled <-
    pin_get('pins-test-scheduled-data', board = 'rsconnect')
  data_scheduled
}

#* Returns a particular row of the pinned data
#* @param counter Row counter
#* @get /pinned_counter
function(counter = 1) {
  data_scheduled <-
    pin_get('pins-test-scheduled-data', board = 'rsconnect')
  params <- list('data' = data_scheduled, 'counter' = counter)
  output <- list(
    'prod' = try(calculate_1(params)),
    'rc' = try(calculate_2(params)),
    'prototype' = try(calculate_3(params))
  )
  output
}