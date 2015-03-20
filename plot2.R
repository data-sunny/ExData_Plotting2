# plot2.R
# read the data files

nei <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")

# subset to extract Baltimore data and calculate the sum/total of emissions 

balt_nei <- subset(nei, fips == "24510")
Total_Emissions <- tapply( balt_nei$Emissions, balt_nei$year, sum)

# plot the data

png("plot2.png", width=480, height=480, units="px") # open png file
x_data <- barplot(Total_Emissions, xlab="Year", ylab = "Emissions", main = "Total Emissions in Baltimore from all sources")
lines(x=x_data, y=Total_Emissions, col="blue") # overalay barplot with lines
dev.off()   # close png filedevice