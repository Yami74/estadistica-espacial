library(data.table)
head_cols <- names(fread("E:/Estadistica_Informastica/10mo/EstadisticaEspacial/DATOS Yami1/DATOS Y/ENA_2014_2024.csv", nrows = 0))
writeLines(grep("P50", head_cols, value = TRUE), "cols_p50.txt")
