# Question 6

library(data.table)
library(sqldf)
# read rds files
scc <- readRDS("Source_Classification_Code.rds")
NEI <- data.table(readRDS("summarySCC_PM25.rds")) 
# select motor vehicles data
motor <- sqldf("select * from scc where EI_Sector like '%Mobile - On-Road%'")
# subset motor vehicle data in Baltimore City
motor_balt <- NEI[NEI$SCC %in% motor$SCC & NEI$fips == "24510",]
# sum emissions from motor vehicles in Baltimore City by year
sum_motor_balt <- tapply(motor_balt$Emissions, motor_balt$year, sum)
# subset motor vehicle data in LA
motor_LA <- NEI[NEI$SCC %in% motor$SCC & NEI$fips == "06037",]
# sum emissions from motor vehicles in LA by year
sum_motor_LA <- tapply(motor_LA$Emissions, motor_LA$year, sum)
# create matrix from LA and Baltimore emissions sum data
balt_LA_matrix <- rbind(sum_motor_balt, sum_motor_LA)
png("plot6.png", width = 480, height = 480)
# make barplot with special conditions
balt_LA_plot <- barplot(balt_LA_matrix, beside = T, main = "Emissions from motor vehicles in LA and Baltimore City", ylab = "Emissions in tons", xlab = "Years")
mtext(1, at = balt_LA_plot, text = c("Baltimore", "LA"), line = 0, cex = 0.8)
dev.off()
