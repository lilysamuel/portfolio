---
title: 'Math 208: Analysis of Heart Disease'
author: "Lily Samuel"
date: "2021-11-07"
output:
  pdf_document: default
  html_document: default
---
```{r}
library(languageserver)
library(readr)
library(ggplot2)
library(tidyverse)
library(gridExtra)

heart <- read_csv("/Users/lilysamuel/Desktop/heart 2.csv")
head(heart)
```

Task 1:
Assess whether there is an association between the sex of the patient
and their resting heart rates, i.e. is there a difference in distribution 
of the resting heart rates across the sexes?

Solution:
```{r}
ggplot(heart, aes(x=RestingBP, group=Sex,fill= Sex)) + geom_histogram(bins=20,col="black") + facet_wrap(~Sex)+ labs(x="Resting BP",y="Number of Patients",title="Association between sex and resting heart rate")

ggplot(heart, aes(x=Sex, y=RestingBP, fill=Sex)) + geom_boxplot()
```
The distribution of Resting BP between male and female is very similar, which is
an indication that there is no association between the sexes and Resting BP

Task 2: 
Produce a stacked barplot showing the distribution of Chest Pain Type for each level of RestingECG

Solution:
```{r}
ggplot(heart,aes(x=RestingECG,fill=ChestPainType)) + geom_bar() + labs(x="Resting ECG",y="Count",title="distribution of Chest Pain Type for each level of Resting ECG", fill="Chest Pain Type")

ggplot(heart %>% count(ChestPainType,RestingECG) %>%
    group_by(RestingECG) %>%
    reframe(ChestPainType=ChestPainType,prop=n/sum(n)),
  aes(y=prop,x=RestingECG,fill=ChestPainType)) +
geom_bar(stat="identity")
```
Task 3:
Produce a summary table containing counts and proportions of RestingECG category for each
sex/ChestPainType factor combination.

Solution:
```{r}
summary_table<-heart%>%mutate(ChestPainTypelmp=fct_explicit_na(ChestPainType))%>%group_by(Sex, ChestPainTypelmp, RestingECG)%>%count() %>% group_by(RestingECG) %>% mutate(prop = n/sum(n))
summary_table%>% slice(sample(1:nrow(.), 15))
```
Task 4:  
Create a summary table that finds the mean, median and IQR of RestingBP, Cholesterol, FastingBS, and
MaxHR for each of the Chest Pain Types and report those results in a tibble where the columns are the
levels of Chest Pain Types and the summary statistics are in the rows.

Solution:
```{r}
heart %>% group_by(ChestPainType) %>% summarise_at(vars(RestingBP,Cholesterol,FastingBS,MaxHR),list(mean=mean, median=median, IQR=IQR)) %>% pivot_longer(cols=c(ends_with("mean"),ends_with("median"),ends_with("IQR")), names_to="Var_Statistic")%>%pivot_wider(id_cols="Var_Statistic",names_from="ChestPainType")
```

Task 5:
Using plots, explain which of the following measurements seem most strongly
associated with Heart Disease (heart disease vs. normal) : RestingBP, Cholesterol, 
FastingBS, and MaxHR.

```{r}
quant_data<-heart %>%
 select(HeartDisease,RestingBP,Cholesterol,MaxHR) %>%
 pivot_longer(cols=RestingBP:MaxHR,values_to="Value") %>%
 mutate(HeartDisease=ifelse(HeartDisease==1,"Yes","No"))
head(quant_data)

ggplot(quant_data, aes(x=HeartDisease,y=Value,fill=HeartDisease,group=HeartDisease)) + geom_boxplot() + facet_wrap(~name,scales="free")

ggplot(quant_data, aes(x=Value,fill=HeartDisease,group=HeartDisease)) + geom_histogram(aes(y=..density..)) + facet_grid(HeartDisease~name,scales="free")
```

Based on the boxplot and bar graph above, the maximum heart rate is more strongly associated with heart disease that the other quantitative variables. This is evident as we can see the heart disease group has lower heart rates than the other group of those without heart disease. The distributions of the other two variables seem quite similar

```{r}
catergorical_data<-ggplot(heart %>%
        mutate(FastingBS=ifelse(FastingBS==1,"Yes","No"),
               HeartDisease=ifelse(HeartDisease==1,"Yes","No")) %>%
        count(HeartDisease,FastingBS) %>%
        group_by(HeartDisease) %>%
        reframe(FastingBS=FastingBS,prop=n/sum(n)),
    aes(y=prop,x=HeartDisease,fill=FastingBS)) +
geom_bar(stat="identity")

catergorical_data
```

Heart Disease has a larger percentage of patients whose blood sugars were
measured after fasting.

Task 6:
Create both a 2-d histogram and a 2-d contour plot to assess the association between RestingBP and
MaxHR. Describe this association and also explain which plot you think shows the association most
clearly (or explain why they are about the same).

Solution:
```{r}
ggplot(heart, aes(x=RestingBP,y=MaxHR)) + geom_density_2d()+ geom_point(alpha=0.5)+ ggtitle("2D contour plot")+theme(legend.position = "none")
ggplot(heart, aes(x=RestingBP,y=MaxHR)) + geom_bin2d() + ggtitle("2D histogram")
```

Task 7:
Determine whether the association between RestingBP and
MaxHR depends on either the Chest Pain Type or the Heart Disease status (or both)

Solution

```{r}
ggplot(heart, aes(x=RestingBP,y=MaxHR)) + geom_density2d()+geom_point(alpha=0.5,aes(col=ChestPainType))+facet_grid(~HeartDisease)+ggtitle("2d Contour Plot for Heart Disease") + theme(legend.position="none")

ggplot(heart, aes(x=RestingBP,y=MaxHR)) + geom_density2d()+geom_point(alpha=0.5,aes(col=ChestPainType))+facet_grid(~ChestPainType)+ggtitle("2d Contour Plot for Chest Pain Type") + theme(legend.position="none")
```

Based on these figures, it seems like the association does depend on these two variables and
their interaction.


