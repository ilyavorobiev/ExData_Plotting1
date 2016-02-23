# Load libraries
library(sqldf)

# Download and unzip data
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp, mode="wb")
unzip(temp, "household_power_consumption.txt")

# Read data skipping dates. We only need 1/2/2007 and 2/2/2007 
consumption <- read.csv.sql("household_power_consumption.txt", sql = 'select * from file where Date = "1/2/2007" or Date = "2/2/2007"', sep = ";")

# Format data
consumption[consumption == "?"] <- NA
consumption$DateTime <- as.POSIXct(paste(consumption$Date, consumption$Time), format="%d/%m/%Y %H:%M:%S")

# Transparent graphics
par(bg = "transparent")

# Create plot
plot(consumption$DateTime,consumption$Sub_metering_1, 
     type ="l",
     ylab = "Energy sub metering",
     xlab = NA,
     main = NA)

lines(consumption$DateTime,consumption$Sub_metering_2,
      type = "l",
      col = "red",
      lty = 1)

lines(consumption$DateTime,consumption$Sub_metering_3,
      type = "l",
      col = "blue",
      lty = 1)

legend("topright", lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))


# Copy to file
dev.copy(png, file = "plot3.png",height=480,width=480)
dev.off()
