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
png("plot4.png", width = 861, height = 532)

# create SCC data subset with coal combustion-related emissions
coalData <- grepl("coal", SCC$Short.Name,ignore.case = TRUE)
coalData <- subset(SCC,coalData)

# create NEI data subset with coal combustion-related emissions
NEICoal <- NEI[NEI$SCC %in% coalData$SCC,]

# plot Emissions vs Year using ggplot2
CoalPlot <- ggplot(NEICoal, aes(factor(year),Emissions))
CoalPlot + geom_bar(stat="identity",aes(fill= factor(NEICoal$year))) + guides(fill=guide_legend(title="Year")) +
        labs(title = expression("PM"[2.5]*" Emissions from coal combustion-related sources")) +
        xlab("Year") + ylab(expression("PM"[2.5]*" Emissions"))

dev.off()