trails<-read.csv("clinical_trial.csv",stringsAsFactors=F)
str(trails)
max(nchar(trails$abstract))
sum(is.na(trails$abstract))
sum(nchar(trails$abstract)==0)
trails$title[which.min(nchar(trails$title))]
library(tm)
library(SnowballC)
corpusTitle<-Corpus(VectorSource(trails$title))
corpusAbstract<-Corpus(VectorSource(trails$abstract))

corpusTitle<-tm_map(corpusTitle,tolower)
corpusAbstract<-tm_map(corpusAbstract,tolower)

corpusTitle<-tm_map(corpusTitle,removePunctuation)
corpusAbstract<-tm_map(corpusAbstract,removePunctuation)

corpusTitle<-tm_map(corpusTitle,removeWords,stopwords("english"))
corpusAbstract<-tm_map(corpusAbstract,removeWords,stopwords("english"))

corpusTitle<-tm_map(corpusTitle,stemDocument)
corpusAbstract<-tm_map(corpusAbstract,stemDocument)

dtmTitle<-DocumentTermMatrix(corpusTitle)
dtmAbstract<-DocumentTermMatrix(corpusAbstract)

dtmTitle<-removeSparseTerms(dtmTitle,0.95)
dtmAbstract<-removeSparseTerms(dtmAbstract,0.95)
dtmTitle<-as.data.frame(as.matrix(dtmTitle))
dtmAbstract<-as.data.frame(as.matrix(dtmAbstract))
ncol(dtmAbstract)
which.max(colSums(dtmAbstract))
colnames(dtmAbstract[[335]])


colnames(dtmTitle) = paste0("T", colnames(dtmTitle))

colnames(dtmAbstract) = paste0("A", colnames(dtmAbstract))

dtm = cbind(dtmTitle, dtmAbstract)
ncol(dtm)
dtm$trial = trails$trial
set.seed(144)
library(caTools)
spl=sample.split(dtm$trial,SplitRatio=0.7)
train<-subset(dtm,spl==T)
test<-subset(dtm,spl==F)

table(train$trial)
730/(730+572)

library(rpart)
library(rpart.plot)
trialCART<-rpart(trial~.,data=train,method="class")
prp(trialCART)

predTrain = predict(trialCART)[,2]

summary(predTrain)
