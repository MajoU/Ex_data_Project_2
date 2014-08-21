# Question 4

library(sqldf)
library(data.table)
# read new rds file
scc <- readRDS("Source_Classification_Code.rds")
NEI <- data.table(readRDS("summarySCC_PM25.rds")) 
# select all variables from column EI.Sector as "Comb" and "Coal" names 
coal_comb <- sqldf("select * from scc where EI_Sector like '%Comb%Coal%'")

# Anothe example: 
# coal_comb <- scc[scc$EI.Sector %in% grep("(Comb.*Coal)", scc$EI.Sector, ignore.case=T, value = T),]

# subset NEI data by variables from coal_comb$SCC column
coal_NEI <- NEI[NEI$SCC %in% coal_comb$SCC,]
# sum of emissions by year 
sum_coal_NEI <- tapply(coal_NEI$Emissions, coal_NEI$year, sum)
# stop abbreviation of y axis (emissions numbers)
options(scipen = 100000)
# create boxplots from subset_NEI and remove outliers
png("plot4.png", width = 480, height = 480)
barplot(sum_coal_NEI, col = c("darkblue"), main = "Coal combustion emissions in the USA", xlab = "Years", ylab = "Emissions in tons", cex.lab = 1.4)
dev.off()

