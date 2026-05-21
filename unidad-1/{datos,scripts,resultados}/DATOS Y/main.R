# =============================================================================
# SCRIPT MAESTRO: ANÁLISIS ESPACIAL DE VARIABLES (ENA)
# Folder: "DATOS Y"
# =============================================================================

cat("=========================================================\n")
cat("INICIANDO PROCESAMIENTO COMPLETO EN 'DATOS Y'\n")
cat("=========================================================\n\n")

# Definir directorio de trabajo
setwd("E:/Estadistica_Informastica/10mo/EstadisticaEspacial/DATOS Yami1/DATOS Y")

# Paso 1: Extracción
source("01_subset_data.R")

# Paso 2: Estadística
source("02_statistics_tables.R")

# Paso 3: Mapeo
source("03_mapping_viz.R")

cat("\n=========================================================\n")
cat("PROCESAMIENTO FINALIZADO CON ÉXITO\n")
cat("Mapas generados:\n")
cat("- mapa_recomendacion.png\n")
cat("- mapa_adquisicion.png\n")
cat("- mapa_aplicacion.png\n")
cat("=========================================================\n")