library(ggplot2)
# Create working directory if necessary
if(!file.exists("~/Data/")){
        dir.create("~/Data/")
}

# Determine if dataset has been loaded to global environment
if(!exists("NEI", envir = globalenv())){
        
        # Download and unzip the data
        fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
        download.file(fileUrl, destfile = "~/Data/exdata_data_NEI_data/NEI_data.zip")
        unzip(zipfile = "~/data/exdata_data_NEI_data/NEI_data.zip", exdir = "~/data/exdata_data_NEI_data")
        
        # Set working directory
        datasetPath <- "~/data/"
        setwd(file.path(datasetPath, "exdata_data_NEI_data"))
        
        # Read data to R
        NEI <- readRDS("summarySCC_PM25.rds")        
        
}

# Launch png graphics device
png("plot3.png", width = 861, height = 532)

# create NEI data subset with Baltimore City emissions
BaltEmit <- subset(NEI, fips == "24510")

# plot Emissions vs Year using ggplot2
BaltPlot <- ggplot(BaltEmit, aes(factor(year),Emissions))
BaltPlot + geom_bar(stat="identity", aes(fill=type)) + facet_grid(.~type) + 
        labs(title = expression("Baltimore City Emissions (PM"[2.5]*") by type")) +
             xlab("Year") + ylab(expression("PM"[2.5]*" Emissions"))

dev.off()