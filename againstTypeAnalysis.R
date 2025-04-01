##### AGAINST TYPE ANALYSIS #####

source("./code/loadPackages.R") # Install and load all necessary packages

# Load necessary data
posp = fread("./data/againstTypeData.csv") 

# How many meetings in the data?
length(unique(posp$meetNum)) # 425

# How many speech acts in the data?
nrow(posp) # 18,836

# See how conflictual recommendations (fighting and coercing) relate to hawkishness
typeTable = table(posp$hawkcat, posp$fightCoerce)
propTypeTable = prop.table(typeTable, 1)

# How much more frequently do hawkish people recommend conflict than more dovish people?
propTypeTable["High", "1"]/propTypeTable["Low", "1"] # 1.724

# Clear environment
rm(list = ls())