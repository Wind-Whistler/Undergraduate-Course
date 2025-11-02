# 读取Abalone数据
library(nnet)
library(dplyr)

# 设置随机种子
set.seed(29003092)

# 读取数据
abalone <- read.csv("c:/Users/huawei/Desktop/R/Abalone.csv")

# 按7:3比例划分训练集和测试集
sample_index <- sample(1:nrow(abalone), size = 0.7 * nrow(abalone))
train_set <- abalone[sample_index, ]
test_set <- abalone[-sample_index, ]

# 目标变量和特征
train_x <- train_set %>% select(-Rings)
train_y <- train_set$Rings

test_x <- test_set %>% select(-Rings)
test_y <- test_set$Rings

# 参数组合
sizes <- c(1, 3, 5, 8, 12, 20)
decays <- c(0, 0.01, 0.1, 1, 2)

# 初始化结果矩阵
sMSE_mat <- matrix(NA, nrow=length(sizes), ncol=length(decays), dimnames=list(sizes, decays))
MSPE_mat <- matrix(NA, nrow=length(sizes), ncol=length(decays), dimnames=list(sizes, decays))
ratio_mat <- matrix(NA, nrow=length(sizes), ncol=length(decays), dimnames=list(sizes, decays))

# 训练和评估函数
calc_mse <- function(actual, predicted) {
  mean((actual - predicted)^2)
}

for(i in seq_along(sizes)) {
  for(j in seq_along(decays)) {
    size <- sizes[i]
    decay <- decays[j]
    print(paste("Training size =", size, ", decay =", decay))
    
    # ... 原来的代码 ...
    
    # 多次训练取最优模型
    best_model <- NULL
    best_train_mse <- Inf
    for(k in 1:5) {
      model <- nnet(train_x, train_y, size=size, decay=decay, linout=TRUE, trace=FALSE, maxit=500)
      pred_train <- predict(model, train_x)
      train_mse <- calc_mse(train_y, pred_train)
      if(train_mse < best_train_mse) {
        best_train_mse <- train_mse
        best_model <- model
      }
    }
    
    # 计算训练误差
    sMSE_mat[i,j] <- best_train_mse
    
    # 计算测试误差
    pred_test <- predict(best_model, test_x)
    MSPE_mat[i,j] <- calc_mse(test_y, pred_test)
    
    # 计算比值，避免除以零
    if(sMSE_mat[i,j] != 0) {
      ratio_mat[i,j] <- MSPE_mat[i,j] / sMSE_mat[i,j]
    } else {
      ratio_mat[i,j] <- NA
    }
  }
}

# 输出结果
cat("In-sample sMSE:\n")
print(sMSE_mat)
cat("\nTest error MSPE:\n")
print(MSPE_mat)
cat("\nMSPE/sMSE ratio:\n")
print(ratio_mat)

# 返回结果以便进一步处理
list(sMSE=sMSE_mat, MSPE=MSPE_mat, ratio=ratio_mat)

