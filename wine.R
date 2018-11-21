library(tidyverse)
library(corrplot)
library(gridExtra)
library(GGally)

install.packages('GGally', dependencies=TRUE, repos='http://cran.rstudio.com/')
wine<-read.csv("Wine.csv")
head(wine)
str(wines)
wine %>%
  gather(Attributes, value, 1:13) %>%
  ggplot(aes(x=value)) +
  geom_histogram(fill="lightblue2", colour="black") +
  facet_wrap(~Attributes, scales="free_x") +
  labs(x="Values", y="Frequency")

wine %>%
  gather(Attributes, value, 1:13)%>%ggplot(aes(x=value))+geom_histogram(fill="lightblue2", colour="black")+facet_wrap(~Attributes,scales="free_x")

corrplot(cor(wine),type='upper')

ggplot(wines,aes(x=Total_Phenols, y=Flavanoids))+geom_point()+geom_smooth(method='lm',se=F)