tsset Year
//纯随机性
corrgram MortalityRate, lags(24)
wntestq MortalityRate, lags(24)

//平稳性检验
dfuller MortalityRate, drift lags(0)
dfuller MortalityRate, trend lags(0)
dfuller MortalityRate, noconstant lags(0)
 
dfuller MortalityRate, drift lags(1)
dfuller MortalityRate, trend lags(1)
dfuller MortalityRate, noconstant lags(1)
