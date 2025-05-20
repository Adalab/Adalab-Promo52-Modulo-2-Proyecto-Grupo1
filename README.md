# .........................🎶 MUSIUM 🎶 .........................
# .....🎶 Museo Virtual y gran reapertura 🎶.....
# ..............🎶 “Art After Dark 2025”🎶.................

**Proyecto**: Análisis de datos para el Museo Virtual Interactivo y la gran reapertura del "Art After Dark 2025".     

**Cliente**: Museo Guggenheim Bilbao (Comisaria: Miren Arzalluz)  

**Equipo DATORA**:  
- Marina Sabaté (Scrum Master)  
- Silvia Farled  
- Lara Domènech  
- Inés Martínez  
- Beatriz Barberán  

---

## 📖 Descripción

"MUSIUM" es la propuesta de DATORA para el Museo Virtual Interactivo, en el contexto de la reapertura del evento nocturno Art After Dark del Museo Guggenheim tras la pandemia.  
 
A través de un recorrido inmersivo, exploramos la evolución de la música en cuatro géneros —Pop, Rock, Reggaeton y Rap— y en cinco años clave: 2008, 2012, 2016, 2020 y 2024.  
  
A partir de datos extraídos de las APIs de Spotify y Last.fm, recopilamos métricas de popularidad, duración y contenido explícito, entre otras. Estas fueron almacenadas en una base de datos MySQL y analizadas con SQL y Python, para fundamentar la selección de artistas y la puesta en escena de cada sala.  
  
Inicialmente, diseñamos una estructura compuesta por cuatro tablas más dos tablas puente, pero tras recibir indicaciones de que solo se esperaban dos tablas principales, optamos por simplificar el modelo y descartar esa primera versión.  

---

## 📌 Objetivo del Proyecto

El objetivo de **Musium** es ofrecer una exposición interactiva y basada en datos que permita al museo:

- Comprender la evolución del gusto musical y las tendencias sonoras.
- Proporcionar una experiencia inmersiva basada en datos reales para los visitantes.
- Seleccionar el cartel artístico más representativo para la reapertura del evento.


---

## 🔍 Contenido de la Exposición

La presentación está estructurada en salas temáticas por género:

- 🎸 **Rock**: Canciones más escuchadas y evolución de la popularidad por año.
- 🎧 **Pop**: Top 3 de artistas y análisis de la duración media de las canciones.
- 🎤 **Rap**: Artistas más recomendados y comparación entre popularidad y reproducciones.
- 🔥 **Reggaeton**: Proporción de contenido explícito y presencia de canciones de nueva creación.
- 🎛️ **Sala Común**: Comparativas entre géneros en términos de popularidad, letras, contenido explícito y evolución.
- 🖼️ **Cartel Final**: Selección artística basada en datos y disponibilidad de gira.

---

## 📊 Consultas SQL destacadas

- Subconsultas para hallar canciones más populares por género y año.
- Joins entre tablas de Spotify y Last.fm para análisis cruzado.
- Agrupaciones (`GROUP BY`) y filtros con condiciones compuestas (`HAVING`, `LIKE`, `IN`, etc.).
- Análisis de contenido explícito mediante campos booleanos y texto.

---

## 🗂️ Estructura del Repositorio
  
- Jupyter Notebook (Proyecto MUSIUM I): contiene las llamadas a las APIs, la conversión a DataFrame, el guardado en CSV, y los procesos de normalización y limpieza de los datos.
- Jupyter Notebook (Proyecto MUSIUM II): trabaja con los CSV ya limpios e incluye el conector de MySQL para crear el schema, las tablas, cargar los datos, establecer la clave foránea y cerrar la conexión.
- CSV spoty_min.csv: archivo necesario para la creación de la tabla tracks.
- CSV lastfm_min.csv: archivo necesario para la creación de la tabla artist.
- Fichero SQL (Proyecto MUSIUM Consultas): contiene todas las consultas realizadas para el análisis de datos que se muestran en la presentación.
- Presentación del proyecto MUSIUM: https://view.genially.com/6825baa2482b5a3cea7f2ce7/presentation-musium

---

## 🔧 Herramientas utilizadas

- **Python**: Llamada a API, limpieza y preprocesamiento de datos, mysql-connector:
  - `requests`, `BeautifulSoup`, `Selenium`, `pandas`, `numpy`, `sqlalchemy`
- **MySQL 8+**: Creación y consulta de base de datos.
- **SQL**: Análisis de datos mediante consultas estructuradas.
- **Jupyter Notebook**: Desarrollo de los procesos de extracción y limpieza.
- **VS Code**: Editor de código.
- **Genially**: Presentación interactiva.
- **Flourish**: Creación de mapa interactivo. 
- **Git & GitHub**: Entrega del proyecto.
- **Metodología Scrum**

---

## 🚀 Retos Superados

- Extracción de datos mediante APIs.
- Normalización y limpieza de datos con inconsistencias en campos como nombres de artistas o géneros.
- Integración de múltiples fuentes de datos en una base de datos relacional.
- Análisis crítico de la correlación entre popularidad, reproducciones y contenido lírico.

---

## 💡 Propuestas de Mejora

- Integración Tecnológica Avanzada:  
    - Exhibiciones con realidad aumentada interactiva.  
    - Implementar modelo para playlists personalizadas.  
    - Añadir más fuentes de datos.  
- Expansión de Audiencias:  
    - Programas educativos para escuelas y universidades.  
    - Versiones itinerantes adaptadas a otros museos.  
    - Contenido virtual accesible para comunidades alejadas.  
- Mejoras en el Análisis:  
    - Separar el código en funciones / clases.  
    - Optimizar BBDD y limpieza de datos.  

---

## 🧑‍💻 Autoras

Este proyecto ha sido desarrollado por alumnas del bootcamp de **Adalab - Data Analytics**, dentro del módulo de SQL.

---