# Question 1

library(data.table)
# read rds data and make data.table from it
NEI <- data.table(readRDS("summarySCC_PM25.rds")) 
# create table with sum of emissions by year
sum_emission <- tapply(NEI$Emissions, NEI$year, sum) 

# stop abbreviation in y axis (emissions)
options(scipen = 100000)
# make plot png file
png("plot1.png", width = 480, height = 480)
barplot(sum_emission, main = "Total emissions in the USA", xlab = "Years", ylab = "Emissions in tons", cex.lab = 1.4)
dev.off()

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

# cex.lab is size of labs and cex.main is size of title (main)

# Question 3

library(data.table)
library(plyr)
library(ggplot2)
NEI <- data.table(readRDS("summarySCC_PM25.rds")) 
balt <- NEI[NEI$fips == "24510", ]
balt_type <- ddply(balt, .(year, type), summarize, emissions = sum(Emissions))
g <- ggplot(balt_type, aes(year,emissions)) 
g + geom_line(aes(color = type), size = 2) + geom_point() + labs(title = "Baltimore emissions from type of source") + labs(x = "Years", y = "Emissions in tons")
ggsave("plot3.png", width=8,height=8, dpi = 480)
# dev.off()

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



