library(mgcv)

# 读取数据
prostate <- read.csv("c:/Users/huawei/Desktop/R/Prostate.csv")

# 将train列转换为逻辑型
prostate$train <- as.logical(prostate$train)

# 划分训练集和测试集
train_data <- subset(prostate, train == TRUE)
test_data <- subset(prostate, train == FALSE)

# 设置随机种子
set.seed(120401002)

# 构建GAM模型，去除lbph，svi和gleason作为参数项，其他连续变量使用平滑项
# 公式中不对svi和gleason使用s()，避免过拟合
model_formula <- lpsa ~ s(lcavol) + s(lweight) + s(age) + s(lcp) + s(pgg45) + svi + gleason

# 拟合模型
gam_model <- gam(model_formula, data = train_data)

# 输出模型摘要
summary(gam_model)

# 提取并打印每个项的p值
param_pvalues <- summary(gam_model)$p.table
smooth_pvalues <- summary(gam_model)$s.table

cat("\n参数项(p值):\n")
print(param_pvalues)

cat("\n平滑项(p值):\n")
print(smooth_pvalues)

library(glmnet)

# 读取数据
prostate <- read.csv("c:/Users/huawei/Desktop/R/Prostate.csv")

# 划分训练集和测试集
prostate$train <- as.logical(prostate$train)
train_data <- subset(prostate, train == TRUE)
test_data <- subset(prostate, train == FALSE)

# 准备自变量矩阵和因变量向量
# 将分类变量svi和gleason转换为因子并进行哑变量编码
train_x <- model.matrix(lpsa ~ lcavol + lweight + age + lbph + lcp + factor(svi) + factor(gleason) + pgg45, data=train_data)[,-1]
train_y <- train_data$lpsa

# 设置随机种子
set.seed(120401002)

# 使用cv.glmnet进行交叉验证选择最佳lambda
cv_fit <- cv.glmnet(train_x, train_y, alpha=1) # alpha=1表示Lasso

# 输出最佳lambda
best_lambda <- cv_fit$lambda.min
cat("最佳lambda:", best_lambda, "\n")

# 使用最佳lambda拟合模型
lasso_model <- glmnet(train_x, train_y, alpha=1, lambda=best_lambda)

# 输出系数
coef_lasso <- coef(lasso_model)
print(coef_lasso)

# 变量选择结果
selected_vars <- rownames(coef_lasso)[which(coef_lasso != 0)]
cat("\n被选择的变量:\n")
print(selected_vars)