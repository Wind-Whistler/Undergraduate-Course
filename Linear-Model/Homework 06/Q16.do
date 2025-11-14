tsset Year

//平稳性检验
dfuller Mortality_Rate, drift lags(0)
dfuller Mortality_Rate, trend lags(0)
dfuller Mortality_Rate, noconstant lags(0)
 
dfuller Mortality_Rate, drift lags(1)
dfuller Mortality_Rate, trend lags(1)
dfuller Mortality_Rate, noconstant lags(1)

dfuller Mortality_Rate, drift lags(2)
dfuller Mortality_Rate, trend lags(2)
dfuller Mortality_Rate, noconstant lags(2)