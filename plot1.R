# read the data files

  nei <- readRDS("summarySCC_PM25.rds")
  scc <- readRDS("Source_Classification_Code.rds")

# subset the data and calculate the sum/total of emissions
  Total_Emissions <- tapply( nei$Emissions, nei$year, sum)
  
# plot the data
  png("plot1.png", width=480, height=480, units="px") # open png file
  barplot(Total_Emissions, xlab="Year", ylab = "Emissions", main = "Total Emissions in United States from all sources")
  dev.off()   # close png filedevice