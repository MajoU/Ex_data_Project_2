# Question 4

library(sqldf)
library(data.table)
# read SCC rds file and NEI file
scc <- readRDS("Source_Classification_Code.rds")
NEI <- data.table(readRDS("summarySCC_PM25.rds")) 
# select SCC variables from column scc data frame in EI.Sector by name "Comb" and "Coal"
coal_comb <- sqldf("select SCC from scc where EI_Sector like '%Comb%Coal%'")
# subset NEI df by coal_comb$SCC data
coal_NEI <- NEI[SCC %in% coal_comb[,1],]
# sum of emissions by year 
sum_coal_NEI <- tapply(coal_NEI$Emissions, coal_NEI$year, sum)
# stop abbreviation of y axis (emissions values)
options(scipen = 100000)
# create boxplots from sum_coal_NEI 
png("plot4.png", width = 480, height = 480)
barplot(sum_coal_NEI, col = c("darkblue"), main = "Coal combustion emissions in the USA", xlab = "Years", ylab = "Emissions in tons", cex.lab = 1.4)
dev.off()

