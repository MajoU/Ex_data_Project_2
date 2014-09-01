# Question 5

library(data.table)

# read rds files
scc <- data.table(readRDS("Source_Classification_Code.rds"))
NEI <- data.table(readRDS("summarySCC_PM25.rds")) 

# select motor vehicles from scc df in EI.Sector column by
# name "Mobile - On-Road"
motor <- scc[EI.Sector %in% grep("(Mobile.*On.*Road)", EI.Sector, value = T), SCC]

#------------------------------------------------------
#  ALTERNATIVE THROUGH sqldf()

# motor <- sqldf("select SCC from scc where EI_Sector like '%Mobile - On-Road%'")
#------------------------------------------------------ 

# subset motor vehicle data in Baltimore City
motor_balt <- NEI[SCC %in% motor & fips == "24510",]

# sum emissions from motor vehicles in Baltimore City by year
motor_balt_sum <- motor_balt[, list(emis = sum(Emissions)), by = year]

# create plot
png("plot5.png", width = 480, height = 480)
barplot(motor_balt_sum$emis, col = c("darkblue"), main = "Emissions from motor vehicles in Baltimore City", xlab = "Years", 
        ylab = "Emissions in tons", cex.lab = 1.4)
dev.off()

