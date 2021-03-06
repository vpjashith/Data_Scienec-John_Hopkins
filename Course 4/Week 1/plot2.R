# Adding necessary library
library(data.table)

# Reading the dataset 
dataset <-fread("./household_power_consumption.txt",na.strings = "?")

# Converting Date variable from character to date type
dataset$Date <- lubridate::dmy(dataset$Date)

# Filtering the dataset
dataset <- dataset[dataset$Date >= "2007-02-01" & dataset$Date <= "2007-02-02",]

# Setting extrenal environment for image
png("plot2.png", width=480, height=480)

# Creating datetime variable
dataset$datetime <- parse_date_time(paste(dataset$Date,dataset$Time),"Ymd HMS")

# Plotting
plot(x = dataset$datetime,y = dataset$Global_active_power,type = "l", xlab="", ylab="Global Active Power (kilowatts)")
dev.off()
