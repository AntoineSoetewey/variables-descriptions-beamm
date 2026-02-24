set.seed(42)
# packages
library(tidyr)
library(dplyr)
library(readxl)

# import descriptions
# dat_descriptions <- read.csv("data/variables_descriptions_SILC.csv")
dat_descriptions <- read_excel("data/silc_variable_descriptions_all.xlsx")

# generate a dataframe called dat_raw with 1000 rows, with some columns being numeric other being factors
n <- 1000

# Create a matrix of random numeric data
dat_raw <- matrix(
  data = rnorm(n * length(dat_descriptions$Variable)),
  ncol = length(dat_descriptions$Variable),
  nrow = n
) |> 
  as.data.frame()

# Assign column names
names(dat_raw) <- dat_descriptions$Variable

# Specify which columns should be factors (for example, columns 2, 4, 6 and 10)
factor_columns <- c(2, 4, 6)

# Round the absolute values in the specified columns and then convert them to factors
dat_raw[factor_columns] <- lapply(dat_raw[factor_columns], function(x) as.factor(round(abs(x))))

# Generate a pdf report for each variable of the dataset
source("functions/generate_pdf_report.R")
generate_pdf_report(data = dat_raw, 
                    var_info = dat_descriptions, 
                    template_path = "template.Rmd")

# Generate an Excel report with hyperlink to the PDF report and tooltip for each variable
source("functions/generate_excel_report.R")
generate_excel_report(data = dat_raw, 
                      var_info = dat_descriptions)
