#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#

# Instruction 1 --
#   Create a slider input to select values between 0 and 100 where the interval 
#   between each selectable value on the slider is 5. 
#   Then add animation to the input widget so when the user presses play the input
#   widget scrolls through automatically.
# Instruction 2 --
#   Create an app that compare 2 simulated datasets with a plot and a hypothesis 
#   test (tips. Histogram and t-test)
# Instruction 3 --
#  Redo the previous exercise using reactivity

library(ggplot2)

# Define UI for application that draws a histogram
ui <- fluidPage(
    
    fluidRow(column(10,align="center",h1("Lecture 4 Homework - MSc DS&AI 1"))),
    
    
    fluidRow(column(10,align="center",h2("Slider for dataset simulation using the normal distribution"))),   
             
    fluidRow(
        column(5, "Parameters of distribution 1", align="center",
               numericInput("mean1", label="mean", value=0, step=0.05), 
               numericInput("var1", label="variance", value=0.1, min=0.0, step=0.05)),
        column(5, "Parameters of distribution 2", align="center",
               numericInput("mean2", label="mean", value=0, step=0.05), 
               numericInput("var2", label="variance", value=0.1, min=0.0, step=0.05))
    ),
    
    fluidRow(
        column(10, align="center",
               sliderInput(inputId = "num",
                           label = "Choose a number between 0 and 100 (increments of 5) 
                           to select the amount to be sample from both distributions",
                           value=20, min=0, max=100, step=5,
                           animate=animationOptions(
                               interval = 1000,
                               loop = TRUE,
                               playButton = icon('play', "fa-3x"),
                               pauseButton = icon('pause', "fa-3x")
                           )))),
    
    fluidRow(column(10,align="center",plotOutput("hist"))),
    
    fluidRow(column(10,align="center",h4("T-Test. H0: Can we confidently say the 
                                         two distributions have the same mean?"))), 
    
    fluidRow(column(10,textOutput("stats")))
    
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    dist1 <- reactive({rnorm(input$num, input$mean1, input$var1)})
    dist2 <- reactive({rnorm(input$num, input$mean2, input$var2)})
    
    ttest <- reactive({t.test(dist1(), dist2(), paired=FALSE)})
    
    data <- reactive({
        data.frame(
            distribution = factor(rep(c("distribution 1", "distribution 2"), 
                                      each=input$num)),
            value = c(dist1(), dist2()))
    })
    
    
    
    ttest_result <- reactive({
        paste("The t-test, used to determine whether the means of two groups are ",
              "equal to each other. The assumption for the test is that both ", 
              "groups are sampled from normal distributions with equal variances. ",
              "The null hypothesis is that the two means are equal, and the ",
              "alternative is that they are not.\n",
              "Our current t-score is ", 
              round(ttest()$statistic,4),
              " and the associated p-value is ", 
              signif(ttest()$p.value, digits = 5),
              " (low p-values are good).", 
              sep="")
    })
    
    output$hist <- renderPlot({
        
        ggplot(data(), aes(x = value)) +
            geom_histogram(aes(color = distribution, fill = distribution), 
                           position="identity", alpha = 0.4) +
            scale_color_manual(values = c("#00AFBB", "#E7B800")) +
            scale_fill_manual(values = c("#00AFBB", "#E7B800"))

    })
    
    output$stats <- renderText({
        ttest_result()
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)