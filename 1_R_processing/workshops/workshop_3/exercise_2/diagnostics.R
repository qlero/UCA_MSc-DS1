#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#

# Instruction
# Create a Shiny App with title "Diagnostics for simple linear regression" and 
# subtitle the R and r-squared indexes. As input you can select 5 different trends: 
#     Positive Linear, Negative Linear, Curved up, Curved down and Fan-shaped
#
# In the main panel you will have as output the regression model plot (scatter 
# plot of data and the regression line) and below the following diagnostics 
# plot for the residuals of the user - specified linear regression model:
#     -Residuals vs Fitted Values
#     -Histogram of residuals
#      -Q-Q Plot of residuals
#
# Add an input button that if clicked will show the residuals in the plot

library(shiny)
library(ggplot2)

create_dataset <- function(x, trend) {
    
    if (trend == "Positive Linear") {
        return(x+rnorm(length(x)))
    } else if (trend == "Negative Linear") {
        return(-x+rnorm(length(x)))
    } else if (trend == "Curved Up") {
        return(log(x+rnorm(length(x))))
    } else if (trend == "Curved Down") {
        return(-log(x+rnorm(length(x))))
    } else if (trend == "Fan-Shaped") {
        return(rnorm(length(x), sd=x)) 
    }
}

# Define UI for application that draws a histogram
ui <- fluidPage(
    
    titlePanel('Diagnostics for simple linear regression'),
    sidebarLayout(
        sidebarPanel(
            radioButtons("trend", label="Select a data shape (trend):",
                         choices=c("Positive Linear", "Negative Linear", 
                                   "Curved Up", "Curved Down", "Fan-Shaped"),
                         selected="Positive Linear"),
            checkboxInput("showResiduals", "Show the residuals",
                          value=FALSE)
        ),
        mainPanel(
            plotOutput('scatterplot'),
            splitLayout(cellWidths = c("33.33%", "33.3%", "33.3%"), 
                        plotOutput("plot1"),
                        plotOutput("plot2"),
                        plotOutput("plot3"))
        )
    )
    
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    x <- seq(1,40)
    y <- reactive({create_dataset(x, input$trend)})
    model <- reactive({lm(y()~x)})
    
    output$scatterplot = renderPlot({
        plot(y()~x, col="darkblue",
             xlab="x",
             ylab="y",
             main=paste("Regression Model \n","R-Squared = ",
                        round(summary(model())[["r.squared"]], 4)))
        legend("topleft", legend="Regression line", col="red", pch="-")
        abline(model(), col="red")
        if (input$showResiduals) {
            segments(x0 = x, x1 = x, y0 = y(), y1 = model()$fitted.values,col="orange")
        }
    })
    
    output$plot1 = renderPlot({
        plot(model()$fitted.values, model()$residuals, col="darkblue",
             main="Residuals vs. Fitted Values",
             xlab="Fitted Values", ylab="Residuals")
        #abline(h=0, lty=2) #http://www.learnbymarketing.com/tutorials/linear-regression-in-r/
    })
    output$plot2 = renderPlot({
        hist(model()$resid, main="Histogram of Residuals",
             xlab="Residuals", ylab="Density", freq=FALSE)
        lines(density(model()$residuals), col="red")
    })
    output$plot3 = renderPlot({
        qqnorm(model()$resid, col="darkblue")
        qqline(model()$resid, col="red")
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)