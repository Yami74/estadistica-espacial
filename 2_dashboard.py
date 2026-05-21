import streamlit as st
import pandas as pd
import plotly.express as px
import folium
from streamlit_folium import st_folium

# Configuración de la página
st.set_page_config(page_title="Dashboard ENA", layout="wide")
st.title("Análisis Territorial Agropecuario - ENA Perú")

# Diccionario de traducción para corregir nombres truncados de la data ENA
DICCIONARIO_DEPARTAMENTOS = {
    'AMAZON': 'Amazonas', 'ANCASH': 'Áncash', 'APURÍ': 'Apurímac', 
    'AREQUI': 'Arequipa', 'AYACUC': 'Ayacucho', 'CAJAMA': 'Cajamarca', 
    'CALLAO': 'Callao', 'CUSCO': 'Cusco', 'HUANCA': 'Huancavelica', 
    'HUANUC': 'Huánuco', 'ICA': 'Ica', 'JUNÍN': 'Junín', 
    'LA LIB': 'La Libertad', 'LAMBAY': 'Lambayeque', 'LIMA': 'Lima', 
    'LORETO': 'Loreto', 'MADRE ': 'Madre de Dios', 'MOQUEG': 'Moquegua', 
    'PASCO': 'Pasco', 'PIURA': 'Piura', 'PUNO': 'Puno', 
    'SAN MA': 'San Martín', 'TACNA': 'Tacna', 'TUMBES': 'Tumbes', 
    'UCAYAL': 'Ucayali'
}

# Función para cargar datos cacheados y optimizar velocidad
@st.cache_data
def cargar_datos():
    data = pd.read_csv('ena_procesado.csv')
    
    # Estandarizar textos eliminando espacios extraños antes de mapear
    data['NOMBREDD'] = data['NOMBREDD'].astype(str).str.strip()
    
    # Crear una nueva columna con el nombre limpio para mostrar al usuario
    data['DEPARTAMENTO_COMPLETO'] = data['NOMBREDD'].map(DICCIONARIO_DEPARTAMENTOS).fillna(data['NOMBREDD'])
    return data

try:
    df = cargar_datos()
    
    # ---------------- BARRA LATERAL (FILTROS) ----------------
    st.sidebar.header("Filtros de Análisis")
    
    # Filtro por Departamento (Usando la columna con nombres limpios y completos)
    departamentos = sorted(df['DEPARTAMENTO_COMPLETO'].unique())
    dept_sel = st.sidebar.multiselect("Departamento:", departamentos)
    
    # Filtro por Piso Altitudinal
    pisos = df['PISO_ALTITUDINAL'].dropna().unique()
    piso_sel = st.sidebar.multiselect("Piso Altitudinal:", pisos)
    
    # Aplicar filtros a la data
    df_filtrado = df.copy()
    if dept_sel:
        df_filtrado = df_filtrado[df_filtrado['DEPARTAMENTO_COMPLETO'].isin(dept_sel)]
    if piso_sel:
        df_filtrado = df_filtrado[df_filtrado['PISO_ALTITUDINAL'].isin(piso_sel)]

    # ---------------- INDICADORES PRINCIPALES ----------------
    col1, col2, col3, col4 = st.columns(4)
    col1.metric("Unidades Agropecuarias", f"{len(df_filtrado):,}")
    col2.metric("Superficie Total (ha)", f"{df_filtrado['SUP_TOTAL_HA'].sum():,.1f}")
    col3.metric("Altitud Media (msnm)", f"{df_filtrado['ALTITUD'].mean():,.0f}")
    
    if not df_filtrado.empty and 'TIPO_PRODUCTOR' in df_filtrado.columns:
        tipo_predominante = df_filtrado['TIPO_PRODUCTOR'].mode()[0]
    else:
        tipo_predominante = "Sin datos"
    col4.metric("Productor Predominante", tipo_predominante)

    st.markdown("---")

    # ---------------- GRÁFICOS DINÁMICOS ----------------
    c1, c2 = st.columns(2)
    
    with c1:
        st.subheader("Distribución Altitudinal")
        fig_alt = px.histogram(
            df_filtrado, x="ALTITUD", color="PISO_ALTITUDINAL",
            nbins=30, template="plotly_white"
        )
        st.plotly_chart(fig_alt, use_container_width=True)
        
    with c2:
        st.subheader("Altitud vs. Superficie (ha)")
        fig_disp = px.scatter(
            df_filtrado, x="ALTITUD", y="SUP_TOTAL_HA", 
            color="TIPO_PRODUCTOR", opacity=0.6, template="plotly_white"
        )
        fig_disp.update_yaxes(type="log", title="Superficie Total (Escala Log)")
        st.plotly_chart(fig_disp, use_container_width=True)

    # ---------------- MAPA INTERACTIVO ----------------
    st.subheader("Mapa de Clústeres Territoriales (K-Means)")
    st.markdown("Cada punto representa una unidad agropecuaria, coloreada según su clúster territorial.")
    
    df_mapa = df_filtrado.sample(min(1000, len(df_filtrado)), random_state=42) if not df_filtrado.empty else df_filtrado
    
    mapa = folium.Map(location=[-9.19, -75.01], zoom_start=5, tiles='CartoDB positron')
    colores_cluster = ['#e41a1c', '#377eb8', '#4daf4a', '#984ea3', '#ff7f00']
    
    for _, row in df_mapa.iterrows():
        folium.CircleMarker(
            location=[row['LATITUD'], row['LONGITUD']],
            radius=4,
            color=colores_cluster[int(row['CLUSTER_TERRITORIAL']) % len(colores_cluster)],
            fill=True,
            fill_opacity=0.7,
            tooltip=f"<b>Dpto:</b> {row['DEPARTAMENTO_COMPLETO']}<br><b>Altitud:</b> {row['ALTITUD']} msnm<br><b>Sup:</b> {row['SUP_TOTAL_HA']} ha"
        ).add_to(mapa)
        
    st_folium(mapa, width="100%", height=500)

except FileNotFoundError:
    st.error("⚠️ Archivo 'ena_procesado.csv' no encontrado. Ejecuta primero el Jupyter Notebook para generarlo.")