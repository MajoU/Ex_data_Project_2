# Question 2

library(data.table)

NEI <- data.table(readRDS("summarySCC_PM25.rds")) 

# subsetting NEI data by specific value of fips column
balt <- NEI[fips == "24510", ]

# make sum of emissions by year from the subset data
balt <- balt[, list(emis = sum(Emissions)), by = year]

# creat plot png file
png("plot2.png", width = 480, height = 480)
barplot(balt$emis, main = "Total emissions in the Baltimore City", xlab = "Years", ylab = "Emissions in tons", cex.lab = 1.4)
dev.off()
