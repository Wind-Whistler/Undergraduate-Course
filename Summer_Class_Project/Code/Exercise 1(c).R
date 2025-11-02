library(mgcv)
library(dplyr)

set.seed(120401002)

# 读取数据
prostate <- read.csv("c:/Users/huawei/Desktop/R/Prostate.csv")
prostate$train <- as.logical(prostate$train)
train_data <- prostate %>% filter(train == TRUE)
test_data <- prostate %>% filter(train == FALSE)

# 将 svi 和 gleason 转换为因子
train_data$svi <- as.factor(train_data$svi)
train_data$gleason <- as.factor(train_data$gleason)

# 初始变量列表（去除 lbph）
vars <- c("lcavol", "lweight", "age", "svi", "lcp", "gleason", "pgg45")

# 定义函数根据变量列表拟合模型
fit_gam <- function(var_list, data) {
  formula_parts <- c()
  for (v in var_list) {
    if (v %in% c("svi", "gleason")) {
      formula_parts <- c(formula_parts, v)
    } else {
      formula_parts <- c(formula_parts, paste0("s(", v, ")"))
    }
  }
  formula_str <- paste("lpsa ~", paste(formula_parts, collapse = " + "))
  gam(as.formula(formula_str), data = data)
}

# 初始模型，找最不重要变量，替换为 lbph
full_model <- gam(lpsa ~ s(lcavol) + s(lweight) + s(age) + s(lcp) + s(pgg45) + svi + gleason, data = train_data)
summary_full <- summary(full_model)
# 增加检查确保 p.table 和 s.table 存在
param_pvals <- if (!is.null(summary_full$p.table)) summary_full$p.table[-1, 4] else numeric(0)
smooth_pvals <- if (!is.null(summary_full$s.table)) summary_full$s.table[, 4] else numeric(0)
all_pvals <- c(param_pvals, smooth_pvals)
if (length(all_pvals) > 0) {
  max_pval_var <- names(which.max(all_pvals))
} else {
  stop("初始模型中未获取到有效的 p 值")
}

# 第一步：用 lbph 替换掉最不重要的变量
initial_vars <- setdiff(vars, max_pval_var)
initial_vars <- c(initial_vars, "lbph")

# 手动逐步向后剔除函数
manual_backward_elimination <- function(starting_vars, data) {
  path <- list()
  bics <- c()
  dfs <- c()
  current_vars <- starting_vars
  
  while (length(current_vars) > 1) { # 修改条件以确保至少有两个变量
    cat("当前变量:", paste(current_vars, collapse = ", "), "\n")
    model <- fit_gam(current_vars, data)
    path[[length(path) + 1]] <- current_vars
    aic <- extractAIC(model, k = log(nrow(data))) # BIC
    bics <- c(bics, aic[2])
    dfs <- c(dfs, aic[1])
    
    summary_m <- summary(model)
    # 增加检查确保 p.table 和 s.table 存在
    param_p <- if (!is.null(summary_m$p.table)) summary_m$p.table[-1, 4] else numeric(0)
    smooth_p <- if (!is.null(summary_m$s.table)) summary_m$s.table[, 4] else numeric(0)
    all_p <- c(param_p, smooth_p)
    
    if (length(all_p) == 0) {
      cat("没有可移除的变量，退出循环\n")
      break
    }
    
    max_p_val <- max(all_p)
    if (length(current_vars) == 3)
    {
      max_p_var_names <- "svi"
    }else{
    max_p_var_names <- names(all_p)}
    if (length(max_p_var_names) > 0) {
      max_p_var <- max_p_var_names[which.max(all_p)]
      cat("最大 p 值变量:", max_p_var, "p 值:", max_p_val, "\n")
      max_p_var_clean <- gsub("[0-9]+$", "", max_p_var)
      if (grepl("^s\\(.+\\)$", max_p_var_clean)) {
        max_p_var_clean <- sub("^s\\((.+)\\)$", "\\1", max_p_var_clean)
      }
      if (!(max_p_var_clean %in% current_vars)) {
        cat("最大 p 值变量不在当前变量列表中，退出循环\n")
        break
      }
      current_vars <- setdiff(current_vars, max_p_var_clean)
    } else {
      cat("无法获取最大 p 值变量名，退出循环\n")
      break
    }
  }
  
  # 处理最后一个变量
  if (length(current_vars) == 1) {
    cat("当前变量:", paste(current_vars, collapse = ", "), "\n")
    model <- fit_gam(current_vars, data)
    path[[length(path) + 1]] <- current_vars
    aic <- extractAIC(model, k = log(nrow(data))) # BIC
    bics <- c(bics, aic[2])
    dfs <- c(dfs, aic[1])
  }
  
  list(path = path, bic = bics, df = dfs)
}

# 执行手动逐步剔除
result <- manual_backward_elimination(initial_vars, train_data)

# 找 BIC 最小的模型索引
best_idx <- which.min(result$bic)
best_vars <- result$path[[best_idx]]

# 拟合最佳模型
best_model <- fit_gam(best_vars, train_data)

# 计算测试集 MSPE
preds <- predict(best_model, newdata = test_data)
mspe <- mean((test_data$lpsa - preds)^2)

# 输出结果
cat("变量路径（每步变量）:\n")
for (i in seq_along(result$path)) {
  cat(paste0("Step ", i, ": ", paste(result$path[[i]], collapse = ", "), "\n"))
}
cat("\n对应有效自由度(DF):\n")
print(result$df)
cat("\n对应 BIC 值:\n")
print(result$bic)
cat("\n最佳模型变量:", paste(best_vars, collapse = ", "), "\n")
cat("最佳模型测试集 MSPE:", mspe, "\n")









