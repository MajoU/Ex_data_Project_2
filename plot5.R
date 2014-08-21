# Question 5

library(data.table)
library(sqldf)
scc <- readRDS("Source_Classification_Code.rds")
NEI <- data.table(readRDS("summarySCC_PM25.rds")) 
motor <- sqldf("select * from scc where EI_Sector like '%Mobile - On-Road%'")
motor_balt <- NEI[NEI$SCC %in% motor$SCC & NEI$fips == "24510",]
sum_motor_balt <- tapply(motor_balt$Emissions, motor_balt$year, sum)
png("plot5.png", width = 480, height = 480)
barplot(sum_motor_balt, col = c("darkblue"), main = "Emissions from motor vehicles in Baltimore City", xlab = "Years", ylab = "Emissions in tons", cex.lab = 1.4)
dev.off()

