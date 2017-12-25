dataSQL<-function(sQuer){
  library(RODBC)
  channel <- odbcDriverConnect(connection = "Driver=SQL Server;Server=SERVERMy;database=BDMy;Uid=XXXXX;Pwd=XXXXX")
  retVal<-sqlQuery(channel,sQuer)
  retVal
}

getDictionary<-function(){
  ft <-dataSQL("select ID, [WordString]  from [dbo].[dictionaryWRD]")
  ft
}

getDataReal<-function(){
  ft <-dataSQL("select KeyObj, PropertyArr  from [dbo].[tblProperty] order by KeyObj")
  ft
}

getDataTest<-function(){
  ft <-dataSQL("select [numWD] KeyObj, TextOrder, [PropertyArr], BrandLineKey, Probability, [fileName] fileUID, koeff  from [dbo].[tblTestSelection] where len([PropertyArr])>0 and [fileName]='+ char(39) + ltrim(rtrim(@FileName)) + char(39) + '")
  ft
}

