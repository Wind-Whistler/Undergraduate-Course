reg 支出 受教育年限 可支配收入

set obs `=_N + 1'

replace 受教育年限 = 10 in l
replace 可支配收入 = 480 in l

* 预测
predict yhat, xb
predict se_pred, stdf

* 计算 95% 预测区间
local t_crit = invttail(e(df_r), 0.025)
gen lower = yhat - `t_crit' * se_pred
gen upper = yhat + `t_crit' * se_pred

* 查看结果
list y yhat lower upper in l

