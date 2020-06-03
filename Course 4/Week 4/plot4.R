library(data.table)
library(dplyr)
NEI <- readRDS("./summarySCC_PM25.rds")
SCC <- readRDS("./Source_Classification_Code.rds")

combustionRelated <- with(SCC, grepl("comb",SCC.Level.One, ignore.case=T))
coalRelated <- with(SCC, grepl("coal",SCC.Level.Four, ignore.case=T))
combustionSCC <- SCC[combustionRelated & coalRelated, 1]
combustionNEI <- filter(.data = NEI,SCC %in% combustionSCC )


png(filename = "plot4.png")

ggplot(combustionNEI,aes(x = factor(year),y = Emissions))+
        geom_bar(stat ="identity",fill = "skyblue3")+
        labs(x="year", y=expression("Total PM"[2.5]*" Emission")) + 
        labs(title=expression("PM"[2.5]*" Coal Combustion Source Emissions Across US from 1999-2008"))+
        theme(plot.title = element_text(hjust = 0.5))

dev.off()
