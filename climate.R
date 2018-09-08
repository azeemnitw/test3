climate<-read.csv("climate_change.csv")
str(climate)
climate1<-subset(climate,Year<=2006) str(climate1)
model1<-lm(Temp~MEI+CO2+CH4+N2O+CFC.11+CFC.12+TSI+Aerosols,data=climate1)
summary(model1)
cor(climate1)
model2<-lm(Temp~MEI+TSI+N2O+Aerosols,data=climate1)
summary(model2)
model3<-step(model1)
summary(model3)
climate2<-subset(climate,Year>2006)
str(climate2)
 predict_test<-predict(model3,newdata=climate2)
str(climate2)

SSE_test<-sum((climate2$Temp-predict_test)^2)
SST_test<-sum((mean(climate1$Temp,na.rm=TRUE)-climate2$temp)^2)
r2=1-SSE_test/SST_test

SSE = sum((predict_test - climate2$Temp)^2)

SST = sum( (mean(climate1$Temp) - climate2$Temp)^2)

R2 = 1 - SSE/SST