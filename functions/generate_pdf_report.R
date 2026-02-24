generate_pdf_report <- function(data, var_info, template_path) {
  library(rmarkdown)
  library(ggplot2)
  library(pander)
  
  # Create the reports/PDF directory if it doesn't exist
  reports_dir <- normalizePath("reports/PDF", mustWork = FALSE)
  if (!dir.exists(reports_dir)) {
    dir.create(reports_dir, recursive = TRUE)
  }
  
  # Check that var_info contains the required columns
  if (!all(c("Variable", "Short_description", "Long_description") %in% colnames(var_info))) {
    stop("var_info must contain the columns 'Variable', 'Short_description', 'Long_description' and 'Page'")
  }
  
  message("Generating PDF report...")
  
  # For each variable, generate a report
  for (var in var_info$Variable) {
    if (var %in% colnames(data)) {
      short_desc <- var_info$Short_description[var_info$Variable == var]
      long_desc <- var_info$Long_description[var_info$Variable == var]
      page <- var_info$Page[var_info$Variable == var]
      url <- paste0("https://github.com/AntoineSoetewey/BeammODALON/blob/main/projet4%20-%20Variables%20descriptions/documentation/SILC/single_pdf/SILC-", page, ".pdf")
      
      # Define the output file name based on the variable name
      output_file <- file.path(reports_dir, paste0("report_", var, ".pdf"))
      
      # Render the Rmd file with dynamic parameters
      tryCatch({
        rmarkdown::render(template_path, 
                          output_file = output_file, 
                          params = list(variable_name = var,
                                        short_description = short_desc,
                                        long_description = long_desc,
                                        data = data,
                                        url = url))
        message("Report successfully generated: ", output_file)
      }, error = function(e) {
        message("Error during report generation for ", var, ": ", e$message)
      })
    } else {
      message(paste("Variable not found in data:", var))
    }
  }
}
