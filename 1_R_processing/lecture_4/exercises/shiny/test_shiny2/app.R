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

    sliderInput(inputId = "num",
                label = "Choose a number",
                value = 25, min = 1, max = 1000),
    textInput(inputId="title",
              label="write a title",
              value="Histogram of Random Normal Values"),
    plotOutput("hist"),
    verbatimTextOutput("stats")
    
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    output$hist <- renderPlot({
        hist(rnorm(input$num),
             main = input$title)
        })
    
    
    output$stats <- renderPrint({
        summary(rnorm(input$num))
        })

}


# Define server logic required to draw a histogram
server2 <- function(input, output) {
    
    data=reactive({
        rnorm(input$num)
    })
    
    output$hist <- renderPlot({
        hist(data())
    })
    
    output$stats <- renderPrint({
        summary(data())
    })
    
}

# Define server logic required to draw a histogram
server3 <- function(input, output) {
    
    data=reactive({
        rnorm(input$num)
    })
    
    output$hist <- renderPlot({
        hist(data(), main = isolate({input$title}))
    })
    
    output$stats <- renderPrint({
        summary(data())
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server3)
