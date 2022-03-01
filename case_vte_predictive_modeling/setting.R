# 原始数据文件
dat <- read.csv("case_vte_predictive_modeling/data/data.csv", encoding = "UTF-8")

# 字段定义
unused_cols <- c("INPATIENT_ID")
numeric_cols <- c("AGE", "ISS", "CAPRINI_SCORE", "T", "P", "R", "MBP", "SHOCK_INDEX", "HEIGHT", "WEIGHT", "BMI", "RBC", "HGB", "PLT", "WBC", "ALB", "CRE", "UA", "AST", "ALT", "GLU", "TG", "CHO", "CA", "MG", "LDL", "NA.", "K", "CL", "GFR", "PT", "FIB", "DD", "CK", "INR")
categoric_cols <- setdiff(names(dat), union(numeric_cols, unused_cols))
modeling_cols <- union(numeric_cols, categoric_cols)

# 函数
set_value_types <- function(dat) {
  for (col in modeling_cols) {
    if (col %in% numeric_cols) {
      dat[, col] <- as.numeric(dat[, col])
    }
    else {
      labels <- unique(as.factor(dat[, col]))
      dat[, col] <- as.factor(match(dat[, col], labels) - 1)  # 注意这里要减1, 否则结局指标值为[1, 2]而非[0, 1]
    }
  }
  return(dat)
}