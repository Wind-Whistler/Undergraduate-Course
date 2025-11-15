//导入文件
import delimited "E:\大三\大三上\Regression Analysis+Time Series\Homework\Report 01\Credit.csv"

//多元线性回归
reg balance income limit rating cards age education
estimates store model_1
esttab model_1 using "回归结果.rtf", replace label title("回归结果") se star(* 0.10 ** 0.05 *** 0.01)
//向后逐步回归
stepwise, pr(0.05): regress balance income limit rating cards age education
estimates store model_2
esttab model_2 using "向后回归结果.rtf", replace label title("回归结果") se star(* 0.10 ** 0.05 *** 0.01)
//向前逐步回归
stepwise, pe(0.05): regress balance income limit rating cards age education
estimates store model_3
esttab model_3 using "向前回归结果.rtf", replace label title("回归结果") se star(* 0.10 ** 0.05 *** 0.01)

//线性性诊断
reg balance rating income
predict stdresid, rstudent
scatter stdresid rating, yline(0) title("Studentized Residuals vs Rating")
scatter stdresid income, yline(0) title("Studentized Residuals vs Income")
//误差独立性检验
tsset id
estat dwatson
//方差齐性检验
oneway balance region, tabulate
//正态性检验
predict e, residuals
pnorm e, title("P-P Plot of Residuals")
qnorm e, title("Q-Q Plot of Residuals")

//多项式回归
gen rating_s=rating^2
reg balance income rating rating_s
//定性变量
encode student, generate(student_dummy)
reg balance income rating student_dummy