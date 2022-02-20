# coding: utf-8 -*-
"
Created on 2022/02/11 14:23:57

@File -> step_0_data_cleansing.R

@Author: luolei

@Email: dreisteine262@163.com

@Describe: 神经VTE建模: 数据清洗
"

# ---- 1. 在R中打开Excel数据表, 转为R的数据框格式. ----------------------------------------------------

# 载入Excel表格(注意指定编码格式)
library(xlsx)
dat <- read.xlsx("basic_data_cleansing_&_visualization/data/neural_vte_data.xlsx", sheetName = "Sheet1", encoding = "UTF-8")

# 查看数据框中每列数据类型(字符character, 数值numerical等).
dtypes <- sapply(dat, class)
dtypes <- data.frame(dtypes)

# ---- 2. 数据清洗 ----------------------------------------------------------------------------------

# 查看各列数据类型与实际是否一致
head(dtypes)

# 对比实际Excel数据, 发现以下待处理问题:
# 1. 时间字段处理: \"就诊时间\", \"手术时间\", \"死亡时间\", \"多普雷超声时间1\", \"气压式四肢血液循环促进治疗\"等字
#    段被误记为character类型, 实为date类型;
# 2. 字段值转换为数字: \"体重等级\", \"麻醉分级（ASA）\", \"抗凝治疗\"等字段需要进行字段值转换, 赋予数值标签;
# 3. 复杂字段信息格式化提取: \"主要诊断\", \"合并症\"等字段需要更详细的信息提取和格式化;
# 4. 字段值类型标准化: 其他所有字段均需要转为数值类型, 其中, 类别型字段需要转为integer类型, 而数值型字段需要转为double类型
# 5. 删除缺失率高的字段: 字段缺失率高, 不应用于分析建模

# 对表中各字段的类型整理于setting.R中, 下面直接引用.
source("setting.R", encoding = "UTF-8")

# ---- 2.1 时间字段处理 ----

# 注意：R在导入Excel数据时会将日期转为数字, 需要重新转为日期
# 首先查看读入数据中\"dat\$就诊时间\"的数据类型
print(typeof(dat$就诊时间))

# 可见"dat\$就诊时间"的数据类型为字符character. 字符对应的整数值表示从1899年12月30后开始计的天数.
# 为了将"dat\$就诊时间"重新转为R中的日期Date类型, 需要先使用as.integer将其转为整数, 再使用as.Date转为日期.
dat$就诊时间 <- as.Date(as.integer(dat$就诊时间), origin="1899/12/30", optional = FALSE)

# 同理, 对其他时间字段进行处理.
dat$手术时间 <- as.Date(as.integer(dat$手术时间), origin="1899/12/30", optional = FALSE)

# 字段数据格式和值都有问题, 需要手动处理Excel表的格式
# dat$多普勒超声时间1 <- as.Date(as.integer(dat$多普雷超声时间1), origin="1899/12/30", optional = FALSE)
# dat$死亡时间 <- as.Date(as.integer(dat$死亡时间), origin="1899/12/30", optional = FALSE)
# dat$气压式四肢血液循环促进治疗 <- as.Date(as.integer(dat$气压式四肢血液循环促进治疗), origin="1899/12/30", optional = FALSE)

# ---- 2.2 字段值统一转为数字 ----

# 将数据框中"体重等级", "麻醉分级（ASA）"等字段值转为数字表示
# 使用match函数将类别字段值转换为数字 
for (var in c("体重等级", "麻醉分级.ASA.")) {
  labels <- unique(dat[, c(var)])
  cat("\n字段[", var, "]的标签: ", labels)
  dat[, c(var)] <- match(dat[, c(var)], labels)
}
print("\n字段值转换为数字完毕")

# ---- 2.3 复杂字段信息格式化提取 ----

# 该步需要大量的专业知识, 跳过.

# ---- 2.4 字段值类型标准化 ----

# 将类别型字段统一转为integer, 将数值型字段统一转为double
# 注意: R的dataframe不识别"》", "---"等中文标点, 都统一转为了英文句号"."
for (col in names(dat)) {
    if (col %in% categoric_cols) {
        dat[, col] <- as.integer(dat[, col])
    }
    else if (col %in% numeric_cols) {
        dat[, col] <- as.double(dat[, col])
    }
    else {}
}

# ---- 2.5 选出用于分析和建模的字段 ----

dat <- dat[c(categoric_cols, numeric_cols)]

# 删除缺失率高的字段
# 分析数据各字段缺失值, 异常值等, 筛选出高质量的用于后续分析建模的字段
# 使用pastecs包分析结果中的nbr.na表示各字段中缺失值NA的数量

library(pastecs)
desc_table <- stat.desc(dat, basic = TRUE, desc = TRUE, norm = FALSE)

# 如果仅选择缺失率小于10%的字段, 则有:
sprintf("候选字段数: %d", length(names(dat)))

cols2keep <- c()  # 初始化待选择字段序列
for (col in names(dat)) {
  if (desc_table["nbr.na", c(col)] < (length(desc_table) * 0.1)) {
    cols2keep <- c(cols2keep, col)  # 满足缺失率限制, 则将当前字段添加进选择序列中
  }
}

sprintf("选中字段数: %d", length(cols2keep))
dat <- dat[, cols2keep]

# ---- 3. 数据保存至本地 ----------------------------------------------------------------------------

write.csv(dat, "data/dat.csv", fileEncoding = "UTF-8", row.names = FALSE)  # row.names=FALSE, 干掉行index列
