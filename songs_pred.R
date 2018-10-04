songs<-read.csv("songs.csv")
str(songs)
table(songs$year)	

sum(songs$artistname=='Michael Jackson')
subset(songs,artistname=='Michael Jackson' & Top10==1)$songtitle
songs$songtitle[which.max(songs$tempo)]

SongsTrain<-subset(songs,year<=2009)
SongsTest<-subset(songs,year==2010)
nrow(SongsTrain)

nonvars = c("year", "songtitle", "artistname", "songID", "artistID")

SongsTrain = SongsTrain[ , !(names(SongsTrain) %in% nonvars) ]

SongsTest = SongsTest[ , !(names(SongsTest) %in% nonvars) ]

model1<-glm(Top10~.,data=SongsTrain,family='binomial')
summary(model1)
cor(SongsTrain[c('loudness','energy')]

SongsLog2 = glm(Top10 ~ . - loudness, data=SongsTrain, family=binomial)
summary(SongsLog2)

SongsLog3<-glm(Top10~.-energy,data=SongsTrain,family=binomial)
summary(SongsLog3)

testPredict<-predict(SongsLog3,newdata=SongsTest,method=response)

table(SongsTest$Top10,testPredict>=0.45)

(314+7)/nrow(SongsTest)
table(SongsTest$Top10)
314/nrow(SongsTest)