
There are three parts to my script as follows:

* Feature engineering
* Missing value imputation
* Prediction!

library('ggplot2') # visualization
library('ggthemes') # visualization
library('scales') # visualization
library('dplyr') # data manipulation
library('mice') # imputation
library('randomForest') # classification algorithm
getwd()
train<-read.csv("train.csv")
test<-read.csv("test.csv")
full<-bind_rows(train,test)
str(full)
?bind_rows
?
full$Title <- gsub('(.*, )|(\\..*)', '', full$Name)
table(full$Sex, full$Title)
rare_title <- c('Dona', 'Lady', 'the Countess','Capt', 'Col', 'Don', 
                'Dr', 'Major', 'Rev', 'Sir', 'Jonkheer')
str(full)
full$Title[full$Title=='Mlle']<-'Miss'
full$Title[full$Title == 'Ms']          <- 'Miss'
full$Title[full$Title == 'Mme']         <- 'Mrs' 
full$Title[full$Title %in% rare_title]  <- 'Rare Title'

full$Name
full$Surname <- sapply(full$Name,  
                      function(x) strsplit(x, split = '[,.]')[[1]][1])

p="Naughton, Miss. Hannah"

strsplit(p,split=',')

full$Fsize <- full$SibSp + full$Parch + 1

# Create a family variable 
full$Family <- paste(full$Surname, full$Fsize, sep='_')
?strsplit

ggplot(full[1:891,], aes(x = Fsize, fill = factor(Survived))) +
  geom_bar(stat='count', position='dodge') +
  scale_x_continuous(breaks=c(1:11)) +
  labs(x = 'Family Size') +
  theme_few()
str(full)
full$FsizeD[full$Fsize==1]="singleton"
full$FsizeD[full$Fsize<5 & full$Fsize>1]="small"
full$FsizeD[full$Fsize>4]="large"
str(full)

mosaicplot(table(full$FsizeD, full$Survived), main='Family Size by Survival', shade=TRUE)
full$Cabin[1:28]
strsplit(full$Cabin[2], NULL)[[1]]
full$Deck<-factor(sapply(full$Cabin, function(x) strsplit(x, NULL)[[1]][1]))
full[c(62, 830), 'Embarked']

embark_fare <- full %>%
  filter(PassengerId != 62 & PassengerId != 830)

ggplot(embark_fare, aes(x = Embarked, y = Fare, fill = factor(Pclass))) +
  geom_boxplot() +
  geom_hline(aes(yintercept=80), 
    colour='red', linetype='dashed', lwd=2) +
  scale_y_continuous(labels=dollar_format()) +
  theme_few()

full$Embarked[c(62, 830)] <- 'C'

ggplot(full[full$Pclass == '3' & full$Embarked == 'S', ], 
  aes(x = Fare)) +
  geom_density(fill = '#99d6ff', alpha=0.4) + 
  geom_vline(aes(xintercept=median(Fare, na.rm=T)),
    colour='red', linetype='dashed', lwd=1) +
  scale_x_continuous(labels=dollar_format()) +
  theme_few()
sum(is.na(full$Embarked))
str(full)
which(is.na(full$Fare))
full$Fare[1044]=median(full[full$Pclass=='3' & full$Embarked=='S',]$Fare,na.rm=T)
sum(is.na(full$Age))
sum(is.na(full$Age))
str(full)
factor_vars <- c('PassengerId','Pclass','Sex','Embarked',
                 'Title','Surname','Family','FsizeD')
full[factor_vars] <- lapply(full[factor_vars], function(x) as.factor(x))
full[factor_vars] <- lapply(full[factor_vars], function(x) as.factor(x))

set.seed(129)
mice_mod=mice(full[,!(names(full)%in% c('PassengerId','Name','Ticket','Cabin','Family','Surname','Survived'))],method='rf')
mice_mod <- mice(full[, !names(full) %in% c('PassengerId','Name','Ticket','Cabin','Family','Surname','Survived')], method='rf')
mice_output <- complete(mice_mod)

par(mfrow=c(1,2))
mice_output <- complete(mice_mod)

hist(full$Age, freq=F, main='Age: Original Data', 
  col='darkgreen', ylim=c(0,0.04))
hist(mice_output$Age, freq=F, main='Age: MICE Output', 
  col='lightgreen', ylim=c(0,0.04))

full$Age <- mice_output$Age
sum(is.na(full$Age)) 

ggplot(full[1:891,], aes(Age, fill = factor(Survived))) + 
  geom_histogram() + 
  # I include Sex since we know (a priori) it's a significant predictor
  facet_grid(.~Sex) + 
  theme_few()

full$Child[full$Age<18]='Child'
full$Child[full$Age >= 18] <- 'Adult'
table(full$Child, full$Survived)
full$Mother='Not Mother'
full$Mother[full$Sex == 'female' & full$Parch > 0 & full$Age > 18 & full$Title != 'Miss']<-'Mother'
table(full$Mother, full$Survived)

full$Child  <- factor(full$Child)
full$Mother <- factor(full$Mother)
md.pattern(full)

train <- full[1:891,]
test <- full[892:1309,]

set.seed(754)

# Build the model (note: not all possible variables are used)
rf_model <- randomForest(factor(Survived) ~ Pclass + Sex + Age + SibSp + Parch + 
                                            Fare + Embarked + Title + 
                                            FsizeD + Child + Mother,
                                            data = train)

plot(rf_model, ylim=c(0,0.36))
legend('topright', colnames(rf_model$err.rate), col=1:3, fill=1:3)
getwd()

prediction <- predict(rf_model, test)
solution <- data.frame(PassengerID = test$PassengerId, Survived = prediction)
write.csv(solution, file = 'rf_mod_Solution.csv', row.names = F)
head(full)

str(full)
full$PassengerId=NULL