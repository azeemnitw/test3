library(dplyr) # Data manipulation
library(ggplot2) # Data visualization
library(viridis) # Colors
library(lubridate) # Dates
#library(scales) # Scales

crimes<-read.csv("crimes.csv",h=T,stringsAsFactors=F)
nrow(crimes)
str(crimes)
factor_vars<-c("Offense", "Description", "Neighborhood")
crimes[factor_vars]<-lapply(crimes[factor_vars],function(x)factor(x))
top_crimes <- names(sort(table(crimes$Description), decreasing = T)[1:10])

names(sort(table(crimes$Description), decreasing = T)[1:10])
crimes$Time[1:10]
x<-"13:22:00"
strsplit(x,split=":")[[1]][1]
substr(x,1,2)

str(crimes)
crimes$Hour <- factor(substr(crimes$Time, 1, 2))
hourly_crimes<-crimes%>%filter(Description %in% top_crimes,Hour!="")%>%group_by(Description,Hour)%>%summarise(count=n())
ggplot(hourly_crimes,aes(x=Hour,y=reorder(Description,count),fill=count))+geom_tile()


ggplot(hourly_crimes, aes(x = Hour, y = reorder(Description, count),
        fill = count)) + 
    geom_tile() +
    scale_fill_viridis(name = "Number of Reports") +
    labs(y = "Crime Description",
       x = "Hour of Report",
       title = "Number of Reported Crimes during the Day by Type")

p<-"helo"
grepl("h",p)


