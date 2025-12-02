tsset time
tsline x, title("Time Series of x") legend(order(1 "x")) lpattern(solid) lcolor(blue)

//随机性检验
corrgram x, lags(24)

//平稳性检验
dfuller x, drift lags(0)
dfuller x, trend lags(0)
dfuller x, noconstant lags(0)
 
dfuller x, drift lags(1)
dfuller x, trend lags(1)
dfuller x, noconstant lags(1)

dfuller x, drift lags(2)
dfuller x, trend lags(2)
dfuller x, noconstant lags(2)

//自相关系数/偏自相关系数
ac x, lags(12) name(ac_plot, replace)
pac x,lags(12) name(pac_plot, replace)

//模型拟合
arima x,ma(2)
estat ic

arima x,ar(1)
estat ic

//残差白噪声检验
predict e, residuals
corrgram e, lags(24)

//序列预测
predict se_static, stdp

predict x_dynamic, xb dynamic(71)

gen lower_ci = x_dynamic - 1.96 * se_static
gen upper_ci = x_dynamic + 1.96 * se_static

list time x x_dynamic lower_ci upper_ci if time >= 71

twoway (line x t, lcolor(blue) lpattern(solid)) /// 
       (line x_dynamic t, lcolor(red) lpattern(dash)) /// 
       (rcap upper_ci lower_ci t, lcolor(red) lpattern(solid)), /// 
       legend(order(1 "Actual Values" 2 "Predicted Values" 3 "95% Confidence Interval")) ///
       title("Actual vs Predicted with 95% Confidence Interval") /// 
       ytitle("Values") xtitle("Time") /// 
       scheme(s1mono)