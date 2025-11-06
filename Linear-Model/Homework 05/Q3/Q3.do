tsset Month
ac Rainfall, lags(24) name(ac_plot, replace)
corrgram Rainfall, lags(24)
wntestq Rainfall, lags(24)

//平稳性检验
dfuller Rainfall, drift lags(0)
dfuller Rainfall, trend lags(0)
dfuller Rainfall, noconstant lags(0)
 
dfuller Rainfall, drift lags(1)
dfuller Rainfall, trend lags(1)
dfuller Rainfall, noconstant lags(1)

dfuller Rainfall, drift lags(2)
dfuller Rainfall, trend lags(2)
dfuller Rainfall, noconstant lags(2)