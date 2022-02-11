# coding: utf-8 -*-
"
Created on 2022/02/11 15:33:34

@File -> step_2_parwise_comparision.R

@Author: luolei

@Email: dreisteine262@163.com

@Describe: 变量之间的对比画图
"

# ---- 载入数据并定义结局变量 ------------------------------------------------------------------------

source("setting.R", encoding = "UTF-8")
dat <- read.csv("data/dat.csv", encoding = "UTF-8")
cols <- names(dat)
y_col <- "ICU"  # 只是为了举例

# ---- 一对变量之间的分析 ----------------------------------------------------------------------------

library(ggplot2)
library(tidyverse)

# 定义函数
draw_percent_bar_compar <- function(dat, x_col, y_col) {  # 两分类变量间的柱状百分比对比图
    # 取出数据建表
    d <- dat[, c(x_col, y_col)]
    colnames(d) <- c("x", "y")
    d[, "x"] <- as.character(d[, "x"])
    d[, "y"] <- as.character(d[, "y"])
    d[, "loc"] <- d[, "x"]

    # 对数据进行分组统计
    # 将loc按照(x, y)分组, 统计每组的样本个数length
    # FUNC可以设为: sum, length, mean, quantile等
    # ref: https://zhuanlan.zhihu.com/p/367417906
    d_grouped <- aggregate(loc ~ x + y, data = d, FUN = length)

    # 绘制柱状百分比图
    options(repr.plot.width=1, repr.plot.height=1)
    p <- ggplot(d_grouped, aes(x = x, y = loc, fill = y)) + 
    geom_bar(position = "fill", stat = "identity") +
    scale_y_continuous(labels = scales::percent) +  # 这一步将纵坐标变为百分比
    labs(x = x_col, y = y_col) +
    theme_light()

    return(p)
}

draw_box_compar <- function(dat, x_col, y_col) {  # 连续变量X和分类变量Y的箱型对比图
    # 取出数据建表
    d <- dat[, c(x_col, y_col)]
    colnames(d) <- c("x", "y")
    d[, "x"] <- as.double(d[, "x"])
    d[, "y"] <- as.character(d[, "y"])

    p <- ggplot(d, aes(x = y, y = x)) + 
    geom_boxplot() + 
    theme_light() + 
    labs(x = y_col, y = x_col)

    return(p)

}

# 测试函数
x_col <- cols[1]  # 是分类变量
draw_percent_bar_compar(dat, x_col, y_col)

x_col <- cols[length(cols)]  # 是连续变量
draw_box_compar(dat, x_col, y_col)

# ---- 多个变量与结局变量之间的分布关系对比图 ---------------------------------------------------------
# TODO



