# =============================================================================
# PASO 3: VISUALIZACIÓN ESPACIAL DE VARIABLES DEL CAPÍTULO 500
# =============================================================================

library(sf)
library(ggplot2)
library(viridis)
library(rnaturalearth)
library(dplyr)

archivo_rds <- "E:/Estadistica_Informastica/10mo/EstadisticaEspacial/DATOS Yami1/DATOS Y/subset_500.rds"

if(!file.exists(archivo_rds)) stop("ERROR: No se encuentra el subset. Corra el Paso 2.")

data <- readRDS(archivo_rds)

cat(">>> GENERANDO MAPAS ESPACIALES...\n")

# Mapa base de Perú
peru <- ne_countries(scale = "medium", returnclass = "sf", country = "Peru")

# Convertir a espacial
puntos_sf <- st_as_sf(data, coords = c("LONGITUD", "LATITUD"), crs = 4326)

# ==============================
# 🟣 MAPA 1: RECOMENDACIÓN
# ==============================
mapa1 <- ggplot() +
  geom_sf(data = peru, fill = "gray95", color = "gray70") +
  geom_sf(data = puntos_sf, aes(color = recomendacion), alpha = 0.6) +
  scale_color_viridis_c(option = "plasma", name = "Recomendación") +
  labs(
    title = "Distribución Espacial de la Recomendación de Vacunas",
    subtitle = "Capítulo 500 - ENA",
    x = "Longitud", y = "Latitud"
  ) +
  theme_minimal()

# ==============================
# 🔵 MAPA 2: ADQUISICIÓN
# ==============================
mapa2 <- ggplot() +
  geom_sf(data = peru, fill = "gray95", color = "gray70") +
  geom_sf(data = puntos_sf, aes(color = adquisicion), alpha = 0.6) +
  scale_color_viridis_c(option = "inferno", name = "Adquisición") +
  labs(
    title = "Distribución Espacial del Lugar de Adquisición",
    subtitle = "Capítulo 500 - ENA",
    x = "Longitud", y = "Latitud"
  ) +
  theme_minimal()

# ==============================
# 🔴 MAPA 3: APLICACIÓN
# ==============================
mapa3 <- ggplot() +
  geom_sf(data = peru, fill = "gray95", color = "gray70") +
  geom_sf(data = puntos_sf, aes(color = aplicacion), alpha = 0.6) +
  scale_color_viridis_c(option = "magma", name = "Aplicación") +
  labs(
    title = "Distribución Espacial de la Aplicación de Vacunas",
    subtitle = "Capítulo 500 - ENA",
    x = "Longitud", y = "Latitud"
  ) +
  theme_minimal()

# ==============================
# 💾 GUARDAR MAPAS
# ==============================

ggsave("mapa_recomendacion.png", mapa1, width = 8, height = 10, dpi = 300)
ggsave("mapa_adquisicion.png", mapa2, width = 8, height = 10, dpi = 300)
ggsave("mapa_aplicacion.png", mapa3, width = 8, height = 10, dpi = 300)

cat(">>> MAPAS GENERADOS CORRECTAMENTE.\n")