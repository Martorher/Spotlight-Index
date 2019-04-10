suppressMessages(library(rvest))
suppressMessages(library(syuzhet))
suppressMessages(library(curl))
suppressMessages(library(quantmod))
suppressMessages(library(dplyr))
suppressMessages(library(tidytext))
suppressMessages(library(tm))
suppressMessages(library(purrr))
suppressMessages(library(tidyr))


### Variables Globales

location <- 'C:/Users/alman/Documents/Actuaría/9no Semestre/Seminario de Ciencia de Datos en el Mercado de Capitales/Project/bases de datos/'

### Prefijo del sitio web, iteraciones y sufijo.
tempURL <- 'https://en.wikipedia.org/wiki/'
tempCompaniesList <- c("3M","Abbott Laboratories", "AbbVie Inc.","Abiomed","Accenture plc","Activision Blizzard","Adobe Systems Inc","Advanced Micro Devices Inc","Advance Auto Parts","AES Corp","Affiliated Managers Group Inc", "AFLAC Inc", "Agilent Technologies Inc", "Air Products %26 Chemicals Inc", "Akamai Technologies Inc",
                       "Alaska Air Group Inc","Albemarle Corp", "Alexandria Real Estate Equities", "Alexion Pharmaceuticals", "Align Technology","Allegion","Allergan, Plc","Alliance Data Systems","Alliant Energy Corp","Allstate Corp", "Alphabet Inc.","Alphabet Inc.","Altria Group Inc","Amazon.com Inc.","Ameren Corp",
                       "American Airlines Group","American Electric Power", "American Express Co", "American International Group","American Tower Corp.","American Water Works","Ameriprise Financial","AmerisourceBergen Corp","AMETEK Inc.","Amgen Inc.","Amphenol Corp","Anadarko Petroleum Corp","Analog Devices, Inc.","ANSYS",
                       "Anthem Inc.","Aon plc","A.O. Smith","Apache Corporation","Apartment Investment %26 Management", "Apple Inc.","Applied Materials Inc.","Aptiv Plc","Archer-Daniels-Midland Co","Arconic Inc.","Arista Networks","Arthur J. Gallagher %26 Co.","Assurant","AT%26T Inc.","Autodesk Inc.","Automatic Data Processing",
                       "AutoZone Inc","AvalonBay Communities, Inc.","Avery Dennison Corp","Baker Hughes, a GE Company","Ball Corp","Bank of America Corp","The Bank of New York Mellon Corp.","Baxter International Inc.","BB%26T Corporation","Becton Dickinson","Berkshire Hathaway","Best Buy Co. Inc.","Biogen Inc.","BlackRock","Block H%26R",
                       "Boeing Company","Booking Holdings ","BorgWarner","Boston Properties","Boston Scientific","Brighthouse Financial Inc","Bristol-Myers Squibb","Broadcom Limited","Broadridge Financial Solutions","Brown-Forman Corp.","C. H. Robinson Worldwide","Cabot Oil & Gas","Cadence Design Systems","Campbell Soup",
                       "Capital One Financial","Cardinal Health","Carmax Inc","Carnival Corp.","Caterpillar Inc.","Cboe Global Markets","CBRE Group","CBS Corp.","Celgene Corp.","Centene Corporation","CenterPoint Energy","CenturyLink Inc","Cerner","CF Industries Holdings Inc","Charles Schwab Corporation","Charter Communications",
                       "Chevron Corp.","Chipotle Mexican Grill","Chubb Limited","Church %26 Dwight","CIGNA Corp.","Cimarex Energy","Cincinnati Financial","Cintas Corporation","Cisco Systems","Citigroup Inc.","Citizens Financial Group","Citrix Systems","The Clorox Company","CME Group Inc.","CMS Energy","Coca-Cola Company",
                       "Cognizant Technology Solutions","Colgate-Palmolive","Comcast Corp.","Comerica Inc.","Conagra Brands","Concho Resources","ConocoPhillips","Consolidated Edison","Constellation Brands","The Cooper Companies","Copart Inc","Corning Inc.","Costco Wholesale Corp.","Coty, Inc","Crown Castle International Corp.","CSX Corp.",
                       "Cummins Inc.","CVS Health","D. R. Horton","Danaher Corp.","Darden Restaurants","DaVita","Deere %26 Co.","Delta Air Lines","Dentsply Sirona","Devon Energy","Diamondback Energy Inc","Digital Realty","Discover Financial Services","Discovery Inc.","Discovery Inc.","Dish Network","Dollar General","Dollar Tree",
                       "Dominion Energy","Dover Corp.","DowDuPont","DTE Energy","Duke Realty","DXC Technology","E*Trade","Eastman Chemical","Eaton Corporation","eBay","Ecolab","Edison Int%27l","Edwards Lifesciences","Electronic Arts","Emerson Electric Company","Entergy Corp.","EOG Resources","Equifax Inc.","Equinix","Equity Residential",
                       "Essex Property Trust, Inc.","Estee Lauder Cos.","Evergy","Eversource Energy","Everest Re","Exelon Corp.","Expedia Group","Expeditors International","Express Scripts","Extra Space Storage","Exxon Mobil Corp.","F5 Networks","	Facebook, Inc.","	Fastenal Co","Federal Realty Investment Trust","FedEx Corporation",
                       "Fidelity National Information Services","Fifth Third Bancorp","FirstEnergy Corp","Fiserv Inc","FleetCor","FLIR Systems","Flowserve Corporation","Fluor Corp.","FMC Corporation","Foot Locker Inc","Ford Motor","Fortinet","Fortive Corp","Fortune Brands Home %26 Security","Franklin Resources","Freeport-McMoRan Inc.",
                       "Gap Inc.","Garmin Ltd.","Gartner","General Dynamics","General Electric","General Mills","General Motors","Genuine Parts","Gilead Sciences","Global Payments Inc.","Goldman Sachs Group","Goodyear Tire %26 Rubber","Grainger (W.W.) Inc.","	Halliburton Co.","Hanesbrands Inc","Harley-Davidson","Harris Corporation",
                       "Hartford Financial Svc.Gp.","Hasbro Inc.","	HCA Holdings","HCP Inc.","Helmerich %26 Payne","Henry Schein","The Hershey Company","Hess Corporation","Hewlett Packard Enterprise","Hilton Worldwide","HollyFrontier","Hologic","Home Depot","Honeywell Int%27l Inc.","Hormel Foods Corp.","Host Hotels %26 Resorts",
                       "HP Inc.","Humana Inc.","Huntington Bancshares","Huntington Ingalls Industries","IDEXX Laboratories","IHS Markit","Illinois Tool Works","Illumina (company)","Ingersoll-Rand PLC","Intel Corp.","Intercontinental Exchange","IBM","Incyte","International Paper","Interpublic Group","Intl Flavors %26 Fragrances","Intuit",
                       "Intuitive Surgical Inc.","Invesco Ltd.","IPG Photonics","IQVIA","Iron Mountain Incorporated","Jack Henry %26 Associates Inc","Jacobs Engineering Group","J. B. Hunt Transport Services","Jefferies Financial Group","JM Smucker","Johnson %26 Johnson","Johnson Controls","JPMorgan Chase %26 Co.","Juniper Networks",
                       "Kansas City Southern (company)","Kellogg Co.","KeyCorp","Keysight Technologies","Kimberly-Clark","Kimco Realty","Kinder Morgan","KLA-Tencor Corp.","Kohl%27s","Kraft Heinz","Kroger Co.","L Brands Inc.","L-3 Communications Holdings","Laboratory Corp. of America Holding","Lam Research","Lamb Weston Holdings Inc",
                       "Leggett %26 Platt","Lennar Corp.","Lilly (Eli) %26 Co.","Lincoln National","Linde plc","LKQ Corporation","Lockheed Martin Corp.","Loews Corp.","Lowe%27s Cos.","LyondellBasell","M%26T Bank Corp.","Macerich","Macy%27s Inc.","Marathon Oil Corp.","Marathon Petroleum","Marriott Int%27l.","Marsh %26 McLennan",
                       "Martin Marietta Materials","Masco Corp.","Mastercard Inc.","Mattel Inc.","McCormick %26 Co.","Maxim Integrated","McDonald%27s Corp.","McKesson Corp.","Medtronic plc","Merck %26 Co.","MetLife Inc.","Mettler Toledo","MGM Resorts International","Michael Kors (brand)","Microchip Technology","Micron Technology",
                       "Microsoft Corp.","Mid-America Apartments","Mohawk Industries","Molson Coors Brewing Company","Mondelez International","Monster Beverage","Moody%27s Corp","Morgan Stanley","The Mosaic Company","Motorola Solutions Inc.","MSCI Inc","Mylan N.V.","Nasdaq, Inc.","National Oilwell Varco Inc.","Nektar Therapeutics","NetApp",
                       "Netflix Inc.","Newell Brands","Newfield Exploration Co","Newmont Mining Corporation","News Corp. Class A","News Corp. Class B","NextEra Energy","Nielsen Holdings","Nike (company)","NiSource Inc.","Noble Energy Inc","Nordstrom","Norfolk Southern Corp.","Northern Trust Corp.","Northrop Grumman Corp.","Norwegian Cruise Line",
                       "NRG Energy","Nucor Corp.","Nvidia Corporation","O%27Reilly Automotive","Occidental Petroleum","Omnicom Group","ONEOK","Oracle Corp.","PACCAR Inc.","Packaging Corporation of America","Parker-Hannifin","Paychex Inc.","PayPal","Pentair plc","People%27s United Financial","PepsiCo Inc.","PerkinElmer","Perrigo","Pfizer Inc.",
                       "PG%26E Corp.","Philip Morris International","Phillips 66","Pinnacle West Capital","Pioneer Natural Resources","PNC Financial Services","Polo Ralph Lauren Corp.","PPG Industries","PPL Corp.","Principal Financial Group","Procter %26 Gamble","Progressive Corp.","Prologis","Prudential Financial","Public Serv. Enterprise Inc.",
                       "Public Storage","Pulte Homes Inc.","PVH Corp.","Qorvo","Quanta Services Inc.","QUALCOMM Inc.","Quest Diagnostics","Raymond James Financial Inc.","Raytheon Co.","Realty Income Corporation","Red Hat Inc.","Regency Centers Corporation","Regeneron","Regions Financial Corp.","Republic Services Inc","ResMed","Robert Half International",
                       "Rockwell Automation Inc.","Rollins Inc.","Roper Technologies","Ross Stores","Royal Caribbean Cruises Ltd","Salesforce.com","SBA Communications","SCANA Corp","Schlumberger Ltd.","Seagate Technology","Sealed Air Corp.(New)","Sempra Energy","Sherwin-Williams","Simon Property Group Inc","Skyworks Solutions","SL Green Realty","Snap-on",
                       "Southern Co.","Southwest Airlines","S%26P Global, Inc.","Stanley Black %26 Decker","Starbucks Corp.","State Street Corp.","Stryker Corp.","SunTrust Banks","SVB Financial","Symantec Corp.","Synchrony Financial","Synopsys Inc.","Sysco Corp.","T. Rowe Price Group","Take-Two Interactive","Tapestry, Inc.","Target Corp.","TE Connectivity",
                       "TechnipFMC","Texas Instruments","Textron Inc.","Thermo Fisher Scientific","Tiffany %26 Co.","Twitter, Inc.","TJX Companies Inc.","Torchmark Corp.","Total System Services","Tractor Supply Company","TransDigm Group","The Travelers Companies Inc.","TripAdvisor","Twenty-First Century Fox Class A","Twenty-First Century Fox Class B",
                       "Tyson Foods","UDR Inc","Ulta Beauty","U.S. Bancorp","Under Armour","Under Armour","Union Pacific","United Continental Holdings","United Health Group Inc.","United Parcel Service","United Rentals, Inc.","United Technologies","Universal Health Services, Inc.","Unum Group","V.F. Corp.","Valero Energy","Varian Medical Systems","Ventas Inc",
                       "Verisign Inc.","Verisk Analytics","Verizon Communications","Vertex Pharmaceuticals Inc","Viacom Inc.","Visa Inc.","Vornado Realty Trust","Vulcan Materials","Walmart","Walgreens Boots Alliance","The Walt Disney Company","Waste Management Inc.","Waters Corporation","Wec Energy Group Inc","WellCare","Wells Fargo","Welltower Inc.",
                       "Western Digital","Western Union Co","WestRock","Weyerhaeuser","Whirlpool Corp.","Williams Cos.","Willis Towers Watson","Wynn Resorts","Xcel Energy Inc","Xerox","	Xilinx","Xylem Inc.","Yum! Brands Inc","Zimmer Biomet Holdings","Zions Bancorp","Zoetis")
tempPostURL <- ''   

### Así es como se ve
paste0(tempURL,tempCompaniesList[1],tempPostURL)
paste0(tempURL,tempCompaniesList[113],tempPostURL)
paste0(tempURL,tempCompaniesList[500],tempPostURL)
paste0(tempURL,tempCompaniesList[367],tempPostURL)

for (i in tempCompaniesList)
{
  WEBLINK <- paste0(tempURL,i,tempPostURL)
  #imprime el enlace de la web
  write.table(WEBLINK,file ='C:/Users/alman/Documents/Actuaría/9no Semestre/
            Seminario de Ciencia de Datos en el Mercado de Capitales/Project/bases de datos/SP500views.txt',sep = '\t',row.names = FALSE )
  
}



 
