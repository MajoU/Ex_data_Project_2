# Question 3

library(data.table)
library(plyr)
library(ggplot2)
NEI <- data.table(readRDS("summarySCC_PM25.rds")) 
# subset Baltimore City data
balt <- NEI[fips == "24510", ]
# create data frame with sum of emissions by years and type
balt_type <- ddply(balt, .(year, type), summarize, emissions = sum(Emissions))
# make plot through ggplot2
g <- ggplot(balt_type, aes(year,emissions)) 
g + geom_line(aes(color = type), size = 2) + geom_point() + labs(title = "Baltimore emissions from type of source") + labs(x = "Years", y = "Emissions in tons")
ggsave("plot3.png")

