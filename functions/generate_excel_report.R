generate_excel_report <- function(data, var_info) {
  # Load the required library
  library(openxlsx)
  
  # Create a new Excel workbook
  wb <- createWorkbook()
  
  # Add a worksheet
  addWorksheet(wb, "Data")
  
  # Write column names in the first row as headers
  writeData(wb, sheet = 1, x = names(data), startRow = 1, startCol = 1)
  
  # Loop through all variables in the dataset
  for (i in seq_along(names(data))) {
    var_name <- names(data)[i]
    
    # Define the hyperlink for the variable
    pdf_link <- paste0(
      "https://github.com/AntoineSoetewey/BeammODALON/blob/main/projet4%20-%20Variables%20descriptions/reports/PDF/report_", 
      var_name, 
      ".pdf"
    )
    
    # Extract the short description from var_info for the selected variable
    short_desc <- var_info$Short_description[var_info$Variable == var_name]
    
    # Default description if not found
    if (length(short_desc) == 0) {
      short_desc <- "Description not available"
    }
    
    # Ensure short_desc is a character vector
    short_desc <- as.character(short_desc)
    
    # Excel formula for hyperlink
    hyperlink_formula <- paste0('HYPERLINK("', pdf_link, '", "', var_name, '")')
    
    # Write the hyperlink in the first row (header)
    writeFormula(wb, sheet = 1, x = hyperlink_formula, startCol = i, startRow = 1)
    
    # Add the comment (tooltip) for the variable in the first row (header)
    comment <- createComment(comment = short_desc, author = "Info")
    writeComment(wb, sheet = 1, col = i, row = 1, comment = comment)
  }
  
  # Write the actual data starting from row 2
  writeData(wb, sheet = 1, x = data, startRow = 2, colNames = FALSE)
  
  # Define the output file path
  file_name <- "reports/Excel/all_variables_report.xlsx"
  
  # Save the workbook
  saveWorkbook(wb, file_name, overwrite = TRUE)
}