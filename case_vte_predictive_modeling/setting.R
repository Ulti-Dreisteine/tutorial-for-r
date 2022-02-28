dat <- read.csv("case_vte_predictive_modeling/data/data.csv", encoding = "UTF-8")

unused_cols <- c("INPATIENT_ID")

numeric_cols <- c("AGE", "ISS", "CAPRINI_SCORE", "T", "P", "R", "MBP", "SHOCK_INDEX", "HEIGHT", "WEIGHT", "BMI", "RBC", "HGB", "PLT", "WBC", "ALB", "CRE", "UA", "AST", "ALT", "GLU", "TG", "CHO", "CA", "MG", "LDL", "NA.", "K", "CL", "GFR", "PT", "FIB", "DD", "CK", "INR")

categoric_cols <- setdiff(names(dat), union(numeric_cols, unused_cols))

modeling_cols <- union(numeric_cols, categoric_cols)
