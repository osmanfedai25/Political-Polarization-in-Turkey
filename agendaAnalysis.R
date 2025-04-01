#### Appendix 9: Agenda Items and Hawkishness ####

source("./code/loadPackages.R") # Install and load all necessary packages

# Load necessary data
nscd_all = fread("./data/meetingData.csv")
nscd_all$admin = factor(nscd_all$admin, levels=c("Truman", "Eisenhower", "Kennedy", "Johnson", "Nixon", "Ford", "Carter", "Reagan"))
nscd_all$date = as.Date(nscd_all$date)

# Try looking at how agenda items dictate hawkishness
topicData = nscd_all %>% dplyr::select(meanHawk, contains("mention"), formal, date)
topicData$date = as.Date(topicData$date)
topicData$year = format(topicData$date, "%Y")
topicData = topicData %>% dplyr::select(-date)

# Disaggregate formal and informal meetings
topicDataF = topicData %>% filter(formal==1)
topicDataI = topicData %>% filter(formal==0)

#### Table A50: Distribution of Agenda Items Across All Meetings ####
topics = names(topicData)[grepl("mention", names(topicData))]

noTopic = yesTopic = NA
for (i in 1:length(topics)) {
  onetopic = topicData %>% dplyr::select(topics[i])
  noTopic[i] = nrow(onetopic) - sum(onetopic[,1])
  yesTopic[i] = sum(onetopic[,1])
}

topicTable = xtable(data.frame(gsub("mention.", "", topics), noTopic, yesTopic))
print(topicTable, include.rownames=F)

# Regress hawkishness on topics
topicFit = lm(meanHawk ~ ., data=topicData)
topicFitF = lm(meanHawk ~ . - formal, data=topicDataF)
topicFitI = lm(meanHawk ~ . - formal, data=topicDataI)

#### Table A50: OLS Regressions on the Relationship Between Meeting Topics and Average Hawkishness of Meeting Participants ####
stargazer(topicFit, topicFitF, topicFitI, 
          column.sep.width = "0pt", no.space=T, align=T, df=F,
          omit = c("year"),
          omit.stat = c("ll", "rsq", "adj.rsq", "aic", "f", "ser"),
          covariate.labels = c("USSR", "Asia", "Middle East", "Economy",
                               "Other", "Europe", "International Institutions",
                               "Intelligence", "Strategic Forces",
                               "Americas", "Defense", "Diplomacy", "Organization",
                               "Vietnam", "Policy", "China", "Africa",
                               "Latin America", "Arms Control", 
                               "North Africa", "Formal"))
