library(ggplot2)
ggplot(mtcars,aes(x=cyl,fill=factor(gear)))+geom_bar()
str(mtcars)
ggplot(data = Birth_weight,aes(x=mother_age,fill=smoke))+geom_bar()+facet_grid(. ~smoke)
ggplot(mtcars,aes(x=mpg,y=hp,col=factor(cyl)))+geom_point()+labs(size="gear",col="cyl")

options(scipen=999)  # turn off scientific notation like 1e+06
library(ggplot2)
data("midwest", package = "ggplot2")
str(midwest)

ggplot(midwest, aes(x=area, y=poptotal)) + geom_point()
ggplot(midwest, aes(x=area, y=poptotal)) + geom_point() + geom_smooth(method="lm")+coord_cartesian(xlim=c(0, 0.1),ylim=c(0, 1000000))
gg<-gg <- ggplot(midwest, aes(x=area, y=poptotal)) + 
  geom_point(aes(col=state), size=3) +  # Set color to vary based on state categories.
  geom_smooth(method="lm", col="firebrick", size=2) + 
  coord_cartesian(xlim=c(0, 0.1), ylim=c(0, 1000000)) + 
  labs(title="Area Vs Population", subtitle="From midwest dataset", y="Population", x="Area", caption="Midwest Demographics")
plot(gg+scale_x_continuous(breaks=seq(0,0.1,0.01)))