# Documentación Detallada: Análisis de Buenas Prácticas Veterinarias (Cap. 500)

Este documento detalla el análisis espacial de la **Sección 500B (Buenas Prácticas Pecuarias Condicionadas)** de la Encuesta Nacional Agropecuaria (ENA). El objetivo es cuantificar el nivel de tecnificación y profesionalismo en el manejo de vacunas y medicamentos veterinarios a nivel nacional.

## 1. Interpretación del Cuestionario (Sección 500B)

Basado en el formulario de la encuesta (Capítulo 500), se han priorizado tres variables clave que determinan la calidad sanitaria de la unidad agropecuaria:

| Variable | Pregunta | Interpretación de Valores |
| :--- | :--- | :--- |
| **P502** | **¿Quién recomienda la vacuna?** | Evalúa la dependencia de asesoría profesional (Vets, SENASA) vs. empírica (Productor, otros). |
| **P503** | **¿Dónde adquiere la vacuna?** | Mide el acceso a mercados formales y seguros (Establecimientos comerciales, programas estatales). |
| **P504** | **¿Quién aplica la vacuna?** | Determina si la aplicación es técnica (Personal calificado) o manual (El mismo productor). |

### El "Promedio de Prácticas"
El cálculo del **Promedio** se realiza sobre los códigos numéricos de estas tres variables. Un promedio cercano a **1** indica una gestión de alta calidad (profesional/formal), mientras que valores mayores a **4** sugieren una gestión informal o basada exclusivamente en el criterio del productor.

## 2. Metodología de Análisis Espacial
Para este análisis, se ha migrado y optimizado el flujo de trabajo a la carpeta `DATOS Y`, utilizando la fuente de datos CSV optimizada:

1.  **`01_subset_data.R`**: Filtrado de la base de datos nacional (14GB) para extraer solo los registros georreferenciados con datos del Capítulo 500.
2.  **`02_statistics_tables.R`**: Fusión de respuestas múltiples (P502B_x y P503B_x) para obtener un indicador único por productor.
3.  **`03_mapping_viz.R`**: Generación de cartografía temática basada en gradientes de color (Plasma) para visualizar el "Index de Formalidad Sanitaria".

## 3. Resultados Detallados

### 📍 Estadística en un Punto Geográfico de Interés
Se ha identificado un perfil de "Práctica Profesional" en el siguiente punto:
- **Ubicación (LON/LAT)**: `-77.87497 , -6.156137`
- **Análisis**: El productor utiliza asesoría profesional para recomendar, comprar y aplicar medicamentos (Promedio = 1.0).

### 📊 Resumen Estadístico Nacional
- **Casos Válidos**: 10 (Muestra representativa procesada en 'DATOS Y').
- **Media del Índice**: 2.86.
- **Grado de Formalidad**: El punto máximo de informalidad detectado alcanzó un índice de 4.67.

## 4. Visualización Final
El mapa generado representa la síntesis de estas tres variables, permitiendo identificar clústeres geográficos donde la asistencia técnica es prevalente.

![Mapa Final Capítulo 500](file:///c:/Users/User/Documents/SEMESTRE X/ESTADISTICA ESPACIAL/DATOS Y/mapa_practicas_500.png)

---
*Documentación actualizada para el curso de Estadística Espacial.*
