library(ggplot2)
library(ggthemes)
library(dplyr)
library(lubridate)
library(rpart)
library(randomForest)
str(train)

train<-read.csv("train.csv",stringsAsFactors=F)
test<-read.csv("test.csv",stringsAsFactors=F)
str(train)
names(train)[[1]]<-'ID'
str(test)
test$ID<-as.character(test$ID)
full<-bind_rows(train,test)

outcomes<-full[1:26729,]%>%group_by(AnimalType,OutcomeType)%>%summarise(num_animals=n())

ggplot(outcomes,aes(x=AnimalType,y=num_animals,fill=OutcomeType))+geom_bar(stat='identity',position='fill',color='black')+coord_flip()

factor(full$AgeuponOutcome)[1:10]
table(full$AnimalType,full$OutcomeType)
full$AgeuponOutcome[1:6]

full$TimeValue <- sapply(full$AgeuponOutcome,  
                      function(x) strsplit(x, split = ' ')[[1]][1])

full$UnitofTime <- sapply(full$AgeuponOutcome,  
                      function(x) strsplit(x, split = ' ')[[1]][2])

full$UnitofTime<-gsub('s','',full$UnitofTime)

full$TimeValue<-as.numeric(full$TimeValue)
full$UnitofTime <- as.factor(full$UnitofTime)

multiplier<-ifelse(full$UnitofTime == 'day',1,ifelse(full$UnitofTime=='week',7,ifelse(full$UnitofTime=='month',30,ifelse(full$UnitofTime=='year',365,NA))))

full$AgeinDays<-full$TimeValue * multiplier
full$Name<-ifelse(nchar(full$Name)==0, 'Nameless', full$Name)

full$HasName[full$Name=='Nameless']=0
full$HasName[full$Name!='Nameless']=1

full$SexuponOutcome <- ifelse(nchar(full$SexuponOutcome)==0, 
                              'Spayed Female', full$SexuponOutcome)	

full$DateTime[1:10]

full$Hour    <- hour(full$DateTime)
full$Weekday <- wday(full$DateTime)
full$Month   <- month(full$DateTime)
full$Year    <- year(full$DateTime)

full$TimeofDay <- ifelse(full$Hour > 5 & full$Hour < 11, 'morning',
                  ifelse(full$Hour > 10 & full$Hour < 16, 'midday',
                  ifelse(full$Hour > 15 & full$Hour < 20, 'lateday', 'night')))

full$TimeofDay <- factor(full$TimeofDay, 
                    levels = c('morning', 'midday',
                               'lateday', 'night'))


daytimes<-full[1:26729,]%>%group_by(AnimalType, TimeofDay, OutcomeType)%>% summarise(num_animals=n())

ggplot(daytimes,aes(x=TimeofDay,y=num_animals,fill=OutcomeType))+geom_bar(stat='identity',position='fill',color='black')+coord_flip()+facet_wrap(~AnimalType)


full$IsMix<-ifelse(grepl('Mix',full$Breed),1,0)

full$SimpleBreed <- sapply(full$Breed, 
                      function(x) gsub(' Mix', '', 
                        strsplit(x, split = '/')[[1]][1]))

full$SimpleColor <- sapply(full$Color, 
                      function(x) strsplit(x, split = '/| ')[[1]][1])
levels(factor(full$SimpleColor))

full$Intact <- ifelse(grepl('Intact', full$SexuponOutcome), 1,
               ifelse(grepl('Unknown', full$SexuponOutcome), 'Unknown', 0))

full$Sex<-ifelse(grepl('Male',full$SexuponOutcome),'Male',ifelse(grepl('Unknown',full$Sex),'Unknown','Female'))

intact<-full[1:26729,]%>%group_by(AnimalType,Intact,OutcomeType)%>%summarise(num_animals=n())

ggplot(intact,aes(x=Intact,y=num_animals,fill=OutcomeType))+geom_bar(stat='identity',position='fill',color='black')+facet_wrap(~AnimalType)+coord_flip()

age_fit<-rpart(AgeinDays ~ AnimalType + Sex + Intact + SimpleBreed + HasName,data=full[!is.na(full$AgeinDays),],method='anova')

full$AgeinDays[is.na(full$AgeinDays)]<-predict(age_fit,newdata=full[is.na(full$AgeinDays),])

sum(is.na(full$AgeinDays))

full$Lifestage[full$AgeinDays < 365] <- 'baby'
full$Lifestage[full$AgeinDays >= 365] <- 'adult'

full$Lifestage <- factor(full$Lifestage)

ggplot(full[1:26729, ], aes(x = Lifestage, fill = OutcomeType)) + 
  geom_bar(position = 'fill', colour = 'black') +
  labs(y = 'Proportion', title = 'Animal Outcome: Babies versus Adults') +
  theme_few()

factorVars <- c('Name','OutcomeType','OutcomeSubtype','AnimalType',
                'SexuponOutcome','AgeuponOutcome','SimpleBreed','SimpleColor',
                'HasName','IsMix','Intact','Sex','TimeofDay','Lifestage')

full[factorVars] <- lapply(full[factorVars], function(x) as.factor(x))

train <- full[1:26729, ]
test  <- full[26730:nrow(full), ]
set.seed(731)

rf_mod <- randomForest(OutcomeType ~ AnimalType+AgeinDays+Intact+HasName+Hour+Weekday+TimeofDay+SimpleColor+IsMix+Sex+Month, 
  data = train, 
  ntree = 600, 
  importance = TRUE)


plot(rf_mod, ylim=c(0,1))
legend('topright', colnames(rf_mod$err.rate), col=1:6, fill=1:6)

prediction <- predict(rf_mod, test, type = 'vote')
solution<-data.frame('ID'=test$ID,prediction)

write.csv(solution, 'rf_solution.csv', row.names = F)