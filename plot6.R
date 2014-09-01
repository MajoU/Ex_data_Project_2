# Question 6

library(data.table)

scc <- data.table(readRDS("Source_Classification_Code.rds"))
NEI <- data.table(readRDS("summarySCC_PM25.rds")) 

# BALT DATA

# select motor vehicles data
motor <- scc[EI.Sector %in% grep("(Mobile.*On.*Road)", EI.Sector, value = T), SCC]

# subset motor vehicle data in Baltimore City
motor_balt <- NEI[SCC %in% motor & fips == "24510",]

# sum emissions from motor vehicles in Baltimore City by year
motor_balt_sum <- motor_balt[, list(emis = sum(Emissions)), by = year]

# LA DATA 

# subset motor vehicle data in LA
motor_LA <- NEI[SCC %in% motor & fips == "06037",]

# sum emissions from motor vehicles in LA by year
motor_LA_sum <- motor_LA[, list(emis = sum(Emissions)), by = year]

# create matrix from LA and Baltimore emissions sum data
balt_LA_matrix <- as.matrix(rbind(motor_balt_sum, motor_LA_sum))




png("plot6.png", width = 640, height = 480)
par(mfrow= c(1,2))
barplot(motor_balt_sum$emis, main = "Emissions from motor vehicles in Baltimore City", 
        cex.lab = 1.4, ylab = "Emissions in tons", xlab = "Years", col = "darkblue")
barplot(motor_LA_sum$emis, main = "Emissions from motor vehicles in LA", cex.lab = 1.4, 
        ylab = "Emissions in tons", xlab = "Years", col = "steelblue")
dev.off()
