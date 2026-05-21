# =============================================================================
# PASO 1: EXTRACCIÓN Y SUBSETTING DE SECCIÓN 500 Y 224
# =============================================================================
library(data.table)
library(dplyr)

archivo_csv_entrada <- "E:/Estadistica_Informastica/10mo/EstadisticaEspacial/DATOS Yami1/DATOS Y/ENA_2014_2024.csv"
archivo_csv_salida  <- "E:/Estadistica_Informastica/10mo/EstadisticaEspacial/DATOS Yami1/DATOS Y/ENA_Seccion_500_224.csv"
archivo_rds_salida  <- "E:/Estadistica_Informastica/10mo/EstadisticaEspacial/DATOS Yami1/DATOS Y/subset_500.rds"

cat(">>> LEYENDO ENA_2014_2024.csv (110MB)...\n")

# Definir columnas de interés (Sección 500 - ubicacion)
columnas <- c(
  "ANIO", "CCDD", "CCPP", "CCDI",
  "LATITUD", "LONGITUD",
  
  # Sección 500
  "P502B_1", "P502B_2", "P502B_3", "P502B_4", "P502B_5", "P502B_6", "P502B_7",
  "P503B_1", "P503B_2", "P503B_3", "P503B_4", "P503B_5", "P503B_6",
  "P504B"
)

# Carga rápida con fread
data_raw <- fread(archivo_csv_entrada, select = columnas, fill = TRUE)

cat(">>> PROCESANDO Y FILTRANDO REGISTROS...\n")

data_proc <- data_raw %>%
  filter(
    !is.na(LATITUD), !is.na(LONGITUD),
    LATITUD >= -18 & LATITUD <= 0,
    LONGITUD >= -82 & LONGITUD <= -68
  ) %>%
  filter(!(is.na(P504B) & is.na(P502B_1)))

cat(">>> GUARDANDO PARTICIÓN EN CSV Y RDS...\n")
# Guardar en CSV para uso externo o inspección rápida
fwrite(data_proc, archivo_csv_salida)
# Guardar en RDS para flujo interno de R (mantiene tipos de datos)
saveRDS(data_proc, archivo_rds_salida)

cat(">>> EXTRACCIÓN Y PARTICIÓN COMPLETADA.\n")
cat(">>> Registros recuperados:", nrow(data_proc), "\n")
cat(">>> Archivo CSV creado en: ", archivo_csv_salida, "\n")
