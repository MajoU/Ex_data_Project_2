# Question 4

library(data.table)

# read SCC rds file and NEI file
scc <- data.table(readRDS("Source_Classification_Code.rds"))
NEI <- data.table(readRDS("summarySCC_PM25.rds")) 

# find all variables from column EI.Sector with names "Comb" and "Coal" 
# and select SCC column with same index as "Comb" - "Coal" viriables
comb_coal <- scc[EI.Sector %in% grep("(Comb.*Coal)", EI.Sector, value = T), SCC]

#--------------------------------------------------
#  ALTERNATIVE THROUGH sqldf() package

#  comb_coal <- sqldf("select SCC from scc where EI_Sector like '%Comb%Coal%'")
#--------------------------------------------------

# subset NEI by SCC values that are in comb_coal
coal_NEI <- NEI[SCC %in% comb_coal,]
# sum of emissions by year 
coal_NEI_sum <- coal_NEI[, list(emis = sum(Emissions)), by = year]

# ----------------------------------------------------
#   ALTERNATIVE THROUGH tapply()

# coal_NEI_sum <- tapply(coal_NEI$Emissions, coal_NEI$year, sum)
# ----------------------------------------------------

# stop abbreviation of y axis (emissions values)
options(scipen = 100000)

# create boxplots from sum_coal_NEI 
png("plot4.png", width = 480, height = 480)
barplot(coal_NEI_sum$emis, col = c("darkblue"), main = "Coal combustion emissions in the USA", xlab = "Years", ylab = "Emissions in tons", cex.lab = 1.4)
dev.off()

