elantra<-read.csv("elantra.csv")
str(elantra)
elantra_train<-subset(elantra,Year<=2012)
nrow(elantra_train)
elantra_test<-subset(elantra,Year>2012)
mod<-lm(ElantraSales~.,data=elantra_train)
summary(mod)
mod1<-lm(ElantraSales~Unemployment+Queries+CPI_energy+CPI_all,data=elantra_train)
summary(mod1)

mod2<-lm(ElantraSales~Month+Unemployment+Queries+CPI_energy+CPI_all,data=elantra_train)
summary(mod2)

predict_test<-predict(mod2,newdata=elantra_test)
str(elantra$Month)

mod3<-lm(ElantraSales~as.factor(Month)+Unemployment+Queries+CPI_energy+CPI_all,data=elantra_train)
summary(mod3)

elantra_train$MonthFactor = as.factor(elantra_train$Month)

elantra_test$MonthFactor = as.factor(elantra_test$Month)

cor(elantra_train$CPI_energy,elantra_train$Month)

cor(elantra_train[c("Unemployment","Month","Queries","CPI_energy","CPI_all")])
mod4<-lm(ElantraSales~as.factor(Month)+Unemployment+CPI_energy+CPI_all,data=elantra_train)
summary(mod4)
mod5<-lm(ElantraSales~as.factor(Month)+Unemployment+CPI_all,data=elantra_train)
summary(mod5)
mod6<-lm(ElantraSales~as.factor(Month)+Unemployment,data=elantra_train)
summary(mod6)


predict_elantra<-predict(mod4,newdata=elantra_test)
str(elantra_test)

SSE_test<-sum((predict_elantra-elantra_test$ElantraSales)^2)
p=mean(elantra_train$ElantraSales)
SST_test<-sum((mean(elantra_train$ElantraSales)-elantra_test$ElantraSales)^2)

r2<-1-(SSE_test/SST_test)

max(abs(predict_elantra-elantra_test$ElantraSales))