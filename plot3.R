## Download files for project
if(!file.exists("./datasets")){dir.create("./datasets")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl,destfile="./datasets/Dataset.zip")

## Unzip dataSet and make directory
unzip(zipfile="./datasets/Dataset.zip",exdir="./datasets")

data <- read.table("./datasets//household_power_consumption.txt", header = TRUE,
                   sep = ";", na.strings = "?", colClasses = c('character',
                                                               'character','numeric','numeric','numeric','numeric','numeric'
                                                               ,'numeric','numeric'))


## Format date and subset data.  Subset data to dates needed (2007-02-01 and 2007-02-02)
data$Date <- as.Date(data$Date, "%d/%m/%Y")
data <- subset(data, Date >= as.Date("2007-2-1") & Date <= as.Date("2007-2-2"))

## Remove any missing data
data <- data[complete.cases(data) ,]

## Merge data and time and make one column.  Remove Date and Time columns, Insert 
## and format merged column 
DateTime <- paste(data$Date, data$Time)
DateTime <- setNames(DateTime, "DateTime")
data <- data[ , !(names(data) %in% c("Date", "Time"))]
data <- cbind(DateTime, data)
data$DateTime <- as.POSIXct(DateTime)


##Create and save png of plot3

plot(data$Sub_metering_1 ~ data$DateTime, type = "l", xlab = "",  
     ylab = "Energy sub metering")
lines(data$Sub_metering_2 ~ data$DateTime, col = "red")
lines(data$Sub_metering_3 ~ data$DateTime, col = "blue")
        

legend("topright", col = c("black", "red", "blue"), c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lwd = c(2, 2, 2))


dev.copy(png,"plot3.png", width = 480, height = 480)
dev.off()