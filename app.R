#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(pins)
library(plotly)
library(dplyr)

source('shared-logic/model-1.R')
source('shared-logic/model-2.R')
source('shared-logic/model-3.R')
source('shared-logic/error-handling.R')

board_register(
  'rsconnect',
  server = Sys.getenv('CONNECT_SERVER'),
  key = Sys.getenv("CONNECT_API_KEY")
)

# Define UI for application that draws a histogram
ui <- fluidPage(
  titlePanel("Pinned Data Visualization"),
  plotlyOutput('plot'),
  verbatimTextOutput('event')
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  data <- pin_get('pins-test-scheduled-data', board = 'rsconnect')
  data_1 = data %>% calculate_1_single
  data_1$Source = 'calculate_1_single'
  
  data_2 = data %>% calculate_2_single
  data_2$Source = 'calculate_2_single'
  
  data_3 = data %>% calculate_3_single
  data_3$Source = 'calculate_3_single'
  
  data_plot = bind_rows(data_1, data_2, data_3)
  data_plot$Source = as.factor(data_plot$Source)
  
  output$plot <- renderPlotly({
    plot_ly(data_plot,
            x = ~ Time,
            y = ~ Output,
            color = ~ Source,
            mode = 'lines')
  })
  
  output$event <- renderPrint({
    d <- event_data("plotly_hover")
    if (is.null(d)) {
      "Hover on a point!"
    } else {
      d
    }
  })
}

# Run the application
shinyApp(ui = ui, server = server)
