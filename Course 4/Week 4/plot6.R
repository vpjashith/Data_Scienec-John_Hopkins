library(data.table)
library(dplyr)
library(ggplot2)
NEI <- readRDS("./summarySCC_PM25.rds")
SCC <- readRDS("./Source_Classification_Code.rds")

vehicle <- SCC[with(SCC, grepl(pattern = "vehicle",SCC.Level.Two,ignore.case = T)),1]

vehiclesBaltimoreNEI <- NEI %>% filter(SCC %in% vehicle & fips == "24510")
vehiclesBaltimoreNEI$city <- "Baltimore City"

vehiclesLANEI <- NEI %>% filter(SCC %in% vehicle & fips == "06037")
vehiclesLANEI$city <- "Los Angeles"

vehicles_Balt_LA_NEI <- rbind(vehiclesBaltimoreNEI,vehiclesLANEI) 

png(filename = "plot6.png")
ggplot(data = vehicles_Balt_LA_NEI,mapping = aes(x = factor(year),y = Emissions))+
        geom_bar(stat = "identity",fill = "skyblue3")+facet_grid(.~city)+
        labs(x="year", y=expression("Total PM"[2.5]*" Emission (Kilo-Tons)")) + 
        labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore & LA, 1999-2008"))+
        theme(plot.title = element_text(hjust = 0.5))
dev.off()

