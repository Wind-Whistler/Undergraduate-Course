//导入文件
import delimited "E:\大三\大三上\Regression Analysis+Time Series\Homework\Report 01\Credit.csv", clear 

reg balance income limit rating cards age education
estat vif

//向后逐步回归
stepwise, pr(0.05): regress balance income limit rating cards age education
estat vif

//相关性分析
pwcorr income limit rating cards age education, sig star(0.01)

//一元非线性回归
gen ln_income=ln(income+1)
gen rat=1/rating
reg ln_income rat

//Logistic回归
* 创建新的 0-1 变量
gen married_dummy = (married == "Yes")
logit married_dummy balance limit rating cards age education


