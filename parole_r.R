parole<-read.csv("parole.csv")
str(parole)
sum(parole$violator)

parole$state = as.factor(parole$state)

parole$crime = as.factor(parole$crime)

summary(parole$crime)
summary(parole$state)

set.seed(144)
library(caTools)
split<-sample.split(parole$violator,SplitRatio=0.7)
train<-subset(parole,split==TRUE)
test<-subset(parole,split==F)
model1<-glm(violator~.,data=train,family=binomial)
summary(model1)

pred_mod1<-predict(model1,newdata=test,type="response")
summary(pred_mod1)

table(test$violator,pred_mod1>=0.5)

12/(12+11)
167/(167+12)
(167+12)/(167+35)
(175+4)/(175+27)

table(test$violator)
179/(202)
library(ROCR)

ROCR_pred<-prediction(pred_mod1,test$violator)
as.numeric(performance(ROCR_pred,"auc")@y.values)