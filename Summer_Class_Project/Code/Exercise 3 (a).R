library(nnet)
library(caret)
library(dplyr)

# 读取数据
data <- read.csv("c:/Users/huawei/Desktop/R/wheat.csv")

# 选择特征和标签
features <- data %>% select(density, hardness, size, weight, moisture)
labels <- as.factor(data$type)

# 归一化特征
normalize <- function(x) {(x - min(x)) / (max(x) - min(x))}
features_norm <- as.data.frame(lapply(features, normalize))

# 合并特征和标签
nn_data <- cbind(features_norm, type = labels)

# 第一步：将数据划分为训练集（含验证集）和测试集，比例为85:15
set.seed(123)
trainIndex <- createDataPartition(nn_data$type, p = 0.85, list = FALSE)
train_validation_data <- nn_data[trainIndex, ]
test_data <- nn_data[-trainIndex, ]

# 第二步：从训练集中划分出验证集，使得最终比例为70:15:15
set.seed(456)
validationIndex <- createDataPartition(train_validation_data$type, p = 0.8235, list = FALSE) # 0.8235 * 0.85 ≈ 0.7
train_data <- train_validation_data[validationIndex, ]
validation_data <- train_validation_data[-validationIndex, ]

# 定义更多参数组合
hidden_layers_list <- c(6, 7, 8, 9, 10, 11)
decay_list <- c(0.03, 0.04, 0.05, 0.06, 0.07)

# 记录结果
results <- data.frame(hidden_layers = character(), decay = numeric(), train_error = numeric(), validation_error = numeric(), test_error = numeric(), stringsAsFactors = FALSE)

# 开始遍历参数组合
for (hl in hidden_layers_list) {
  for (decay_val in decay_list) {
    best_train_error <- Inf
    best_validation_error <- Inf
    best_test_error <- Inf
    
    cat(paste0("【开始训练】隐藏层大小 = ", hl, ", decay = ", decay_val, "\n"))
    
    for (i in 1:10) {
      cat(paste0("  ├─ 第", i, "/10次训练...\n"))
      
      # 设置随机种子以保证可重复性
      set.seed(i)
      
      # 训练模型
      nn <- nnet(type ~ ., data = train_data, size = hl, decay = decay_val, maxit = 1000, trace = FALSE)
      
      # 预测与误差计算
      train_pred <- predict(nn, train_data[, -ncol(train_data)], type = "class")
      train_error <- mean(train_pred != train_data$type)
      
      validation_pred <- predict(nn, validation_data[, -ncol(validation_data)], type = "class")
      validation_error <- mean(validation_pred != validation_data$type)
      
      test_pred <- predict(nn, test_data[, -ncol(test_data)], type = "class")
      test_error <- mean(test_pred != test_data$type)
      
      if (train_error < best_train_error) {
        best_train_error <- train_error
        best_validation_error <- validation_error
        best_test_error <- test_error
      }
    }
    
    cat(paste0("  最佳训练误差：", round(best_train_error, 4), 
               "，最佳验证误差：", round(best_validation_error, 4),
               "，最佳测试误差：", round(best_test_error, 4), "\n\n"))
    
    # 保存结果
    results <- rbind(results, 
                     data.frame(hidden_layers = as.character(hl),
                                decay = decay_val,
                                train_error = best_train_error,
                                validation_error = best_validation_error,
                                test_error = best_test_error))
  }
}

# 打印最终结果
print(results)