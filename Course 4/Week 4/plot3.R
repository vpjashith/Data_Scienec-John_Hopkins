library(data.table)
library(dplyr)
library(ggplot2)
NEI <- readRDS("./summarySCC_PM25.rds")

temp <- NEI %>% filter(fips==24510) %>% group_by(year,type) %>% summarise(Emissions = sum(Emissions))

png(filename = "plot3.png")

ggplot(data = temp,mapping = aes(x = factor(year),y = Emissions))+geom_bar(stat = "identity",fill = "skyblue3")+facet_grid(~type)+
        xlab(c("1997","2002", "2005","2008"))+labs(x="year", y=expression("Total PM"[2.5]*" Emission (Tons)"))+
        labs(title=expression("PM"[2.5]*" Emissions, Baltimore City 1999-2008 by Source Type"))+
        theme(plot.title = element_text(hjust = 0.5))

dev.off()
