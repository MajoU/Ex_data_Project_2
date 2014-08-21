# Question 2

# subsetting NEI data by specific value of fips column
library(data.table)
NEI <- data.table(readRDS("summarySCC_PM25.rds")) 
balt <- NEI[NEI$fips == "24510", ]
# make sum of emissions by year from the subset data
balt_sum <- tapply(balt$Emissions, balt$year, sum)
# creat plot png file
png("plot2.png", width = 480, height = 480)
barplot(balt_sum, main = "Total emissions in the Baltimore City", xlab = "Years", ylab = "Emissions in tons", cex.lab = 1.4)
dev.off()
