# coding: utf-8 -*-
"
Created on 2022/02/20 14:09:46

@File -> logistic_regression.R

@Author: luolei

@Email: dreisteine262@163.com

@Describe: 逻辑回归分类
"

library(ggplot2)
library(rms)
library(colorspace)

dat <- datasets::iris


# ---- 数据可视化 -----------------------------------------------------------------------------------

species_color <- dat[, 5]
species_color <- rainbow_hcl(3)[as.numeric(species_color)]
species_labels <- unique(dat[, 5])

pairs(
    dat[, 1:4],
    lower.panel = NULL,
    col = species_color, # 使用参数"col"调整颜色
    cex.labels = 1.5, # 对角线上标签字体大小
    pch = 1, # 控制散点形状, 1：18中每个整数值对应一种形状
    cex = 2 # 控制散点大小
)

# 添加图例
par(xpd = TRUE)
legend(
    x = 0.05,
    y = 0.4,
    cex = 1.5,
    legend = species_labels,
    pch = 1,
    col = unique(species_color),
    bty = "n",
)

# ---- 数据预处理 -----------------------------------------------------------------------------------

# 1. 结局变量设置为二分类
dat$Species <- ifelse(dat$Species == "setosa", 1, 0)

# 2. 对预测模型数据进行统计描述
attach(dat)  # attach后可以使得后面的代码"认识"数据中的字段
dd <- datadist(dat)
options(datadist = "dd")

# ---- 模型构建 -------------------------------------------------------------------------------------

f <- lrm(
    Species ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width,
    data = dat,
    )

# ---- 统计图表绘制 ---------------------------------------------------------------------------------

nomo_graph <- nomogram(f, fun = plogis, funlabel = "prob. for setosa", lp = FALSE)

# 保存图片至本地
png("predictive_modeling/img/nomo_graph_iris.png")
plot(nomo_graph)
dev.off()

