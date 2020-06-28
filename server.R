#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


library(shiny)
library(shinythemes)
library(dplyr)
library(arules)
library(arulesViz)

Merge2 <- read.csv("www/MergedData.csv", header = TRUE)
POSData_by_Cat <- split(Merge2$CategoryCDescription, Merge2$Basket_ID)
Basket <- as(POSData_by_Cat, "transactions")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    output$Baskets <- renderPrint({
        itemsets <- apriori(Basket, parameter=list(minlen= input$baskets, support=0.005, target="frequent itemsets"))
        inspect(sort(itemsets, by ="support"))
    })
    
    output$Rules <- renderPrint({
        rules <- apriori(Basket, parameter=list(minlen= input$baskets, support=0.005, confidence = 0.2, target="rules"))
        inspect(sort(rules, by = "lift"))
    })
    
    
    output$ParaCoordPlot <- renderPlot({
        rules <- apriori(Basket, parameter=list(minlen= input$baskets, support=0.005, confidence = 0.2, target="rules"))
        plot(rules, method = "paracoord")
    })

    output$HighLiftRules <- renderPlot({

        rules <- apriori(Basket, parameter=list(minlen= 2, support=0.01, confidence = 0.2, target="rules"))
        inspect(sort(rules, by ="lift"))
        highLiftRules <- head(sort(rules, by ="lift"), input$baskets)
        plot(highLiftRules, method = "graph", control = list(type="items"))

    })
    
    output$Scatter <- renderPlot({
        
        rules <- apriori(Basket, parameter=list(minlen= input$baskets, support=0.005, confidence = 0.2, target="rules"))
        plot(rules)
        
    })
    
    output$Quality <- renderPlot({
        
        rules <- apriori(Basket, parameter=list(minlen= input$baskets, support=0.005, confidence = 0.2, target="rules"))
        plot(rules@quality)
        
    })
    
    output$ConfidentRules <- renderPlot({
        
        rules <- apriori(Basket, parameter=list(minlen= input$baskets, support=0.005, confidence = 0.2, target="rules"))
        confidentRules <- rules[quality(rules)$confidence > 0.5] 
        confidentRules
        plot(confidentRules, method= "matrix" , measure=c( "lift" , "confidence" ), control=list(reorder='measure')) 
        
    })
    
    

})
