# 预测建模

library(ROCR)
library(glue)
library(ggplot)

# ---- 1. 读取数据 -------------------------------------------------------------

source("case_vte_predictive_modeling/setting.R", encoding = "UTF-8")
dat <-
  read.csv("case_vte_predictive_modeling/data/data_modeling.csv",
           encoding = "UTF-8")

# 将其中非数值型变量类型转为数字factor型变量
dat <- set_value_types(dat)

# ---- 2. 数据集划分 -----------------------------------------------------------

set.seed(1)
sub_idxs <- sample(1:nrow(dat), round(nrow(dat) * 2 / 3))
dat_train <- dat[sub_idxs,]
dat_test <- dat[-sub_idxs,]  # 这个-sub_idxs的用法有意思

# ---- 3. 模型训练 -------------------------------------------------------------

library(randomForest)
library(ROCR)  # 绘制ROC曲线, PR曲线等

model <-
  randomForest::randomForest(VTE ~ ., data = dat_train, ntree = 1500)

# ---- 4. 变量重要性 -----------------------------------------------------------

p <- varImpPlot(model, main = "Variable Importance")
ggsave(
  p,
  filename = "case_vte_predictive_modeling/img/rf_interpret.png",
  width = 4,
  height = 4,
  dpi = 300
)

# ---- 5. 绘制ROC曲线和AUC值 ---------------------------------------------------

# 训练集
y_pred.train.probs <-
  predict(model, type = "prob", newdata = dat_train)[, 2]
y_pred.train.labels <- ifelse(y_pred.train.probs > 0.5, 1, 0)
y_true.train.labels <- dat_train$VTE

rocr_obj.train <-
  prediction(y_pred.train.probs, y_true.train.labels)

auc.train <- performance(rocr_obj.train, "auc")@y.values[[1]]
roc.train <- performance(rocr_obj.train, "tpr", "fpr")

plot(
  roc.train@x.values[[1]],
  roc.train@y.values[[1]],
  type = "l",
  ylim = c(0.0, 1.0),
  xlab = "TPR",
  ylab = "FPR"
)

# 测试集
y_pred.test.probs <-
  predict(model, type = "prob", newdata = dat_test)[, 2]
y_pred.test.labels <- ifelse(y_pred.test.probs > 0.5, 1, 0)
y_true.test.labels <- dat_test$VTE

rocr_obj.test <- prediction(y_pred.test.probs, y_true.test.labels)

auc.test <- performance(rocr_obj.test, "auc")@y.values[[1]]
roc.test <- performance(rocr_obj.test, "tpr", "fpr")

plot(
  roc.test@x.values[[1]],
  roc.test@y.values[[1]],
  type = "l",
  ylim = c(0.0, 1.0),
  xlab = "TPR",
  ylab = "FPR"
)

# ---- 6. 绘制PR曲线 -----------------------------------------------------------

# 测试集
aucpr.test <- performance(rocr_obj.test, "aucpr")@y.values[[1]]

pr.test <- performance(rocr_obj.test, "prec", "rec")
plot(
  pr.test@x.values[[1]],
  pr.test@y.values[[1]],
  type = "l",
  ylim = c(0.0, 1.0),
  xlab = "Precision",
  ylab = "Recall"
)

# ---- 7. 保存结果 -------------------------------------------------------------

roc_df <-
  data.frame(x = roc.test@x.values[[1]], y = roc.test@y.values[[1]])
pr_df <-
  data.frame(x = pr.test@x.values[[1]], y = pr.test@y.values[[1]])

write.csv(roc_df,
          "case_vte_predictive_modeling/file/roc_curve_rf.csv",
          row.names = FALSE)
write.csv(pr_df,
          "case_vte_predictive_modeling/file/pr_curve_rf.csv",
          row.names = FALSE)






