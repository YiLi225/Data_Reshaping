import pandas as pd
pd.options.display.max_columns = 1000
pd.options.display.max_colwidth = 1000

raw_dat = pd.read_excel('...\Data_Reshaping_Raw.xlsx')

##==== PIVOT -> Long to Wide using pandas.pivot_table 
## (1) fillna with 0 to convert the 'permit' column to integers
raw_dat['permit'] = raw_dat['permit'].fillna(0).astype(int)

## (2) Arg:
##        index: variable stacks on the rows, whereas columns: spreads over the columns
wide_dat = pd.pivot_table(raw_dat, index='state', 
                          columns='month', values='permit')

## (3) Set the columns to str, rather than the default datetime, and reset index 
wide_dat.columns = wide_dat.columns.astype('str')
wide_dat.reset_index(inplace=True)
wide_dat.columns.name = None


##==== UN-PIVOT -> Wide to Long using pandas.melt
back_to_long_dat = pd.melt(wide_dat, 
                           id_vars='state', 
                           var_name='month', 
                           value_name='permit')
                           
## order the output and reset index
back_to_long_dat.sort_values(by=['month', 'state'], ascending=[False, True], inplace=True)
back_to_long_dat = back_to_long_dat[raw_dat.columns]
back_to_long_dat.reset_index(inplace=True, drop=True)




