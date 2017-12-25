functionProperty2VectorW2V<-function(parString, arrLen){
  indVal<-as.integer(unlist(strsplit(parString, ",")));
  
  m<-length(indVal);
  retVal = vector("numeric", length=arrLen) 
  ##set 1 in value 
  for (i in 1:m){
    nomVal<-indVal[i];
    retVal[nomVal]=1;
  }
  retVal;
}
