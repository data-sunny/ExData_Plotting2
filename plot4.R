# plot4.R
# read data
  nei <- readRDS("summarySCC_PM25.rds")
  scc <- readRDS("Source_Classification_Code.rds")

# extract Indexes matching string from scc data file
  # create search string and identify rows
    search <- "([Cc]omb|[Cc]ombustion)+(.*)[Cc]oal"
    coal_rows <- grep( search, scc$EI.Sector ) # ; dim(coal_rows); length(coal_rows); coal_rows

  # subset scc file data for rows containing strings coal/comb/combustion
    coal_ndx <- scc[ coal_rows , ] # ;class(coal_ndx); dim(coal_ndx); str(coal_ndx)
    ndx <- subset(coal_ndx, select = SCC) # subset 1st column containing SCC ids #; class(ndx); dim(c32); str(ndx)

# subset nei file data per coal/comb/combustion contaning i"ndx"s from scc files
  coal_src <- subset( nei, nei$SCC%in%ndx$SCC) # ; class(coal_src); dim(coal_src); str(coal_src)
  
  install.packages("dplyr"); library(dplyr)
  coal_src1 <- arrange(coal_src, year, type) # this was done to make a stacked histogram
  coal_src1 <- rename(coal_src1, Total_Emissions = Emissions, Year = year)  # rename column
  
# plot data - emissions summed for each individual year without "type" faceting
  install.packages("ggplot2"); library(ggplot2)
  
  png("plot4.png", width=720, height=720, units="px") # open png file
  g <- ggplot( coal_src1, aes(Year, Total_Emissions, fill=factor(type) ) ) # fill declaration give colors to types
  g + geom_bar(stat="identity")  + coord_cartesian(xlim=c(1996,2011)) + theme(legend.title=element_blank()) +
    labs(title = "Emission from coal combustion-related sources (1999 to 2008) across United States")
  dev.off()   # close png filedevice      
  
  
  # plot a simple histogram
    # Year <- c(1999, 2002, 2005, 2008)
    # Total_Emissions <- tapply( coal_src$Emissions,coal_src$year, sum)
    # plot(Year, Total_Emissions)
    # barplot(Total_Emissions, xlab="Year", ylab = "Emissions",
      # main = "Total Emissions from coal combustion-related sources")
  