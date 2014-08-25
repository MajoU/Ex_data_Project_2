 library(data.table)
 library(sqldf)
 library(RDS)

## load files into Data Tables and set keys, SCC, to join tables
file<-"summarySCC_PM25.rds" 
file2<-"Source_Classification_Code.rds"

DT1<-data.table(readRDS(file))
DT2<-data.table(readRDS(file2))
setkey(DT1,SCC)
setkey(DT2,SCC)
DT_main<-merge(DT1,DT2)

## Using sqldf() to sum emissions and group by year. This rolls the data 
## up to the national level which is the level we are interested in
DT_coal<-sqldf('select sum(Emissions) as emissions, year from DT_main where SCC_Level_One like "%Combustion%" and SCC_Level_Three like "%Coal%" group by year')
## Use ggplot2() to create a line graph to illustrate emissions by year
g<-ggplot(DT_coal ,aes(year, emissions))
p<-g+geom_line(direction="hv", colour="blue", alpha=0.5)+geom_point(colour="red")+ labs(title="Coal Emissions: All Counties")
ggsave(file="plot4.png",plot=p, dpi=100)
dev.off()

