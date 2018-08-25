
#This I replicated from kaggle to get hands on!!!
library('ggplot2') # visualization
library('ggthemes') # visualization
library('scales') # visualization
library('dplyr') # data manipulation
library('mice') # imputation
library('randomForest') # classification algorithm
train<-read.csv("train.csv",stringsAsFactors=F)
test<-read.csv("test.csv",stringsAsFactors=F)
full<-bind_rows(train,test)
str(full$Name)
full$Title <- gsub('(.*, )|(\\..*)', '', full$Name)
table(full$Sex, full$Title)
rare_title <- c('Dona', 'Lady', 'the Countess','Capt', 'Col', 'Don', 
                'Dr', 'Major', 'Rev', 'Sir', 'Jonkheer')
full$Title[full$Title=='Mlle']='Miss'
full$Title[full$Title == 'Ms']          <- 'Miss'
full$Title[full$Title == 'Mme']         <- 'Mrs'
full$Title[full$Title %in% rare_title]='Rare title'
table(full$Title)

table(full$Sex, full$Title)
table(full$Surname)<-sapply(full$Name,function(x)strsplit(x,split='[,.]')[[1]][1])
group_by(full,Surname)
unique(full$Surname)
str(full)
creating family size
full$Fsize<-full$SibSp+full$Parch+1
full$Family <- paste(full$Surname, full$Fsize, sep='_')
nrow(train)
ggplot(full[1:891,],aes(x=Fsize,fill=factor(Survived)))+geom_bar(stat="count",position="dodge")
full$FsizeD[full$Fsize==1]<-'singleton'
full$FsizeD[full$Fsize < 5 & full$Fsize > 1] <- 'small'
full$FsizeD[full$Fsize > 4] <- 'large'

mosaicplot(table(full$FsizeD, full$Survived), main='Family Size by Survival', shade=TRUE)
table(full$FsizeD, full$Survived)

full$Cabin[1:28]

strsplit(full$Cabin, NULL)[[1]]
full$Deck<-factor(sapply(full$Cabin, function(x) strsplit(x, NULL)[[1]][1]))
sum(full$Embarked=="")
full[c(62, 830), 'Embarked']
embark_fare<-full %>% filter(PassengerId != 62 & PassengerId != 830)

ggplot(embark_fare,aes(x=Embarked,y=Fare,fill=factor(Pclass)))+geom_boxplot()+geom_hline(aes(yintercept=80), 
    colour='red', linetype='dashed', lwd=2) +
  scale_y_continuous(labels=dollar_format()) +
  theme_few()
full$Embarked[c(62, 830)] <- 'C'
full$Embarked[c(62, 830)] <- 'C'
full[1044, ]
full$Fare[1044] <- median(full[full$Pclass == '3' & full$Embarked == 'S', ]$Fare, na.rm = TRUE)
sum(is.na(full$Age))
full$Fare[1044] <- median(full[full$Pclass == '3' & full$Embarked == 'S', ]$Fare, na.rm = TRUE)

factor_vars <- c('PassengerId','Pclass','Sex','Embarked',
                 'Title','Surname','Family','FsizeD')
full[factor_vars] <- lapply(full[factor_vars], function(x) as.factor(x))
set.seed(129)
mice_mod<-mice(full[, !names(full) %in% c('PassengerId','Name','Ticket','Cabin','Family','Surname','Survived')], method='rf')

mice_complete<-complete(mice_mod)
par(mfrow=c(1,2))

par(mfrow=c(1,2))
hist(full$Age, freq=F, main='Age: Original Data', 
  col='darkgreen', ylim=c(0,0.04))
hist(mice_complete$Age, freq=F, main='Age: MICE Output', 
  col='lightgreen', ylim=c(0,0.04))
full$Age <- mice_complete$Age

ggplot(full[1:891,], aes(Age, fill = factor(Survived))) + 
  geom_histogram() +facet_grid(.~Sex) + 
  theme_few()

ggplot(full[1:891,],aes(Age,fill=factor(Survived)))+geom_histogram()+facet_grid(Sex~.)

full$Child[full$Age < 18] <- 'Child'
full$Child[full$Age >= 18] <- 'Adult'
table(full$Child, full$Survived)

full$Mother <- 'Not Mother'
full$Mother[full$Sex == 'female' & full$Parch > 0 & full$Age > 18 & full$Title != 'Miss'] <- 'Mother'
full$Child  <- factor(full$Child)
full$Mother <- factor(full$Mother)
str(train)

train <- full[1:891,]
test <- full[892:1309,]
set.seed(754)
rf_model <- randomForest(factor(Survived) ~ Pclass + Sex + Age + SibSp + Parch + 
                                            Fare + Embarked + Title + 
                                            FsizeD + Child + Mother,
                                            data = train)
plot(rf_model, ylim=c(0,0.36))
