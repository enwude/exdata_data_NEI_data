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
png("plot1.png", width = 861, height = 532)

# compute summary statistics of data subsets by year
Emit <- with(NEI, aggregate(Emissions, by = list(year), sum))

# rename variables in subset
names(Emit) <- c("Year","Emissions")

# Plot Emissions vs Year using base plotting system
with(Emit, barplot(Emissions, Year, col = factor(Year),xlab = "Year", ylab = "Emissions", names.arg = Year, 
                   legend.text= Year, main = "Total PM Emissions from 1999 - 2008 in the United States"))

dev.off()