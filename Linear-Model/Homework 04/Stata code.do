//Q1 
generate log=ln(p/(1-p))
reg log x

//Q2
generate x1x2=x1*x2
generate log=ln(Ey/(1-Ey))
reg log x1 x2 x1x2