library(ggplot2)
# Create working directory if necessary
if(!file.exists("~/Data/")){
        dir.create("~/Data/")
}

# Determine if dataset has been loaded to global environment
if(!exists("NEI", envir = globalenv()) | !exists("SCC", envir = globalenv())){
        
        # Download and unzip the data
        fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
        download.file(fileUrl, destfile = "~/Data/exdata_data_NEI_data/NEI_data.zip")
        unzip(zipfile = "~/data/exdata_data_NEI_data/NEI_data.zip", exdir = "~/data/exdata_data_NEI_data")
        
        # Set working directory
        datasetPath <- "~/data/"
        setwd(file.path(datasetPath, "exdata_data_NEI_data"))
        
        # Read data to R
        NEI <- readRDS("summarySCC_PM25.rds")
        SCC <- readRDS("Source_Classification_Code.rds")
        
}


# Launch png graphics device
png("plot5.png", width = 861, height = 532)

# create SCC data subset with motor vehicle emissions in Baltimore
motorData <- grepl("vehicles", SCC$EI.Sector,ignore.case = TRUE)
motorData <- subset(SCC,motorData)

# create NEI data subset with motor vehicle emissions in Baltimore
BaltEmit <- subset(NEI, fips == "24510")
BaltVehicle <- BaltEmit[BaltEmit$SCC %in% motorData$SCC,]

# plot Emissions vs Year using ggplot2
vehiclePlot <- ggplot(BaltVehicle, aes(factor(year),Emissions))
vehiclePlot + geom_bar(stat="identity",aes(fill= factor(BaltVehicle$year))) + guides(fill=guide_legend(title="Year")) +
        labs(title = expression("PM"[2.5]*" Emissions from motor vehicle sources in Baltimore City")) +
        xlab("Year") + ylab(expression("PM"[2.5]*" Emissions"))

dev.off()