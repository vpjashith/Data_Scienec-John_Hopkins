# Adding necessary library
library(data.table)

# Reading the dataset 
dataset <-fread("./household_power_consumption.txt",na.strings = "?")

# Converting Date variable from character to date type
dataset$Date <- lubridate::dmy(dataset$Date)

# Filtering the dataset
dataset <- dataset[dataset$Date >= "2007-02-01" & dataset$Date <= "2007-02-02",]

# Setting extrenal environment for image
png("plot3.png", width=480, height=480)

# Creating datetime variable
dataset$datetime <- parse_date_time(paste(dataset$Date,dataset$Time),"Ymd HMS")

# Plotting
plot(x = dataset$datetime,y = dataset$Sub_metering_1,type = "l", xlab="", ylab="Energy sub metering")
lines(x =dataset$datetime,y = dataset$Sub_metering_2,col="red" )
lines(x =dataset$datetime,y = dataset$Sub_metering_3,col="blue" )
legend("topright", col=c("black","red","blue"), c("Sub_metering_1  ","Sub_metering_2  ", "Sub_metering_3  "),lty=c(1,1), lwd=c(1,1))

dev.off()
