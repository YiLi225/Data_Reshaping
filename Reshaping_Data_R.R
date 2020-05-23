### Data Reshaping with SQL, R and Python
### sample data source: 
### https://github.com/BuzzFeedNews
### Open-source data, analysis, libraries, tools, and guides from BuzzFeed's newsroom.
### https://github.com/BuzzFeedNews/nics-firearm-background-checks

library(magrittr)
library(dplyr)
library(tidyr)
raw_dat = openxlsx::read.xlsx('.../Data_Reshaping_Raw.xlsx', detectDates = TRUE)

#####==== 1. {stats}: long to wide & wide to long 
#### Long to Wide with reshape()
### simply put, 
###   timevar: variable spreads as columns
###   idvar: variable stacks as rows
wide_dat = stats::reshape(raw_dat, 
                          timevar = 'month', idvar = 'state', 
                          direction = 'wide')

time_col_names = sapply(strsplit(colnames(wide_dat)[-1], '\\.'), '[[', 2)
colnames(wide_dat) = c(colnames(wide_dat)[1], time_col_names)

#### Wide to Long with reshape()
back_to_long_dat = stats::reshape(wide_dat, 
                                  times = colnames(wide_dat), 
                                  varying = colnames(wide_dat)[-1], 
                                  ### specify the variable name for the time variable, default: time
                                  timevar = 'month', 
                                  direction = 'long') 

### Reset the rownames and re-order the columns to match with the raw data
back_to_long_dat = back_to_long_dat %>% 
                      set_rownames(NULL) %>%
                      ### To avoid hard-coded names: select(colnames(raw_dat)[1], everything(), -id)
                      select(month, everything(), -id) 


#####==== 2. {tidyr}: spread & gather --> pivot_wider & pivot_longer()
#### Long to Wide with spread and pivot_wider()
### simply put, 
###   key: variable spreads as columns
wide_dat = tidyr::spread(data = raw_dat, key = 'month', value = 'permit')

### pivot_wider()
### simply put,
###   names_from: variable spreads as columns
wide_dat = tidyr::pivot_wider(data = raw_dat, 
                              names_from = month,
                              values_from = permit) %>%
              data.frame(.) %>%
              set_colnames(gsub('X', '', colnames(.)))

#### Wide to Long with pivot_longer()
back_to_long_dat = tidyr::pivot_longer(data = wide_dat, 
                                       cols = colnames(wide_dat)[-1],
                                       names_to = 'month', 
                                       values_to = 'permit',
                                       values_drop_na = FALSE) %>%
                      arrange(desc(month)) %>%
                      select(month, everything()) 


#### {reshape2}: melt and dcast/acast can also be used for data reshaping                                     



