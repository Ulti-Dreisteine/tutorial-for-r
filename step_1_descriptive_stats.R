# coding: utf-8 -*-
"
Created on 2022/02/11 15:01:32

@File -> step_1_descriptive_stats.R

@Author: luolei

@Email: dreisteine262@163.com

@Describe: 数据描述性统计
"


# ---- 载入数据和参数 -------------------------------------------------------------------------------

source("setting.R", encoding = "UTF-8") # 从该脚本中引入事先写好的参数, 避免代码重复
dat <- read.csv("data/dat.csv", encoding = "UTF-8") # 注意设置好编码


# ---- 单字段数据分布图 ------------------------------------------------------------------------------

# 定义函数
# 写成函数提升代码可读性可复用性
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
      labs(title = paste("variable", idx, sep = " "))  # 标题

    return(p)
}

draw_hist <- function(dat, col) {  # 从数据中取某个字段的数据绘制频数分布图
    idx <- which(names(dat) == col)

    df <- dat[col]
    colnames(df) <- c("var")

    p <- ggplot(df, aes(x = var)) +
      geom_histogram(position = "identity", binwidth = 1.0) +
      labs(title = paste("variable", idx, sep = " "))  # 标题

    return(p)
}

# 测试函数
draw_bar(dat, categoric_cols[1])
draw_hist(dat, numeric_cols[1])

# ---- 多字段数据分布整合画图 ------------------------------------------------------------------------

library(patchwork)  # 拼图 

cols <- names(dat)

for (col in cols) {
    if (col %in% categoric_cols) {
        p <- draw_bar(dat, col)
    }
    else {
        p <- draw_hist(dat, col)
    }

    nrow <- 12
    ncol <- 5
    if (col == cols[1]) {
        graph <- p + plot_layout(nrow = nrow, ncol = ncol, tag_level = "new") +
        # plot_annotation(tag_levels = "a") +  # 子图不再加标记, 因为有title了
        theme(plot.tag = element_text(size = rel(1)))
    }
    else {
        graph <- graph + p + plot_layout(nrow = nrow, ncol = ncol, tag_level = "new") + 
        # plot_annotation(tag_levels = "a") + 
        theme(plot.tag = element_text(size = rel(1)))
    }
}

# 保存图片
ggsave(graph, filename = "img/graph.png", width = 10, height = 24, dpi = 300)

