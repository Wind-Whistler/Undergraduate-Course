library(caret)
library(MASS)
library(dplyr)
library(nnet)  # 确保加载nnet包

# 读取数据
data <- read.csv("c:/Users/huawei/Desktop/R/wheat.csv")

# 选择特征和标签
features <- data %>% select(density, hardness, size, weight, moisture)
labels <- as.factor(data$type)

# 合并特征和标签
full_data <- cbind(features, type = labels)

# 设置随机种子
set.seed(123)

# 创建训练集索引（70%）
trainIndex <- createDataPartition(full_data$type, p = 0.7, list = FALSE)
train_data <- full_data[trainIndex, ]

# 剩余数据用于测试和验证（30%）
remaining_data <- full_data[-trainIndex, ]

# 在剩余数据中划分测试集和验证集（各15%）
testIndex <- createDataPartition(remaining_data$type, p = 0.5, list = FALSE)
test_data <- remaining_data[testIndex, ]
validation_data <- remaining_data[-testIndex, ]

# 逻辑回归模型
logistic_model <- multinom(type ~ ., data = train_data, trace = FALSE)
logistic_pred <- predict(logistic_model, test_data)
logistic_acc <- mean(logistic_pred == test_data$type)

# LDA模型
lda_model <- lda(type ~ ., data = train_data)
lda_pred <- predict(lda_model, test_data)$class
lda_acc <- mean(lda_pred == test_data$type)

# QDA模型
qda_model <- qda(type ~ ., data = train_data)
qda_pred <- predict(qda_model, test_data)$class
qda_acc <- mean(qda_pred == test_data$type)

# 输出测试集准确率
cat(sprintf("测试集准确率:\n"))
cat(sprintf("逻辑回归: %.4f\n", logistic_acc))
cat(sprintf("LDA: %.4f\n", lda_acc))
cat(sprintf("QDA: %.4f\n", qda_acc))

# 验证集准确率
logistic_val_pred <- predict(logistic_model, validation_data)
logistic_val_acc <- mean(logistic_val_pred == validation_data$type)
lda_val_pred <- predict(lda_model, validation_data)$class
lda_val_acc <- mean(lda_val_pred == validation_data$type)
qda_val_pred <- predict(qda_model, validation_data)$class
qda_val_acc <- mean(qda_val_pred == validation_data$type)

cat(sprintf("\n验证集准确率:\n"))
cat(sprintf("逻辑回归: %.4f\n", logistic_val_acc))
cat(sprintf("LDA: %.4f\n", lda_val_acc))
cat(sprintf("QDA: %.4f\n", qda_val_acc))