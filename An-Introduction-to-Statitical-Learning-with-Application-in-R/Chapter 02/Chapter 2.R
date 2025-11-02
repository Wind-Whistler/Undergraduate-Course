#fundamental command
x<-c(1,2,3)
y<-c(4,5,6)

#use length() to check vector's array
length(x)
length(y)

#fundamental calculation
x+y
x-y
x*y
x/y

#check/remove object
ls()
rm(a,dsmall)
ls()
rm(list=ls()) #remove all object

#create matrix
a<-matrix(c(x,y),2,3)  #data row column
print(a)
sqrt(a)

#rnorm()
set.seed(123)
b<-rnorm(10,0,1)
mean(b)
var(b)
sd(b)

#Graph
rm(list=ls())
z<-rnorm(100,0,10)
x<-c(1:100)
y<-(3.5*x+2.25+z)
#create a pdf to export the plot
pdf("Figure.pdf")
plot(x,y,xlab="x",ylab="y",main="Plot of X vs Y",col="darkred")
dev.off()

#seq()
a=seq(1,10)
b=seq(1,10)
c=outer(a,b,function(a,b)cos(a)*sin(b)) #outer given data a,b then combine a,b to a matrix according to the function
#draw 3-dimensional graph
#contour
contour(a,b,c)
contour(a,b,c,nlevels=15)
#persp-->with colour
persp(a,b,c)
persp(a,b,c, theta = 30 , phi = 20)  #theta and phi are used to change angles

#index
A<-matrix(1:16,4,4)
print(A)
A[2,3]
A[c(1,3),c(2,4)]
A[1:3,2:3]
A[1:3,]
A[-c(1),]

#dim()
dim(A)

#Load data
Auto<-read.table("Auto.data",header=T,na.strings="?",stringsAsFactors = T)  
#header:read first row as name, 
#na.strings:Sign of missing data
#stringasfactors: any variable containing string will be interpreted as qualitative variable
View(Auto)
head(Auto)

#load csv
Auto2<-read.csv("Auto.csv",header=T,na.strings="?",stringsAsFactors=T)
View(Auto2)
head(Auto2)
dim(Auto2)

#na.omit --> delete missing data
Auto<-na.omit(Auto)
dim(Auto)
names(Auto) #check variable's name

#plot with imported data
plot(Auto$cylinders,Auto$mpg,col="red",xlab="Cylinders",ylab="mpg") #use $
attach(Auto) #use attach()
plot(cylinders,mpg)

#transform quantitative variable to qualitative
cylinders=as.factor(cylinders)
#if variable in x is qualitative,then plot will be boxplot
plot(cylinders,mpg,col="blue")

#histogram
hist(mpg,col=3,breaks=10)

#pairs -->generate scattered plot between each two variable
pairs(Auto,col=2)

#plot+identity
names(Auto)
plot(horsepower,acceleration,col=4)
identify(horsepower,acceleration,name)

#summary
summary(Auto) # to all variables
summary(mpg)

#--------------------------------------------
#Application Part
#Q8:
#(a)
college=read.csv("College.csv",header=T,stringsAsFactors = T)
#(B)
View(college)
head(college)
rownames<-college[,1]
View(college)
names(college)
#(c)
summary(college)
pairs(college[,3:12],col=3)
attach(college)
plot(Private,Outstate,col=2)
Elite<-rep("No",nrow(college))
Elite[Top10perc>50]<-"Yes"
Elite<-as.factor(Elite)
college<-data.frame(college,Elite)
summary(Elite)
plot(Elite,Outstate)
par(mfrow=c(2,2)) #plot in 2*2
hist(Apps)
hist(Accept)
hist(Enroll)
hist(Expend)

#Q9:
#(a)
sapply(Auto,class)
#(b)
sapply(Auto[c(-9)],range)
#(c)
sapply(Auto[c(-9)],mean)
sapply(Auto[c(-9)],sd)
#(d)
sapply(Auto[-c(-10,-85),c(-9)],mean)
sapply(Auto[-c(-10,-85),c(-9)],range)
sapply(Auto[-c(-10,-85),c(-9)],sd)
#(e)
plot(mpg,displacement)
plot(mpg,horsepower)
plot(mpg,weight)
plot(mpg,acceleration)

#10
#(a)
Boston<-read.csv("Boston.csv")
dim(Boston)
names(Boston)
View(Boston)
#(b)
attach(Boston)
pairs(Boston[,-1])
#(d)
sapply(Boston[,-1],range)
#(e)
chas<-as.factor(chas)
summary(chas)
#(f)
median(ptratio)
#(g)
X[which.min(lstat)]
Boston[which.min(lstat),]
hist(crim)
#(h)
sum(rm>7)
sum(rm>8)
Res<-Boston[rm>8,]
View(Res)
