
# coding: utf-8

# In[9]:


import pageviewapi
import pandas as pd

#Tickers

lon=pd.read_csv('SP500.txt',sep='\t')
lon['Symbol'].replace(to_replace=['BRK.B'],value='Berkshire_Hathaway',inplace=True)
lon['Symbol'].replace(to_replace=['DWDP'],value='DowDuPont',inplace=True)
lon['Symbol'].replace(to_replace=['AVGO'],value='Broadcom_Inc',inplace=True)
lon['Symbol'].replace(to_replace=['GILD'],value='Gilead_Sciences',inplace=True)
lon['Symbol'].replace(to_replace=['OXY'],value='Occidental_Petroleum',inplace=True)
lon['Symbol'].replace(to_replace=['SPGI'],value='S&P Global Inc',inplace=True)
lon['Symbol'].replace(to_replace=['AON'],value='Aon plc',inplace=True)
lon['Symbol'].replace(to_replace=['ROST'],value='Ross_Stores',inplace=True)
lon['Symbol'].replace(to_replace=['PXD'],value='Pioneer_Natural_Resources',inplace=True)
lon['Symbol'].replace(to_replace=['ALXN'],value='Alexion_Pharmaceuticals',inplace=True)
lon['Symbol'].replace(to_replace=['XEL'],value='Xcel_Energy',inplace=True)
lon['Symbol'].replace(to_replace=['ZBH'],value='Zimmer_Biomet',inplace=True)
lon['Symbol'].replace(to_replace=['EQR'],value='Equity Residential',inplace=True)
lon['Symbol'].replace(to_replace=['TROW'],value='T._Rowe_Price',inplace=True)
lon['Symbol'].replace(to_replace=['EIX'],value='Edison_International',inplace=True)
lon['Symbol'].replace(to_replace=['LRCX'],value='Lam Research Corporation',inplace=True)
lon['Symbol'].replace(to_replace=['VRSK'],value='Verisk Analytics Inc',inplace=True)
lon['Symbol'].replace(to_replace=['ALGN'],value='Align Technology Inc',inplace=True)
lon['Symbol'].replace(to_replace=['EVRG'],value='Evergy Inc',inplace=True)
lon['Symbol'].replace(to_replace=['ABMD'],value='Abiomed',inplace=True)
lon['Symbol'].replace(to_replace=['SWKS'],value='Skyworks_Solutions',inplace=True)
lon['Symbol'].replace(to_replace=['HBAN'],value='Huntington_Bancshares',inplace=True)
lon['Symbol'].replace(to_replace=['SNPS'],value='Synopsys',inplace=True)
lon['Symbol'].replace(to_replace=['BHGE'],value='Baker_Hughes',inplace=True)
lon['Symbol'].replace(to_replace=['FTNT'],value='Fortinet Inc',inplace=True)
lon['Symbol'].replace(to_replace=['INCY'],value='Incyte',inplace=True)
lon['Symbol'].replace(to_replace=['DISCK'],value='Discovery,_Inc.',inplace=True)
lon['Symbol'].replace(to_replace=['ZION'],value='Zions_Bancorporation',inplace=True)
lon['Symbol'].replace(to_replace=['NCLH'],value='Norwegian_Cruise_Line',inplace=True)
lon['Symbol'].replace(to_replace=['JBHT'],value='J._B._Hunt',inplace=True)
lon['Symbol'].replace(to_replace=['PRGO'],value='Perrigo',inplace=True)
lon['Symbol'].replace(to_replace=['NLSN'],value='Nielsen_Holdings',inplace=True)
lon['Symbol'].replace(to_replace=['QRVO'],value='Qorvo',inplace=True)
lon['Symbol'].replace(to_replace=['ARNC'],value='Arconic Inc',inplace=True)
lon['Symbol'].replace(to_replace=['BF.B'],value='Brown–Forman',inplace=True)
lon['Symbol'].replace(to_replace=['ALLE'],value='Allegion',inplace=True)
lon['Symbol'].replace(to_replace=['SRCL'],value='Stericycle',inplace=True)
lon['Symbol'].replace(to_replace=['NFX'],value='Newfield Exploration Company',inplace=True)
lon['Symbol'].replace(to_replace=['UAA'],value='Under_Armour',inplace=True)
lon['Symbol'].replace(to_replace=['NWS'],value='News Corporation',inplace=True)
tickers=lon['Symbol'].values.tolist()
j=0
for letra in tickers:
    j=j+1
    list_view=[]
    list_dates=[]
    #Cargamos los valores de las vistas por dia
    a=pageviewapi.per_article ( 'en.wikipedia' ,str(letra) ,  '20150101' ,  '20181020' , access = 'all-access' ,  agent = 'all-agents' ,  granularity = 'daily' )
    #Accedemos a la lista en donde podemos encontrara un diccionario por cada fecha
    Data=a['items']
    for i in range(len(Data)):
        #Obtenemos únicamente las fechas y las views en ese día  
        c_1=Data[i].get('timestamp')
        c=c_1[0:8]
        d=Data[i].get('views')
        list_dates.append(c)
        list_view.append(d)
        #Lo convertimos en un data frame para despues convertirloen csv
    if j==1:
        DF_out=pd.DataFrame({'Date':list_dates})
        DF_out['Views_'+letra]=list_view
    else:
        DF=pd.DataFrame({'Date':list_dates})
        DF['Views'+letra]=list_view
        DF_out= DF_out.merge(DF, on='Date', how='left')
       

DF_out.to_csv ( ' viewSP500.csv ' , header = True , index = False )

