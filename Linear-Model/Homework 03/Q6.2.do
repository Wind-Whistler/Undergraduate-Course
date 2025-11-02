//只影响截距项
reg y x1 D

//同时影响截距和斜率
gen cross=x1*D
reg y x1 D cross