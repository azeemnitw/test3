library(dplyr) # Data manipulation
library(ggplot2) # Data visualization
library(viridis) # Colors
library(lubridate) # Dates
library(scales) # Scales
crimes<-read.csv("crimes1.csv", h=T, stringsAsFactors=F)
str(crimes)

factor_vars <- c("Offense", "Description", "Neighborhood")
crimes[factor_vars]<-lapply(crimes[factor_vars],function(x)factor(x))
top_crimes<-names(sort(table(crimes$Description),decreasing=T)[1:10])
crimes$Hour=factor(substr(crimes$Time,1,2))

hourly_crimes<-crimes%>%filter(Description %in% top_crimes,Hour!="")%>%group_by(Description,Hour)%>%summarise(count=n())
crimes%>%filter(Description %in% top_crimes,Hour!="")%>%group_by(Description,Hour)%>%summarise(count=n())

names(crimes)

ggplot(hourly_crimes, aes(x = Hour, y = reorder(Description, count),
        fill = count)) + 
    geom_tile() +
    scale_fill_viridis(name = "Number of Reports") +
    labs(y = "Crime Description",
       x = "Hour of Report",
       title = "Number of Reported Crimes during the Day by Type")
