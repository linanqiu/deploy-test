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
  
  output$plot <- renderPlotly({
    plot_ly(data,
            x = ~ Time,
            y = ~ RV1,
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
