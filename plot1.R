# Question 1

library(data.table)
# read rds data and make data.table from it
NEI <- data.table(readRDS("summarySCC_PM25.rds")) 
# create table with sum of emissions by year
sum_emission <- tapply(NEI$Emissions, NEI$year, sum) 

# stop abbreviation of large numbers in y axis (emissions)
options(scipen = 100000)
# make plot png file
png("plot1.png", width = 480, height = 480)
barplot(sum_emission, main = "Total emissions in the USA", xlab = "Years", ylab = "Emissions in tons", cex.lab = 1.4)
dev.off()
