library(ggplot2)
library(dplyr)
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
png("plot6.png", width = 861, height = 532)

# create SCC data subset with motor vehicle emissions in Baltimore and Los Angeles
motorData <- grepl("vehicles", SCC$EI.Sector,ignore.case = TRUE)
motorData <- subset(SCC,motorData)
Balt.LA.Emit <- subset(NEI, fips == "24510" | fips == "06037")

# create NEI data subset with motor vehicle emissions in Baltimore and Los Angeles
Balt.LA.Vehicle <- Balt.LA.Emit[Balt.LA.Emit$SCC %in% motorData$SCC,]

# rename zip code with city names
Balt.LA.Vehicle <- mutate(Balt.LA.Vehicle, fips = gsub("24510", "Baltimore City", fips))
Balt.LA.Vehicle <- mutate(Balt.LA.Vehicle, fips = gsub("06037", "Los Angeles", fips))

# plot Emissions vs Year using ggplot2
Balt.LA.Plot <- ggplot(Balt.LA.Vehicle, aes(factor(year),Emissions,fill = factor(year)))
Balt.LA.Plot + geom_bar(stat="identity") + labs(title = expression("PM"[2.5]*" Emissions from motor vehicle sources in Baltimore City & Los Angeles")) +
        xlab("Year") + ylab(expression("PM"[2.5]*" Emissions")) + facet_grid(.~fips) + guides(fill=guide_legend(title="Year"))

dev.off()