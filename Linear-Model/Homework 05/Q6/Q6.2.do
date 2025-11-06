tsset Month
//纯随机性
corrgram Y, lags(24)
wntestq Y, lags(24)

//平稳性检验
dfuller Y, drift lags(0)
dfuller Y, trend lags(0)
dfuller Y, noconstant lags(0)
 
dfuller Y, drift lags(1)
dfuller Y, trend lags(1)
dfuller Y, noconstant lags(1)

dfuller Y, drift lags(2)
dfuller Y, trend lags(2)
dfuller Y, noconstant lags(2)