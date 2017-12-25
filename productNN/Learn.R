setwd("C:/LearnModel");
source("utilityString.R")
source("utilityData.R", encoding = 'UTF-8')

library(RODBC)
library(nnet)

dtTable<-getDataReal();  
myProduction<-getDictionary();

num_wrd<-max(myProduction$ID);
num_labels <- max(dtTable$KeyObj);

input_layer_size  <- num_wrd;

X<-data.frame(t(apply(as.matrix(dtTable$PropertyArr, 1, num_wrd), 1, functionProperty2VectorW2V, arrLen=num_wrd)));
Y<-as.matrix(dtTable$KeyObj, 1, length(dtTable$KeyObj));
trainset<-data.frame(MyClas=factor(Y), X)


model <- nnet(MyClas ~ ., data = trainset,  size=10, decay=5e-4, rang=(1/max(trainset[,-c(1)])), maxit=1000,  MaxNWts=22000)
saveRDS(model, "NNProduction.rds")