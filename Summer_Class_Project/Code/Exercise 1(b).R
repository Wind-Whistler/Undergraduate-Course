library(mgcv)

# 读取数据
prostate <- read.csv("c:/Users/huawei/Desktop/R/Prostate.csv")
prostate$train <- as.logical(prostate$train)
train_data <- subset(prostate, train == TRUE)

# 构建GAM模型，去除lbph，svi和gleason作为参数项，其他连续变量使用平滑项
model_formula <- lpsa ~ s(lcavol) + s(lweight) + s(age) + s(lcp) + s(pgg45) + svi + gleason

# 拟合模型
gam_model <- gam(model_formula, data = train_data)

# 使用extractAIC计算有效自由度和BIC值
# k=log(n)表示计算BIC
aic_result <- extractAIC(gam_model, k = log(nrow(train_data)))

cat("\n有效自由度(DF):", aic_result[1], "\n")
cat("BIC值:", aic_result[2], "\n")

# 计算各变量的自由度之和
summary_gam <- summary(gam_model)
param_df <- nrow(summary_gam$p.table) # 参数项自由度
smooth_df <- sum(summary_gam$s.table[,"edf"]) # 平滑项有效自由度

cat("\n参数项自由度之和:", param_df, "\n")
cat("平滑项有效自由度之和:", smooth_df, "\n")
cat("总自由度之和:", param_df + smooth_df, "\n")

# 验证总自由度是否等于extractAIC报告的自由度
if (abs((param_df + smooth_df) - aic_result[1]) < 1e-6) {
  cat("\n自由度之和与extractAIC报告的自由度一致。\n")
} else {
  cat("\n自由度之和与extractAIC报告的自由度不一致。\n")
}