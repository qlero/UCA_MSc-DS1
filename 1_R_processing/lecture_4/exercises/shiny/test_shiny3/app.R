#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage( 

    h1("Shiny's HTML tag functions"),
    h2("Subtitle"),
    code("x+y-2"),br(),
    strong("Shiny App"), br(),
    em("Italicized text"), br(),
    
    actionButton(inputId = "clicks", label="Click me!"),
    actionButton(inputId = "norm", label="Normal"),
    actionButton(inputId = "unif", label="Uniform"),
    plotOutput("hist")

)

server <- function(input, output) {
    
    observeEvent(
        input$clicks, 
        {print(as.numeric(input$clicks))}
        )
    rv <- reactiveValues(data = rnorm(100))
    observeEvent(input$norm, {rv$data <- rnorm(10000)})
    observeEvent(input$unif, {rv$data <- runif(10000)})
    
    output$hist <- renderPlot({
        hist(rv$data, breaks = 50)
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
