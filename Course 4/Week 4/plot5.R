library(data.table)
library(dplyr)
library(ggplot2)
NEI <- readRDS("./summarySCC_PM25.rds")
SCC <- readRDS("./Source_Classification_Code.rds")

png(filename = "plot5.png")


vehicle <- SCC[with(SCC, grepl(pattern = "vehicle",SCC.Level.Two,ignore.case = T)),1]
data <- NEI %>% filter(SCC %in% vehicle & fips == 24510)     

ggplot(data = data,mapping = aes(x = factor(year),y = Emissions))+geom_bar(stat = "identity",fill = "skyblue3")+
        labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore from 1999-2008"))+
        labs(x="year", y=expression("Total PM"[2.5]*" Emission (10^5 Tons)"))+
        theme(plot.title = element_text(hjust = 0.5))

dev.off()       
