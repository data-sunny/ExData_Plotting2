# plot6.R
# read data
nei <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")

# subset to baltimore and los angeles data
bm_nei <- subset(nei, fips == "24510")
la_nei <- subset(nei, fips == "06037")

# create search string and identify rows
search <- "([Vv]ehicle|[Vv]eh)"
bmla <- grep( search, scc$Short.Name ) # ; dim(bmla); length(bmla); str(bmla)

# subset scc file data for rows containing strings veh/Vehicle
bmla1 <- scc[ bmla , ] # ; class(bmla1); dim(bmla1); str(bmla1)
bmla2 <- subset(bmla1, select = SCC) # subset 1st column containing SCC ids # ; class(bmla2); dim(bmla2); str(bmla2)

# subset baltimore and los angeles nei file data per veh/Vehicle contaning ids from scc files
bm_veh <- subset( bm_nei, bm_nei$SCC%in%bmla2$SCC) # ;class(bm_veh); dim(bm_veh); str(bm_veh)
la_veh <- subset( la_nei, la_nei$SCC%in%bmla2$SCC) # ; class(la_veh); dim(la_veh); str(la_veh)

# sum emissions data by Year
Total_Emissions_Baltimore<- tapply( bm_veh$Emissions, bm_veh$year, sum) # create Y axis
Total_Emissions_Los_Angeles <- tapply( la_veh$Emissions, la_veh$year, sum) # create Y axis
# class(Total_Emissions_Baltimore); dim(Total_Emissions_Baltimore)

# Prepare a data set Normalized by values in 1999

Total_Emissions_Baltimore_nrmlzd <- Total_Emissions_Baltimore/Total_Emissions_Baltimore[1]
Total_Emissions_Los_Angeles_nrmlzd <- Total_Emissions_Los_Angeles/Total_Emissions_Los_Angeles[1]


# make plot
png("plot6.png", width=840, height=840, units="px") # open png file
par( mfrow=c(2,2), mar=c(5,5,7,5) )

Year <- c(1999, 2002, 2005, 2008)
plot(Year, Total_Emissions_Baltimore_nrmlzd, type='l',xlab="Year", ylab=" Change in Emission levels", ylim = c(0., 1.5) )
  title(  main= "Comparison of Emission levels Change - Using 1999 values as reference")
  legend("topright", legend = c("Baltimore", "Los Angeles"), col = c("green", "yellow"), lty = c(1,1))
  lines(Year, Total_Emissions_Baltimore_nrmlzd, col = "green", type="l")
  lines(Year, Total_Emissions_Los_Angeles_nrmlzd, col = "yellow", type="l")
  grid()

barplot(Total_Emissions_Baltimore, xlab="Year", ylab = "Emissions", main = "Total Emissions from motor vehicle sources
        in Baltimore", col= "green")
barplot(Total_Emissions_Los_Angeles, xlab="Year", ylab = "Emissions", main = "Total Emissions from motor vehicle sources
        in Los Angeles", col = "yellow")

dev.off()   # close png filedevice

# ================ the plots below plot Normalized values =============
#barplot(Total_Emissions_Baltimore_nrmlzd, xlab="Year", ylab = "Emissions", main = "Normalized Emissions from motor vehicle sources
#        in Baltimore - using 1999 values as reference")

#barplot(Total_Emissions_Los_Angeles_nrmlzd, xlab="Year", ylab = "Emissions", main = "Normalized Emissions from motor vehicle sources
#        in Los Angeles - using 1999 values as reference", col="yellow")

#dev.off()

