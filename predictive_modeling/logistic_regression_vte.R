# coding: utf-8 -*-
"
Created on 2022/02/20 15:46:19

@File -> logistic_regression_vte.R

@Author: luolei

@Email: dreisteine262@163.com

@Describe: VTE数据逻辑回归
"

library(rms)
library(ggplot2)

# ---- 数据 ----------------------------------------------------------------------------------------

dat <- read.csv("predictive_modeling/data/dat.csv", encoding = "UTF-8")

# 取部分字段构造数据集
dat <- dat[, c("性别", "损伤程度", "年龄", "BMI", "是否血栓", "ICU")]
colnames(dat) <- c("sex", "injury", "age", "BMI", "thrombus", "ICU")
sapply(dat, class)

# ---- 构建模型 -------------------------------------------------------------------------------------


f <- lrm(
    ICU ~ sex + injury + age + BMI + thrombus,
    data = dat
    )

# 画nomogram图时需要提前了解数据字段值分布范围
attach(dat)
ddist <- datadist(dat)
options(datadist="ddist")

nomo_graph <- nomogram(f, fun = plogis, fun.at = seq(0.2, 0.9, by = 0.1), funlabel = "prob. for ICU", lp = FALSE)

# 保存图片至本地
png("predictive_modeling/img/nomo_graph_vte.png")
plot(nomo_graph)
dev.off()








# library("rms")

# n <- 1000
# set.seed(17)

# age <- rnorm(n, 50, 10)
# blood.pressure <- rnorm(n, 120, 15)
# cholesterol <- rnorm(n, 200, 25)
# sex <- factor(sample(c("female", "male"), n, TRUE))

# # Specify population model for log odds that Y=1
# L <- .4 * (sex == "male") + .045 * (age - 50) + (log(cholesterol - 10) - 5.2) * (-2 * (sex == "female") + 2 * (sex == "male"))

# # Simulate binary y to have Prob(y=1) = 1/[1+exp(-L)]
# # y <- ifelse(runif(n) < plogis(L), 1, 0)
# y <- factor(sample(c(0, 1), n, TRUE))

# # 4、制作列线图。代码如下：
# ddist <- datadist(age, blood.pressure, cholesterol, sex)
# options(datadist = "ddist")

# f <- lrm(y ~ age + blood.pressure + cholesterol + sex)
# nom <- nomogram(f)
# # nom <- nomogram(f, fun=plogis, fun.at=c(.001,.01, .05, seq(.1,.9, by=.1), .95, .99, .999),lp=F, funlabel="最后的发病风险")

# plot(nom)
