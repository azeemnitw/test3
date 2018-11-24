loans<-read.csv("loans.csv")
vars.for.imputation = setdiff(names(loans), "not.fully.paid")
imputed<-complete(mice(loans[vars.for.imputation]))

loans[vars.for.imputation] = imputed

set.seed(144)
library(caTools)
split<-sample.split(loans$not.fully.paid,SplitRatio=0.7)
train<-subset(loans,split==T)
test<-subset(loans,split==F)
nrow(train)
set.seed(144)
model1<-glm(not.fully.paid~.,data=train,family='binomial')


model1_pred<-predict(model1,newdata=test,type='response')
table(test$not.fully.paid,model1_pred>0.5)

library(ROCR)

rocr_pred<-prediction(model1_pred,test$not.fully.paid)

as.numeric(performance(rocr_pred,"auc")@y.values)

(2401+3)/nrow(test)
str(test)
