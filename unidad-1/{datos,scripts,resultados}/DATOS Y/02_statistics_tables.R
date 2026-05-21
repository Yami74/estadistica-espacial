# =============================================================================
# PASO 2: ANÁLISIS ESTADÍSTICO DE BUENAS PRÁCTICAS VETERINARIAS
# =============================================================================
library(dplyr)
library(tidyr)

archivo_rds <- "E:/Estadistica_Informastica/10mo/EstadisticaEspacial/DATOS Yami1/DATOS Y/subset_500.rds"

if(!file.exists(archivo_rds)) stop("ERROR: No se encuentra el subset. Corra el Paso 1.")

data <- readRDS(archivo_rds)

cat(">>> ANALIZANDO VARIABLES Y CALCULANDO SÍNTESIS...\n")

# Función para obtener el primer código seleccionado en variables multirespuesta
get_first_code <- function(df, prefix, max_idx) {
  cols <- paste0(prefix, 1:max_idx)
  # Para cada fila, encontrar el primer índice que sea 1
  apply(df[, cols, with=FALSE], 1, function(x) {
    idx <- which(x == 1)
    if(length(idx) > 0) return(idx[1]) else return(NA)
  })
}

# 1. Sintetizar las variables múltiples
data_stats <- data %>%
  mutate(
    recomendacion = get_first_code(data, "P502B_", 7),
    adquisicion   = get_first_code(data, "P503B_", 6),
    aplicacion    = as.numeric(P504B)
  ) %>%
  filter(
    !is.na(recomendacion),
    !is.na(adquisicion),
    !is.na(aplicacion)
  )
  
# 2. Resumen General
resumen <- data_stats %>%
  summarise(
    total = n(),
    prom_recomendacion = mean(recomendacion),
    prom_adquisicion = mean(adquisicion),
    prom_aplicacion = mean(aplicacion)
  )

print(resumen)

# 3. Estadística en un Punto Geográfico Específico
# Buscamos un punto con prácticas "ideales" (Promedio cercano a 1)
cat("\n--- ESTADÍSTICA EN UN PUNTO GEOGRÁFICO DE INTERÉS (Punto con Prácticas Profesionales) ---\n")
punto_interes <- data_stats %>%
  arrange(recomendacion) %>%
  head(1)

cat("Ubicación: ", punto_interes$LONGITUD, ", ", punto_interes$LATITUD, "\n")
cat(">> Valor Variable 502 (Recomienda): ", punto_interes$recomendacion, "\n")
cat(">> Valor Variable 503 (Adquiere): ", punto_interes$adquisicion, "\n")
cat(">> Valor Variable 504 (Aplica): ", punto_interes$aplicacion, "\n")

# Guardar datos procesados para el mapa
saveRDS(data_stats, archivo_rds)

cat("\n>>> ANÁLISIS ESTADÍSTICO COMPLETADO.\n")
