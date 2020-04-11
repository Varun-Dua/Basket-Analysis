library(openxlsx)
library(tidyr)
library(dplyr)
library(ggplot2)
library(arules)
library(arulesViz)

# Reading base dataset on loan and returns
POSData <- read.xlsx(xlsxFile = "D:\\Data Science and Big Data Analytics\\Assignment 2\\Data.xlsx", sheet = 1, colNames = TRUE)
nrow(POSData) # Checking number of rows
head(POSData)

LoyaltyData <- read.xlsx(xlsxFile = "D:\\Data Science and Big Data Analytics\\Assignment 2\\Data.xlsx", sheet = 2, colNames = TRUE)
nrow(LoyaltyData) # Checking number of rows
head(LoyaltyData)

BarcodeData <- read.xlsx(xlsxFile = "D:\\Data Science and Big Data Analytics\\Assignment 2\\Data.xlsx", sheet = 3, colNames = TRUE)
nrow(BarcodeData) # Checking number of rows
head(BarcodeData)

TaxonomyData <- read.xlsx(xlsxFile = "D:\\Data Science and Big Data Analytics\\Assignment 2\\Data.xlsx", sheet = 4, colNames = TRUE)
nrow(TaxonomyData) # Checking number of rows
head(TaxonomyData)


POSData <- filter(POSData, Sum_Units >= 0)
POSData <- filter(POSData, Sum_Value >= 0)
POSData$Date <- as.Date(POSData$Date, origin = "1899-12-30")



Merge1<- merge(POSData, BarcodeData, by.x = "Barcode", by.y = "Barcode", all.x = TRUE)
Merge1 <- Merge1 %>% drop_na(CategoryA)
head(Merge1)
Merge2 <- merge(Merge1, TaxonomyData, by.x = "CategoryC", by.y = "CategoryC", all.x = TRUE)
head(Merge2)
names(Merge2)
Merge2 <- select(Merge2, c(Basket_ID, CategoryBDescription, CategoryCDescription))


# Frequent Item sets based on Category B
Merge2$Basket_ID <- as.factor(Merge2$Basket_ID)
Merge2$CategoryBDescription <- as.factor(Merge2$CategoryBDescription)
POSData_by_Cat <- split(Merge2$CategoryBDescription, Merge2$Basket_ID)
Basket <- as(POSData_by_Cat, "transactions")
itemsets <- apriori(Basket, parameter=list(minlen= 3, support=0.01, target="frequent itemsets"))
inspect(sort(itemsets, by ="support"))

# Frequent Item sets based on Category C
Merge2$Basket_ID <- as.factor(Merge2$Basket_ID)
Merge2$CategoryCDescription <- as.factor(Merge2$CategoryCDescription)
POSData_by_Cat <- split(Merge2$CategoryCDescription, Merge2$Basket_ID)
Basket <- as(POSData_by_Cat, "transactions")
itemsets <- apriori(Basket, parameter=list(minlen= 2, support=0.01, target="frequent itemsets"))
inspect(sort(itemsets, by ="support"))


# Rules based on Category C
rules <- apriori(Basket, parameter=list(minlen= 2, support=0.01, confidence = 0.2, target="rules"))
inspect(sort(rules, by ="lift"))
highLiftRules <- head(sort(rules, by ="lift"), 5)
plot(highLiftRules, method = "graph", control = list(type="items"))

