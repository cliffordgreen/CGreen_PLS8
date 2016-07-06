clickfile <- "http://stat.columbia.edu/~rachel/datasets/nyt1.csv"
clickdata <- read.csv(url(clickfile))

clickdata$Age_Group <- cut(clickdata$Age, c(-Inf, 18, 24, 34, 44, 54, 64, Inf))
ImpSub <- subset(clickdata, Impressions>0)
ImpSub$CTR <- ImpSub$Clicks/ImpSub$Impressions 
library(ggplot2) # used for visualizations
ggplot(subset(ImpSub, Impressions>0), aes(x=Impressions, fill=Age_Group))+
  labs(title="Impressions vs. Age_Group")+
  geom_histogram(binwidth=1)

ggplot(subset(ImpSub, CTR>0), aes(x=CTR, fill=Age_Group))+
  labs(title="CTR vs. Age_Group")+
  geom_histogram(binwidth=.025)

ImpSub$sortCTR <- cut(ImpSub$CTR, c(-Inf, .2, .4, .6, .8, Inf))
library(dplyr)
library(doBy)

summaryBy(Gender+Signed_In+Impressions+Clicks~SortCTR, data = ImpSub)
NewImp <- filter(ImpSub, Gender == 1 & Impressions > 0 & Clicks > 0 & Signed_In > 0 )

length(NewImp$Gender)

byAge <- group_by(ImpSub, Age_Group)
summarise(byAge, averageImp = mean(Impressions),averageClick = mean(Clicks),averageMale = mean(Gender), averageCTR = mean(CTR))

tableCTRvAge <- table(ImpSub$Age_Group, ImpSub$CTR)
View(tableCTRvAge)

ggplot(subset(ImpSub, CTR>0), aes(x=CTR, fill=Age_Group))+
  labs(title="Click-through rate by age group")+
  geom_histogram(binwidth=.025)

ggplot(subset(ImpSub, CTR>0), )+
  labs(title="CTRvAge")+
  geom_point(aes(x=CTR, y=Age, color = Gender))
