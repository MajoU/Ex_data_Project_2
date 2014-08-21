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

