# 对不同模型预测效果进行对比

library(glue)
library(ggplot2)

color_map <- list("red", "blue", "black")
names(color_map) <- c("logr", "poisson", "rf")

model_names <- c("logr", "poisson", "rf")

# ---- 1. 对比PR曲线 -----------------------------------------------------------

pr_curves <- c()
for (name in model_names) {
  df <-
    read.csv(glue("case_vte_predictive_modeling/file/pr_curve_{name}.csv"))
  df$model <- name
  pr_curves <- rbind(pr_curves, df)
}

p.1 <- ggplot(pr_curves, aes(x = x, y = y, color = model)) +
  geom_line(size = 1) +
  # theme_bw() +
  theme(legend.position = "right",
        # plot.margin = unit(c(2, 20, 2, 2), "cm"),
        plot.tag = element_text(vjust = 2, size = 50, face = "bold")) +
  labs(title = "Comparison of PR Curves") +
  xlab("Precision") +
  ylab("Recall")

# ---- 2. 对比ROC曲线 -----------------------------------------------------------

roc_curves <- c()
for (name in model_names) {
  df <-
    read.csv(glue("case_vte_predictive_modeling/file/roc_curve_{name}.csv"))
  df$model <- name
  roc_curves <- rbind(roc_curves, df)
}

p.2 <- ggplot(roc_curves, aes(x = x, y = y, color = model)) +
  geom_line(size = 1) +
  # theme_bw() +
  theme(legend.position = "right",
        # plot.margin = unit(c(2, 20, 2, 2), "cm"),
        plot.tag = element_text(vjust = 2, size = 50, face = "bold")) +
  labs(title = "Comparison of ROC Curves") +
  xlab("TPR") +
  ylab("FPR")

# ---- 3. 整合画图 -------------------------------------------------------------

library(patchwork)  # 拼图

nrow <- 1
ncol <- 2

p.total <-
  p.1 + plot_layout(nrow = nrow,
                    ncol = ncol,
                    tag_level = "new")
p.total <-
  p.total + p.2 + plot_layout(nrow = nrow,
                              ncol = ncol,
                              tag_level = "new") + theme(plot.tag = element_text(size = rel(1)))

# 保存图片
ggsave(
  p.total,
  filename = "case_vte_predictive_modeling/img/pr_compar.png",
  width = 8,
  height = 4,
  dpi = 300
)
