#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#

# Instruction
 #Create a Shiny App with title "Diagnostics for simple linear regression" and 
# subtitle the R and r-squared indexes. As input you can select 5 different trends: 
#     Positive Linerar, Negative Linear, Curved up, Curved down and Fan-shaped
#
# In the main panel you will have as output the regression model plot (scatter 
# plot of data and the regression line) and below the following diagnostics 
# plot for the residuals of the user - specified linear regression model:
#     -Residuals vs Fitted Values
#     -Histogram of residuals
#      -Q-Q Plot of residuals
#
# Add an input button that if clicked will show the residuals in the plot

# Define UI for application that draws a histogram
ui <- fluidPage(
    
    
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    
    
}

# Run the application 
shinyApp(ui = ui, server = server)