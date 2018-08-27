stevens<-read.csv("stevens.csv")
str(stevens)
library(caTools)
set.seed(3000)spl=sample.split(stevens$Reverse,SplitRatio=0.7)
train=subset(stevens,spl==T)
test=subset(stevens,spl==F)
library(rpart)

library(rpart.plot)

StevensTree<-rpart(Reverse~Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data = train, method="class",minbucket=25)
prp(StevensTree)
PredictCART<-predict(StevensTree,newdata=test,type="class")

table(test$Reverse,PredictCART)

#ROC curve
library(ROCR)
PredictROC<-predict(StevensTree,newdata=test)

pred = prediction(PredictROC[,2], Test$Reverse)
perf = performance(pred, "tpr", "fpr")
plot(perf)


library(caret)
library(e1071)

numFolds=trainControl(method="cv",number=10)
cpGrid=expand.grid(.cp=seq(0.01,0.5,0.01))
train(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst,data=train,trControl=numFolds,tuneGrid=cpGrid,method="rpart")
StevensTreeCV = rpart(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data = train, method="class", cp = 0.07)
PredictCV = predict(StevensTreeCV, newdata = test, type = "class")
table(test$Reverse, PredictCV)
(59+64)/(59+18+29+64)




