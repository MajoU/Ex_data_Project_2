# Question 1

library(data.table)
library(sqldf)
library(plyr)
library(ggplot2)

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

# Question 2

# subsetting NEI data by specific value of fips column
balt <- NEI[fips == "24510", ]
# make sum of emissions by year from the subset data
balt_sum <- tapply(balt$Emissions, balt$year, sum)
# creat plot png file
png("plot2.png", width = 480, height = 480)
barplot(balt_sum, main = "Total emissions in the Baltimore City", xlab = "Years", ylab = "Emissions in tons", cex.lab = 1.4)
dev.off()

# cex.lab is size of labs and cex.main is size of title (main)

# Question 3

balt_type <- balt[, list(emissions = sum(Emissions)), by = c("year", "type")]
g <- ggplot(balt_type, aes(year,emissions)) 
g + geom_line(aes(color = type), size = 2) + geom_point() + labs(title = "Baltimore emissions from type of source") + labs(x = "Years", y = "Emissions in tons")
ggsave("plot3.png", width=8,height=8, dpi = 480)

#-----------------------------------------------------------------
#  ALTERNATIVE LIKE PLYR

# balt_type <- ddply(balt, .(year, type), summarize, emissions = sum(Emissions))
#-----------------------------------------------------------------

# Question 4

# read new rds file
scc <- data.table(readRDS("Source_Classification_Code.rds"))
# select all variables from column EI.Sector as "Comb" and "Coal" like names
# and select SCC column with this variables
comb_coal <- scc[EI.Sector %in% grep("(Comb.*Coal)", EI.Sector, value = T), SCC]

#--------------------------------------------------
#  ALTERNATIVE THROUGH sqldf() package

#  comb_coal <- sqldf("select SCC from scc where EI_Sector like '%Comb%Coal%'")
#--------------------------------------------------

# subset NEI data by variables from coal_comb
coal_NEI <- NEI[SCC %in% comb_coal,]
# sum of emissions by year 
coal_NEI_sum <- tapply(coal_NEI$Emissions, coal_NEI$year, sum)
# stop abbreviation of y axis (emissions values)
options(scipen = 100000)
# create boxplots from sum_coal_NEI
png("plot4.png", width = 480, height = 480)
barplot(coal_NEI_sum, col = c("darkblue"), main = "Coal combustion emissions in the USA", xlab = "Years", ylab = "Emissions in tons", cex.lab = 1.4)
dev.off()

# Question 5

# select motor vehicles from scc data frame from EI.Sector column by
# variable "Mobile - On-Road"
motor <- scc[EI.Sector %in% grep("(Mobile.*On.*Road)", EI.Sector, value = T), SCC]

#------------------------------------------------------
#  ALTERNATIVE THROUGH sqldf()

# motor <- sqldf("select SCC from scc where EI_Sector like '%Mobile - On-Road%'")
#------------------------------------------------------ 

# subset motor vehicle data in Baltimore City
motor_balt <- NEI[SCC %in% motor & fips == "24510",]
# sum emissions from motor vehicles in Baltimore City by year
motor_balt_sum <- tapply(motor_balt$Emissions, motor_balt$year, sum)
# create plot
png("plot5.png", width = 480, height = 480)
barplot(motor_balt_sum, col = c("darkblue"), main = "Emissions from motor vehicles in Baltimore City", xlab = "Years", ylab = "Emissions in tons", cex.lab = 1.4)
dev.off()


# Question 6

# subset motor vehicle data in LA
motor_LA <- NEI[SCC %in% motor & fips == "06037",]
# sum emissions from motor vehicles in LA by year
motor_LA_sum <- tapply(motor_LA$Emissions, motor_LA$year, sum)
# create matrix from LA and Baltimore emissions sum data
balt_LA_bind <- rbind(motor_balt_sum, motor_LA_sum)
# make barplot with special conditions
png("plot6.png", width = 480, height = 480)
balt_LA_bind <- barplot(balt_LA_bind, beside = T, main = "Emissions from motor vehicles in LA and Baltimore City", ylab = "Emissions in tons", xlab = "Years")
mtext(1, at = balt_LA_bind, text = c("Baltimore", "LA"), line = 0, cex = 0.8)
dev.off()



