library(data.table)
library(dplyr)
NEI <- readRDS("./summarySCC_PM25.rds")
SCC <- readRDS("./Source_Classification_Code.rds")

png(filename = "plot2.png")

temp <- NEI %>% filter(fips==24510) %>% group_by(year) %>% summarise(Emissions = sum(Emissions))
with(temp, barplot(Emissions,names=year, xlab = "Years", ylab = "Emissions"
                   , main = "Emissions over the Years in Baltimore City",col = "skyblue3"))

dev.off()
