# plot3.R
# read data
    nei <- readRDS("summarySCC_PM25.rds")
    scc <- readRDS("Source_Classification_Code.rds")
    
# subset data to baltimore
  balt_nei <- subset(nei, fips == "24510")

# subset data by type of source
  install.packages("data.table"); library(data.table)
    
  balt <- data.table(balt_nei)
  balt_point <- balt[ balt$type=="POINT", sum(Emissions), by=year ]
  balt_nonpoint <- balt[ balt$type=="NONPOINT", sum(Emissions), by=year]
  balt_onroad <- balt[ balt$type=="ON-ROAD", sum(Emissions), by=year]
  balt_nonroad <- balt[ balt$type=="NON-ROAD", sum(Emissions), by=year]

# develop a new table which combines data from the 4 sources above
  install.packages("dplyr"); library(dplyr)
    
  bm_point <- mutate(balt_point, type = "POINT")            # add a column with string POINT
  bm_nonpoint <- mutate(balt_nonpoint, type = "NONPOINT")   # add a column with string NONPOINT
  bm_onroad <- mutate(balt_onroad, type = "ON-ROAD")        # add a column with string ON-ROAD
  bm_nonroad <- mutate(balt_nonroad, type = "NON-ROAD")     # add a column with string NON-ROAD
  
  bm_type <- bind_rows(bm_nonroad, bm_nonpoint, bm_onroad, bm_point ) # row bind the data
  bm_type <- rename(bm_type, Total_Emissions = V1)                    # rename column

# plot data
  install.packages("ggplot2"); library(ggplot2)
    # qplot(year, Total_Emissions, data=bm_type, facets=.~type, geom = c("point", "smooth", "bar"), method="lm")
    png("plot3.png", width=720, height=720, units="px") # open png file
    
    g <- ggplot( bm_type, aes(year, Total_Emissions, fill=factor(type))) # fill declaration give colors to types
    g + geom_point() + geom_smooth(method="lm", fill="white") + facet_grid(.~type) + 
      geom_bar(stat="identity") + theme(legend.position="none") + 
      labs(title = "Emission levls in Baltimore City (1999 to 2008)") +
      coord_cartesian(xlim=c(1996,2011))
    
    dev.off()   # close png filedevice
    