//一次回归
reg y x

//二次回归
gen x2=x^2
reg y x x2

//三次回归
gen x3=x^3
reg y x x2 x3