
# read data
  nei <- readRDS("summarySCC_PM25.rds")
  scc <- readRDS("Source_Classification_Code.rds")

# subset to baltimore data
  bm_nei <- subset(nei, fips == "24510")

# create search string and identify rows
  search <- "([Vv]ehicle|[Vv]eh)"
  bm <- grep( search, scc$Short.Name ) # ; dim(bm); length(bm); str(bm)

# subset scc file data for rows containing strings veh/Vehicle
  bm1 <- scc[ bm , ] # ; class(bm1); dim(bm1); str(bm1)
  bm2 <- subset(bm1, select = SCC) # subset 1st column containing SCC ids # ;class(bm2); dim(bm2); str(bm2)

# subset baltimore nei file data per veh/Vehicle contaning ids from scc files
  bm_veh <- subset( bm_nei, bm_nei$SCC%in%bm2$SCC) # ;class(bm_veh); dim(bm_veh); str(bm_veh)
  
# sum emissions data by Year
  Total_Emissions <- tapply( bm_veh$Emissions, bm_veh$year, sum) # create Y axis

# make plot

  png("plot5.png", width=480, height=480, units="px") # open png file
  barplot(Total_Emissions, xlab="Year", ylab = "Emissions", main = "Total Emissions from motor vehicle sources
        (1999 to 2008) in Baltimore")
  dev.off()   # close png filedevice