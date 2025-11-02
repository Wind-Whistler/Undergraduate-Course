library(mgcv)

# 读取数据
prostate <- read.csv("c:/Users/huawei/Desktop/R/Prostate.csv")
prostate$train <- as.logical(prostate$train)
train_data <- subset(prostate, train == TRUE)

# 原 GAM 模型（非线性）
gam_model <- gam(lpsa ~ s(lcavol), data = train_data)
bic_gam <- extractAIC(gam_model, k = log(nrow(train_data)))[2]

# 新线性模型（替换为线性项）
linear_model <- gam(lpsa ~ lcavol, data = train_data)
bic_linear <- extractAIC(linear_model, k = log(nrow(train_data)))[2]

# 输出两个模型的 BIC
cat("\nGAM 模型 (s(lcavol)) 的 BIC:", bic_gam, "\n")
cat("线性模型 (lcavol) 的 BIC:", bic_linear, "\n")

# 判断哪个模型更好
if (bic_gam < bic_linear) {
  cat("\n【结论】GAM 模型更优（样条函数改进了模型）\n")
} else if (bic_gam > bic_linear) {
  cat("\n【结论】线性模型更优（样条函数没有带来改进）\n")
} else {
  cat("\n【结论】两个模型 BIC 相同\n")
}