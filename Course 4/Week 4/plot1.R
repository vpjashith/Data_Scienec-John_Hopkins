library(data.table)
library(dplyr)
NEI <- readRDS("./summarySCC_PM25.rds")
SCC <- readRDS("./Source_Classification_Code.rds")

png(filename = "plot1.png")

temp <- NEI %>% group_by(year) %>% summarise(Emissions = sum(Emissions))
with(temp, barplot(Emissions,names=year, xlab = "Years", ylab = "Emissions"
                   , main = "Emissions over the Years",col = "skyblue3"))

dev.off()
