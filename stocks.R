stocks<-read.csv("StocksCluster.csv")
str(stocks)
table(stocks$PositiveDec)
6324/nrow(stocks)
max(cor(stocks[,1:11]))

library(caTools)

set.seed(144)

spl = sample.split(stocks$PositiveDec, SplitRatio = 0.7)

stocksTrain = subset(stocks, spl == TRUE)

stocksTest = subset(stocks, spl == FALSE)

mod1<-glm(PositiveDec~.,data=stocksTrain,family='binomial')

mod1_pred<-predict(mod1,newdata=stocksTest,type='response')
table(stocksTest$PositiveDec,mod1_pred>0.5)
(417+1553)/nrow(stocksTest)


limitedTrain = stocksTrain

limitedTrain$PositiveDec = NULL

limitedTest = stocksTest

limitedTest$PositiveDec = NULL

library(caret)
install.packages('flexclust', dependencies=TRUE, repos='http://cran.rstudio.com/')

library(caret)

preproc = preProcess(limitedTrain)

normTrain = predict(preproc, limitedTrain)

normTest = predict(preproc, limitedTest)
set.seed(144)
km=kmeans(normTrain,centers=3)
table(km$cluster)

library(flexclust)

km.kcca<-as.kcca(km,normTrain)
clusterTrain=predict(km.kcca)
table(clusterTrain)

clusterTest = predict(km.kcca, newdata=normTest)
table(clusterTest)