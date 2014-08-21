# Question 6

library(data.table)
library(sqldf)
scc <- readRDS("Source_Classification_Code.rds")
NEI <- data.table(readRDS("summarySCC_PM25.rds")) 
motor <- sqldf("select * from scc where EI_Sector like '%Mobile - On-Road%'")
motor_balt <- NEI[NEI$SCC %in% motor$SCC & NEI$fips == "24510",]
sum_motor_balt <- tapply(motor_balt$Emissions, motor_balt$year, sum)
motor_LA <- NEI[NEI$SCC %in% motor$SCC & NEI$fips == "06037",]
sum_motor_LA <- tapply(motor_LA$Emissions, motor_LA$year, sum)
balt_LA_matrix <- rbind(sum_motor_balt, sum_motor_LA)
png("plot6.png", width = 480, height = 480)
balt_LA_plot <- barplot(balt_LA_matrix, beside = T, main = "Emissions from motor vehicles in LA and Baltimore City", ylab = "Emissions in tons", xlab = "Years")
mtext(1, at = balt_LA_plot, text = c("Baltimore", "LA"), line = 0, cex = 0.8)
dev.off()
