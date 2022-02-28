# 预测建模

# ---- 1. 读取数据 -------------------------------------------------------------

source("case_vte_predictive_modeling/setting.R", encoding = "UTF-8")
dat <- read.csv("case_vte_predictive_modeling/data/data_modeling.csv", encoding = "UTF-8")

# 将其中非数值型变量类型转为数字factor型变量
for (col in modeling_cols) {
  if (col %in% numeric_cols) {
    dat[, col] <- as.numeric(dat[, col])
  }
  else {
    labels <- unique(as.factor(dat[, col]))
    dat[, col] <- as.factor(match(dat[, col], labels) - 1)  # 注意这里要减1, 否则结局指标值为[1, 2]而非[0, 1]
  }
}

# ---- 2. 数据集划分 -----------------------------------------------------------

sub_idxs <- sample(1 : nrow(dat), round(nrow(dat) * 2 / 3))
dat_train <- dat[sub_idxs, ]
dat_test <- dat[-sub_idxs, ]  # 这个-sub_idxs的用法有意思

# ---- 3. 模型训练 -------------------------------------------------------------

library(randomForest)
library(ROCR)  # 绘制ROC曲线, PR曲线等

model <- randomForest::randomForest(VTE ~ ., data = dat_train, ntree = 100)

predict_probs_and_labels <- function(f, dat) {  # 计算预测概率和标签
  y_probs_pred <- predict(f, type = "response", newdata = dat)  # TODO: 这里对于randomForest不适用
  y_labels_pred <- ifelse(y_probs_pred > 0.5, 1, 0)
  return(list(y_probs_pred, y_labels_pred))
}


preds.test <- predict_probs_and_labels(model, dat_test)
preds.test.probs <- preds.test[1]
preds.test.labels <- preds.test[2]

trues.test.labels <- dat_test$VTE

pred_obj <- prediction(preds.test.probs, trues.test.labels)  #首先实例化一个评估器对象
auc <- performance(pred_obj, "auc")@y.values
aucpr <- performance(pred_obj, "aucpr")@y.values

print(auc[[1]])
print(aucpr[[1]])

# ROC曲线
roc <- performance(pred_obj, "tpr", "fpr")
pr <- performance(pred_obj, "prec", "rec")

library(ggplot2)
library(ggpubr)

gg_df_roc <- data.frame(c(roc@x.values[[1]]), c(roc@y.values[[1]]))
colnames(gg_df_roc) <- c("x", "y")
gg_df_pr <- data.frame(c(pr@x.values[[1]]), c(pr@y.values[[1]]))
colnames(gg_df_pr) <- c("x", "y")

p1 <- ggplot(gg_df_roc, aes(x =x, y = y)) + geom_line() + theme(plot.margin = margin(2, .8, 0, .8, "cm"))
p2 <- ggplot(gg_df_pr, aes(x =x, y = y)) + geom_line() + theme(plot.margin = margin(2, .8, 0, .8, "cm"))

ggarrange(p1, p2, labels = c("ROC Curve", "PR Curve"), ncol = 2, nrow = 1)

