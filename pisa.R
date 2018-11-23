pisaTrain<-read.csv("pisa2009train.csv")
pisaTest<-read.csv("pisa2009test.csv")
nrow(pisaTrain)
str(pisaTrain)
tapply(pisaTrain$readingScore,pisaTrain$male,mean)

summary(pisaTrain)
pisaTrain<-na.omit(pisaTrain)
pisaTest<-na.omit(pisaTest)
nrow(pisaTest)


pisaTrain$raceeth = relevel(pisaTrain$raceeth, "White")

pisaTest$raceeth = relevel(pisaTest$raceeth, "White")

lmScore<-lm(readingScore~.,data=pisaTrain)
summary(lmScore)

train_pred<-predict(lmScore)

SSE<-sum((pisaTrain$readingScore-train_pred)^2)

rmse<-sqrt(SSE/nrow(pisaTrain)
summary(lmScore)

pred_test<-predict(lmScore,newdata=pisaTest)
max(pred_test)-min(pred_test)

sse1<-sum((pred_test-pisaTest$readingScore)^2)

sqrt(sse1/nrow(pisaTest))

m<-mean(pisaTrain$readingScore)
sst<-sum((pisaTest$readingScore-m)^2)