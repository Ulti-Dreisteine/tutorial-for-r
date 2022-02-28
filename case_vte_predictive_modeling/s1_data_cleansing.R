# VTE数据处理

# ---- 1. 读取数据 -------------------------------------------------------------

dat <- read.csv("case_vte_predictive_modeling/data/data.csv", encoding = "UTF-8")

# 查看变量数值类型
data.frame(sapply(dat, class))

# ---- 2. 指定字段类型 ---------------------------------------------------------

source("case_vte_predictive_modeling/setting.R", encoding = "UTF-8")

# 只选中其中的建模字段
dat <- dat[, modeling_cols]

# ---- 3. 字段值转换 -----------------------------------------------------------

# 将其中非数值型变量类型转为数字factor型变量
for (col in modeling_cols) {
  if (col %in% numeric_cols) {
    dat[, col] <- as.numeric(dat[, col])
  }
  else {
    labels <- unique(as.factor(dat[, col]))
    dat[, col] <- match(dat[, col], labels) - 1  # 注意这里要减1, 否则结局指标值为[1, 2]而非[0, 1]
  }
}

# 数据描述统计
library(pastecs)
library(glue)
library(tidyr)

desc_table.1 <- stat.desc(dat, basic = TRUE, desc = TRUE, norm = FALSE)

high_miss_cols <- c()
for (col in modeling_cols) {
  if (desc_table["nbr.na", col] > 0.0 * length(dat[, 1])) {
    high_miss_cols <- c(high_miss_cols, col)
    print(glue("注意: {col}的缺失率{desc_table[\"nbr.na\", col]}超过阈值"))
  }
}

# 缺失值填补
for (col in high_miss_cols) {
  dat[, "tmp"] <- dat[, col]  # 设定一个临时列
  if (col %in% numeric_cols) {  # 均值填充
    value2fill <- mean(dat[, col], na.rm = TRUE)
  }
  else {  # 用众数填补
    value2fill <- names(which.max(table(dat[, col])))  
  }
  dat <- replace_na(dat, list(tmp = value2fill))
  dat[, col] <- dat[, "tmp"]
}

dat <- dat[, !colnames(dat) %in% c("tmp")]
desc_table.2 <- stat.desc(dat, basic = TRUE, desc = TRUE, norm = FALSE)

# ---- 4. 保存数据 -------------------------------------------------------------

write.csv(dat, "case_vte_predictive_modeling/data/data_modeling.csv", fileEncoding = "UTF-8", row.names = FALSE)  # row.names=FALSE, 干掉行index列

# ---- 5. 数据描述性统计画图 ---------------------------------------------------

library(ggplot2)

draw_bar <- function(dat, col) {  # 从数据中取某个字段的数据绘制柱状图
  idx <- which(names(dat) == col)
  
  # 统计各类标签和对应的频数
  freq_table <- data.frame(table(dat[, col]))
  colnames(freq_table) <- c("var", "freq")
  
  # 指定x和y的数据格式, ggplot才能正确出图.
  freq_table[, "var"] <- as.character(freq_table[, "var"])
  freq_table[, "freq"] <- as.double(freq_table[, "freq"])
  
  p <- ggplot(freq_table, aes(x=var, y=freq)) +  # 数据
    geom_bar(position="dodge", stat="identity") +  # 柱状图
    labs(title = col)  # 标题
  
  return(p)
}

draw_hist <- function(dat, col) {  # 从数据中取某个字段的数据绘制频数分布图
  idx <- which(names(dat) == col)
  
  df <- dat[col]
  colnames(df) <- c("var")
  
  p <- ggplot(df, aes(x = var)) +
    geom_histogram(position = "identity", bins = 30) +
    labs(title = col)  # 标题
  
  return(p)
}

library(patchwork)  # 拼图 

cols <- names(dat)

for (col in cols) {
  if (col %in% categoric_cols) {
    p <- draw_bar(dat, col)
  }
  else {
    p <- draw_hist(dat, col)
  }
  
  nrow <- 10
  ncol <- 7
  if (col == cols[1]) {
    graph <- p + plot_layout(nrow = nrow, ncol = ncol, tag_level = "new") +
      # plot_annotation(tag_levels = "a") +  # 子图不再加标记, 因为有title了
      theme(plot.tag = element_text(size = rel(0.2)))
  }
  else {
    graph <- graph + p + plot_layout(nrow = nrow, ncol = ncol, tag_level = "new") + 
      # plot_annotation(tag_levels = "a") + 
      theme(plot.tag = element_text(size = rel(0.2)))
  }
}

ggsave(graph, filename = "case_vte_predictive_modeling/img/graph.png", width = 10, height = 24, dpi = 300)

