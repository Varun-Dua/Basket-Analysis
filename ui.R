#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Basket Analysis"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("baskets",
                        "Number of Items:",
                        min = 1,
                        max = 4,
                        value = 2)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(type = "tabs",
                        tabPanel("Baskets", verbatimTextOutput("Baskets")),
                        tabPanel("Rules", verbatimTextOutput("Rules")),
                        tabPanel("ParaCoord Plot", plotOutput("ParaCoordPlot")),
                        tabPanel("High Lift Rules", plotOutput("HighLiftRules")),
                        tabPanel("Scatter Plot", plotOutput("Scatter")),
                        tabPanel("Quality", plotOutput("Quality")),
                        tabPanel("Confident Rules", plotOutput("ConfidentRules")))
        )
    )
))
