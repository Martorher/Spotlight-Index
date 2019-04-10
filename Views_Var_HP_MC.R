suppressMessages(library(rvest))
suppressMessages(library(syuzhet))
suppressMessages(library(curl))
suppressMessages(library(Quandl))
suppressMessages(library(dplyr))
suppressMessages(library(quantmod))
suppressMessages(library(tidytext))
suppressMessages(library(tm))
suppressMessages(library(purrr))
suppressMessages(library(tidyr))
suppressMessages(library(PerformanceAnalytics))

suppressMessages(library(lubridate))
#El paquete lubridate nos facilita el tratamiento de fechas en R, útil entre otras cosas para preparar nuestros datos antes de un estudio de forecasting.
#Uno de los puntos fuertes de lubridate reside en formar parte de la colección de librerías tidyverse, una de las más usadas en el ámbito del Data Science

suppressMessages(library(TTR))
suppressMessages(library(zoo))
suppressMessages(library(xts))
suppressMessages(library(nortest))
suppressMessages(library(sqldf))

#Precios y Tickers
#--------------------------------------------------------------------
#Datos S&P 500
url_1<-'https://www.slickcharts.com/sp500'
datos<- url_1 %>% 
  read_html() %>% 
  html_nodes("table") %>% 
  html_table()
Price_SP500<-do.call(rbind.data.frame, datos) %>%
  select("Company","Symbol")

#Documento guardato en .txt
write.table(Price_SP500,file ='C:/Users/Usuario 1/Documents/Actuaria Facultad de Ciencias UNAM/Actuario 2019-1/Data Science (Mercado de capitales)/Data Science Capitales/Spotlight/Bases/Price_SP500.txt',sep = '\t',row.names = FALSE )

#Construcción de data frame 
#usando la paquetería quantmod se pueden obtener los precios de las acciones
#con los tickers ya obtenidos se utiliará la función getSymbols para obtener
#los precios de cada ticker de la ágina de yahoo finance algo importante a realizar
#es cambiar los '.' por '-' ya que yahoo finance reconoce el ticker 
#'BRK.B' como 'BRK-B' 

SP500_Ticker<-sub('.','-',Price_SP500$Symbol,fixed = TRUE)

#al ejecutar getSymbols se obtienen un objeto de tipo xts con las columnas
#Open, High, Low, Close, Volume, Adjust
#este for lo que realiza es obtener el xts de cada uno de los tickers
for (tk in SP500_Ticker) {
  safely(getSymbols(tk,from="2015-01-02"))
}       

#for (tk in SP500_Ticker) {
#  tk<-xts(select(Views,k),order.by = Fechas)
 # st_week<-to.period(st, period = 'weeks')
#}       


#declaración la lista donde se almacenará cada uno de los xts
all_stocks<-list()

#al usar la función getSymbols los valores son guardados en el Global ENvironment
#por lo que con ayuda del cliclo for y la función get se van almacendo en la lista
#previamente declarada
for (i in 1:length(SP500_Ticker)) {
  all_stocks[i]<-list(get(SP500_Ticker[i]))
}

#Se selecciona el precio de cierre de cada uno de los tickers con la función Cl
all_stocks <- lapply(all_stocks, Cl)

#dataframe de cada uno de los precios del ticker
stock_data<- as.matrix(Reduce("cbind", all_stocks))

#-------------------------------------------------------------------






#Matriz de posición del portafolio
#-------------------------------------------------------------------------
Views<-read.csv("C:/Users/Usuario 1/Documents/Actuaria Facultad de Ciencias UNAM/Actuario 2019-1/Data Science (Mercado de capitales)/Data Science Capitales/Spotlight/Views Python/viewSP500_1.csv", header = TRUE)
Views$Date<-as.Date(as.character(Views$Date),"%Y%m%d")     
Views<-Views[which(weekdays(Views$Date) %in% c('lunes', 'martes', 'miércoles', 'jueves', 'viernes')),]
Views<-Views[,1:101]


#Obtenemos las views de manera semanal

Fechas<-Views$Date
names<-c()
names<-names(Views)
names<-names[-1]
Aux<-matrix(rep(0,times=176), nrow = 176)

for (k in names){
k<-names[4]
st<-xts(select(Views,k),order.by = Fechas)
st_week<-to.period(st, period = 'weeks')
#Creamos la matriz en donde vamos a vacer todos los rendimientos calculados
#Seleccionamos la views mas altas durante la semana como primera propuesta
Y_t<-coredata(st_week$st.High, fmt = TRUE)
head(Y_t)
length(Y_t)
colnames(Y_t)<-k
if (k=="Views_AAPL"){
  Aux<-Y_t
}
else{
  Aux=merge(Aux,Y_t,join="inner")
  }
print(k)
}










#Metricas de Riesgo
#------------------------------------------------------------------------------------
library(quantmod)
library(data.table)



#VaR Historico

#---------------
#Recordemos que nuestra basede precios
summary(stock_data,2)


#Obtenemos los rendimientos del portafolio
Return_HP<-as.matrix(log(as.matrix(stock_data[2:nrow(stock_data),])/as.matrix(stock_data[1:(nrow(stock_data)-1),])))

#Obtenemos el valor actual de cada factor de riesgo
Xo_hp<-stock_data[nrow(stock_data),]

#Aqui va la posición por Viewsmultiplicada por Xo_hp para obtener el valor de la poscion inicial
V0_hp<-Xo_hp*"PosiciónViews"


#Obtenemoslos precios simulados 
for (i in 1:nrow(stock_data)){
  PriceSimHp<-Xo_hp%*%exp(Return_HP[i,])
  PL_ph[i,]<-PriceSimHp-VO_hp
  PL_Tot[i,]<-sum(PL_ph[i,])
  }
#-------------------------------------
#VaR
#-------------------------------------
scenario<-nrow(stock_data)
num_risk_fact<-ncol(stock_data)
for (i in (1:num_risk_fact))
{
  VaRCont[i]=quantile(PL_ph[,i],1-alpha_ph,scenario)
  CVaRCont[i]= mean(PL[which(PL_ph[,i]<VaRCont[i]),i])
}

#VaR Total
VaRTotal=quantile(PL_Tot,1-alpha,scenario)
CVaRTotal= mean(PL_Tot[which(PL_Tot<VaRTotal),])
#---------------------------------------------------







#-----------------------------------------------
#Montecarlo           #Quitar Na´s y hacer la matriz de Cholesky definido positiva#
#-----------------------------------------------



#Consideramos que al tener un inidice con empresas no solo en misma ecónomia sino en el mismo
#sector, es pertinente suponer correlación en los factores. Esto nos permitiria contemplar escenarios
#de riesgo para sectores ciclicos.

#De tal forma que utilizaremos el método de simulación montecarlo para descoposición de Cholesky.
#El objetivo a partir de este punto sera transformar "n" variables aleatorias (factores de riesgo) que forman nuestro
#portafolio en "k" cambias correlaciónados de los factores de riesgo. Y así poder simular los precios y en consecuencia el
#valor de nuestro portafolio.

#Definimos el precio actual de cada factor de riesgo
X0<-stock_data[nrow(stock_data),]

#Obtenemos los rendimientos del portafolio
Return<-as.matrix(log(as.matrix(stock_data[2:nrow(stock_data),])/as.matrix(stock_data[1:(nrow(stock_data)-1),])))
n=nrow(Return)
m=ncol(Return)


Ns=10000 #Definimos número de simulaciones
alpha=0.98 #Nivel de Confianza para las medidas de riesgo

#Obtenemos la matriz de covarianzas de los rendimientos
VarReturn=cor(Return)
#Obtenemos la matiz de Cholesky, recordando que esta es la que tescompone a la matriz de varianzas y covarianzas
CholReturn=as.matrix(chol(VarReturn))
#Definimos la matriz donde colocaremos las simulaciones
N=matrix(0,Ns,m)

#Obtenemos las simulación de los variaciones para los m factores de riesgo (emisoras)
for (i in 1:m)
{
  N[,i]=rnorm(Ns)*sqrt(VarReturn[i,i])
}

#Generamos los factores de riesgo
SimRisk<-N%*%CholReturn
#--------------------------------
#VaR
#--------------------------------


#V0=x0*pos Valor del portafolio. se tienen que definir diferentes variablespara cada uno de las semans
#y meses a los que se pretende valuar el portafo
X_ast=matrix(0,Ns,m) 
PL<-matrix(0,Ns,m) 
PLT=matrix(0,Ns,1) #TOTAL
for (i in (1:Ns))
{
  X_ast='posicion o penderador de views'*x0*exp(SimRisk[i,]) #Simulación del precio
  PL[i,]=X_ast-V0  #Pérdidas y ganancias por posición
  PLT[i]=sum(PL[i,])
}
PL[1:10,]
PLT[1:10,]

for (i in (1:m))
{
  VaRCont[i]=quantile(PL[,i],1-alpha,Ns)
  CVaRCont[i]= mean(PL[which(PL[,i]<VaRCont[i]),i])
}

#VaR Total
VaRTotal=quantile(PLT,1-alpha,Ns)
CVaRTotal= mean(PLT[which(PLT<VaRTotal),])

  
#------------------------------------------------------------------------------------

