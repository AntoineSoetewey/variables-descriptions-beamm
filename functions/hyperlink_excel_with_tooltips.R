# Installer le package si nécessaire
# install.packages("openxlsx")

# Charger la librairie
library(openxlsx)

# Créer un fichier Excel
wb <- createWorkbook()

# Ajouter une feuille
addWorksheet(wb, "Iris Data")

# Définir les liens et les tooltips pour chaque colonne
column_links <- c(
  'HYPERLINK("https://en.wikipedia.org/wiki/Sepal_length", "Sepal.Length")',
  'HYPERLINK("https://en.wikipedia.org/wiki/Sepal_width", "Sepal.Width")',
  'HYPERLINK("https://en.wikipedia.org/wiki/Petal_length", "Petal.Length")',
  'HYPERLINK("https://en.wikipedia.org/wiki/Petal_width", "Petal.Width")',
  'HYPERLINK("https://en.wikipedia.org/wiki/Iris_(plant)", "Species")'
)

column_tooltips <- c(
  "Longueur du sépale en cm",
  "Largeur du sépale en cm",
  "Longueur du pétale en cm",
  "Largeur du pétale en cm",
  "Espèce de la fleur"
)

# Ajouter les hyperliens et les tooltips
for (i in 1:length(column_links)) {
  writeFormula(wb, sheet = 1, x = column_links[i], startCol = i, startRow = 1)
  
  # Créer un objet Comment sans fontSize
  comment <- createComment(comment = column_tooltips[i], author = "Info")
  writeComment(wb, sheet = 1, col = i, row = 1, comment = comment)
}

# Écrire les données iris sous les noms des colonnes avec hyperliens
writeData(wb, sheet = 1, x = iris, startRow = 2, colNames = FALSE)

# Sauvegarder le fichier Excel
saveWorkbook(wb, "data/iris_hyperlink_columns_with_tooltips.xlsx", overwrite = TRUE)
