//样本自相关图
tsset Series
ac CO2, lags(24) name(ac_plot, replace)
corrgram CO2, lags(24)