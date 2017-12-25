setwd("C:/LearnModel");
source("utilityString.R")
source("utilityData.R", encoding = 'UTF-8')

library(RODBC)
library(nnet)


myProduction<-getDictionary();

num_wrd<-max(myProduction$ID);
dt<-getDataTest();
if(nrow(dt)>0){
  X<-t(apply(as.matrix(dt$PropertyArr, 1, num_wrd), 1, functionProperty2VectorW2V, arrLen=num_wrd));
  X<-data.frame(X);
  
  
  MyBrand<-as.matrix(read.csv("brand.csv", sep=",", as.is=TRUE, skip=0, header=TRUE));
  
  MyNet<- readRDS("NNProduction.rds")
  reslt <- predict(MyNet, newdata = X)
  
  #add brand data
  MyNetBrand<- readRDS("NNBrand.rds")
  resltBrand <- predict(MyNetBrand, newdata = X)
  
  brandIndex<-apply(resltBrand, 1, function(strMy){which(strMy==max(strMy))})
  
  for(i in 1:length(brandIndex))
  {
    numBrand<-brandIndex[i];
    reslt[i, ]<- reslt[i, ] + MyBrand[numBrand,]
  }	
  
  
  predictIndex<-apply(reslt, 1, function(strMy){which(strMy==max(strMy))})
  predictValue<-apply(reslt, 1, max);
  
  nd<-data.frame(numWD=dt$KeyObj, TextOrder=dt$TextOrder, PropertyArr=dt$PropertyArr, BrandLineKey=predictIndex, Probability=predictValue*dt$koeff, fileName=dt$fileUID);
  
  channel <- odbcDriverConnect(connection = "Driver=SQL Server;Server=SERVERMy;database=BDMy;Uid=XXXXX;Pwd=XXXXX")
  sqlUpdate(channel, nd, tablename = "tblTestSelection", index=c("numWD", "fileName"), verbose=TRUE)
  odbcClose(channel)
}