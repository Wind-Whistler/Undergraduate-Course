tsset Month
//纯随机性
corrgram Num, lags(24)
wntestq Num, lags(24)

//平稳性检验
dfuller Num, drift lags(0)
dfuller Num, trend lags(0)
dfuller Num, noconstant lags(0)
 
dfuller Num, drift lags(1)
dfuller Num, trend lags(1)
dfuller Num, noconstant lags(1)

dfuller Num, drift lags(2)
dfuller Num, trend lags(2)
dfuller Num, noconstant lags(2)