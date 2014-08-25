# Question 5

library(data.table)
library(sqldf)
# read rds files
scc <- readRDS("Source_Classification_Code.rds")
NEI <- data.table(readRDS("summarySCC_PM25.rds")) 
# select motor vehicles from scc df in EI.Sector column by
# name "Mobile - On-Road"
motor <- sqldf("select SCC from scc where EI_Sector like '%Mobile - On-Road%'")
# subset motor vehicle data in Baltimore City
motor_balt <- NEI[SCC %in% motor[,1] & fips == "24510",]
# sum emissions from motor vehicles in Baltimore City by year
sum_motor_balt <- tapply(motor_balt$Emissions, motor_balt$year, sum)
# create plot
png("plot5.png", width = 480, height = 480)
barplot(sum_motor_balt, col = c("darkblue"), main = "Emissions from motor vehicles in Baltimore City", xlab = "Years", ylab = "Emissions in tons", cex.lab = 1.4)
dev.off()

