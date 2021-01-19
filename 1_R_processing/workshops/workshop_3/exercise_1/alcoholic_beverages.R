#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Instruction
# Create  a Shiny App that looks like the one in the picture.
#
# Set the following choices for countries: 
#     CANADA, FRANCE, ITALY, UNITED STATES OF AMERICA
#
# Create the same Shiny App using reactive{} function when defining data 
# in server.In this case the choices will include all countries in the dataset, 
# that will be shown sorted in an alphabetic order

library(shiny)
library(dplyr)
library(DT)

bcl <- read.csv("bcl-data.csv", stringsAsFactors = FALSE)

# Define UI for application that draws a histogram
ui <- fluidPage(
    
    titlePanel('BC Liquor Store prices'),
    sidebarLayout(
        sidebarPanel(
            sliderInput(inputId = "priceIn",label = "Price",
                min = 0,max = 100,value = c(25,40),pre="$"),
            radioButtons("productIn", "Product Type",
                         c("BEER","REFRESHMENT","SPIRITS","WINE"), 
                         selected="WINE"),
            uiOutput("countryOut"),
            textOutput("short_desc")
            ),
        mainPanel(
            plotOutput('histogram'),
            verbatimTextOutput("summary"),
            DT::dataTableOutput("table")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    output$countryOut <- renderUI({
        selectInput("countryIn", "Country", sort(unique(bcl$Country)), 
                    selected="CANADA")
    })
    
    df <- reactive({
        if (is.null(input$countryIn)) {
            return(NULL)
        }
        
        bcl %>% filter(Type == input$productIn, 
                       Country == input$countryIn, 
                       Price >= input$priceIn[1], 
                       Price <= input$priceIn[2])
    })
    
    output$histogram <- renderPlot({
        if (nrow(df())==0){
            plot.new()
        } else{
            hist(as.numeric(df()$Alcohol_Content), breaks=30,
                 col="darkgray",border="white",xlab="Alcohol Content",
                 main="Histogram of Alcohol Content, given a price range, country 
                 and drink type")
        }
    })
    
    output$short_desc <- renderText({
        paste("This dataset has ",nrow(df())," rows and",ncol(df())," columns")
    })
    
    output$summary = renderPrint(summary(df()$Alcohol_Content))
    
    output$table = renderDataTable(df())
}

# Run the application 
shinyApp(ui = ui, server = server)