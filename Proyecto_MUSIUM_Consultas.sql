# Base de datos 'musium':

USE musium;

-- Tablas de la base de datos:
SELECT * FROM tracks;
SELECT * FROM artist;

-- Artistas más escuchados de cada género, quizá están sobrevalorados en Spoti, con respecto a Last FM. Estas consultas nos han servido para decidir basarnos en la popularidad a la hora de realizar 
-- las otras consultas en vez de con el playcount o listeners, ya que es lo más significativo.

SET @genero := 'pop';

SELECT 
    a.artist_name,
    t.genre,
    t.popularity,
    a.listeners / (
        SELECT MAX(a2.listeners)
        FROM artist a2
        JOIN tracks t2 ON a2.artist_name = t2.artist_name
        WHERE t2.genre = t.genre
    ) * 100 AS per_list,
    a.playcount / (
        SELECT MAX(a3.playcount)
        FROM artist a3
        JOIN tracks t3 ON a3.artist_name = t3.artist_name
        WHERE t3.genre = t.genre
    ) * 100 AS per_play,
    CASE 
    WHEN (t.popularity / 100) >= (a.playcount / (
            SELECT MAX(a3.playcount)
            FROM artist a3
            JOIN tracks t3 ON a3.artist_name = t3.artist_name
            WHERE t3.genre = t.genre
        )) * 1.25 THEN 'Más valorado en Spotify'
    WHEN (a.playcount / (
            SELECT MAX(a3.playcount)
            FROM artist a3
            JOIN tracks t3 ON a3.artist_name = t3.artist_name
            WHERE t3.genre = t.genre
        )) >= (t.popularity / 100) * 1.25 THEN 'Más valorado en LastFM'
    ELSE 'Equitativo'
    END AS valoracion
FROM artist a
JOIN tracks t ON a.artist_name = t.artist_name
WHERE t.genre =  @genero
ORDER BY t.popularity DESC
LIMIT 5;

	-- Para saber el total que hay de cada grupo:
    
SELECT 
    CASE 
    WHEN (t.popularity / 100) >= (a.playcount / (
            SELECT MAX(a3.playcount)
            FROM artist a3
            JOIN tracks t3 ON a3.artist_name = t3.artist_name
        )) * 1.25 THEN 'Más valorado en Spotify'
    WHEN (a.playcount / (
            SELECT MAX(a3.playcount)
            FROM artist a3
            JOIN tracks t3 ON a3.artist_name = t3.artist_name
        )) >= (t.popularity / 100) * 1.25 THEN 'Más valorado en LastFM'
    ELSE 'Equitativo'
    END AS valoracion, 
    COUNT(*) total_artistas
FROM artist a
JOIN tracks t ON a.artist_name = t.artist_name
GROUP BY valoracion
;

-- 1. Top 5 de canciones más escuchadas de cada género

SELECT genre, artist_name, track_name, AVG(popularity) Popularidad
FROM tracks
WHERE genre = 'rock'
GROUP BY genre, artist_name, track_name
ORDER BY Popularidad DESC
LIMIT 5;

--  2.	Evolución del género según la popularidad de sus canciones durante los años estudiados:

SELECT year, genre, ROUND(AVG(popularity),2) popularidad_media
    FROM tracks
    GROUP BY genre, year
    HAVING genre = 'rock'
    ORDER BY year, popularidad_media DESC;

-- 3. Top 1 de la canción más escuchada de cada género en cada año:

SELECT genre, artist_name, track_name, AVG(popularity) Popularidad
FROM tracks
WHERE genre = 'rock'
    AND year = 2024
GROUP BY artist_name, track_name
ORDER BY Popularidad DESC
LIMIT 1;

-- 4. Top 3 de artistas más escuchados de cada género durante todo el período estudiado:

SELECT artist_name, AVG(popularity), genre
FROM tracks
WHERE genre = 'pop'
GROUP BY artist_name
ORDER BY AVG(Popularity) DESC
LIMIT 3;

-- 5. Evolución en la duración de las canciones (tiempo) y cómo influye en la popularidad del top 5 de cada año: 

SET @genero := 'pop';
SET @anio := 2008;

SELECT track_name, genre, popularity, 
	CASE 
	WHEN (duration_ms/60000) < 3 THEN 'Corta'
	WHEN (duration_ms/60000) BETWEEN 3 AND 4 THEN 'Media'
	ELSE 'Larga'
    END AS duration
FROM tracks
WHERE genre = @genero
AND year = @anio
ORDER BY popularity DESC
LIMIT 5
;

	# También se ha modificado para obetenr la evolución en la duración de las canciones (tiempo) y cómo influye en la popularidad de cada genero en porcentaje respecto al total de canciones durante todos los años estudiados:
SET @genero := 'pop';

SELECT year, COUNT(*) AS total_tracks,
  SUM(CASE WHEN duration_ms/60000 <  3 THEN 1 ELSE 0 END) corta,
  SUM(CASE WHEN duration_ms/60000 BETWEEN 3 AND 4 THEN 1 ELSE 0 END) media,
  SUM(CASE WHEN duration_ms/60000 >  4 THEN 1 ELSE 0 END) larga,
  ROUND(100 * SUM(CASE WHEN duration_ms/60000 <  3 THEN 1 ELSE 0 END)
              / COUNT(*), 1) porcentage_corta,
  ROUND(100 * SUM(CASE WHEN duration_ms/60000 BETWEEN 3 AND 4 THEN 1 ELSE 0 END)
              / COUNT(*), 1) porcentage_media,
  ROUND(100 * SUM(CASE WHEN duration_ms/60000 >  4 THEN 1 ELSE 0 END)
              / COUNT(*), 1) porcentage_larga
FROM tracks
WHERE genre = @genero AND year  IN (2008, 2012, 2016, 2020, 2024)
GROUP BY year
ORDER BY year;

-- 6. Respecto a los artistas más escuchados en LAST FM: Recomendación de artistas similares, para descubrir nuevos artistas:

SELECT DISTINCT a.artist_name, a.similar, t.genre, a.playcount
FROM artist a
LEFT JOIN tracks t
  ON a.artist_name = t.artist_name
WHERE t.genre = 'rap' AND t.year= 2024
ORDER BY a.playcount DESC
LIMIT 3;

-- 7. Extracción de paises de la procedencia de los artistas:

WITH artistas_con_pais AS (
  SELECT
    a.artist_name,
    CASE
      WHEN a.biography LIKE '%usa%'
        OR a.biography LIKE '%estados%'
        OR a.biography LIKE '%estadounid%'
        OR a.biography LIKE '%amer%' THEN 'Estados Unidos / América'
      WHEN a.biography LIKE '%ingl%'
        OR a.biography LIKE '%reino unido%'
        OR a.biography LIKE '%brit%' THEN 'Reino Unido'
      WHEN a.biography LIKE '%kor%'
        OR a.biography LIKE '%corea%' THEN 'Corea del Sur'
      WHEN a.biography LIKE '%can%' THEN 'Canadá'
      WHEN a.biography LIKE '%swed%' THEN 'Suecia'
      WHEN a.biography LIKE '%aust%' THEN 'Australia'
      WHEN a.biography LIKE '%aleman%' THEN 'Alemania'
      WHEN a.biography LIKE '%franc%' THEN 'Francia'
      WHEN a.biography LIKE '%puerto%' THEN 'Puerto Rico'
      WHEN a.biography LIKE '%col%' THEN 'Colombia'
      WHEN a.biography LIKE '%dominican%' THEN 'República Dominicana'
      ELSE 'Desconocido'
    END AS pais_detectado
  FROM artist a
  JOIN tracks t ON a.artist_name = t.artist_name
  WHERE t.genre IN ('rap', 'pop', 'rock', 'reggaeton')
    AND (
      a.biography LIKE '%usa%' OR
      a.biography LIKE '%estados%' OR
      a.biography LIKE '%estadounid%' OR
      a.biography LIKE '%amer%' OR
      a.biography LIKE '%ingl%' OR
      a.biography LIKE '%reino unido%' OR
      a.biography LIKE '%brit%' OR
      a.biography LIKE '%kor%' OR
      a.biography LIKE '%corea%' OR
      a.biography LIKE '%can%' OR
      a.biography LIKE '%swed%' OR
      a.biography LIKE '%aust%' OR
      a.biography LIKE '%aleman%' OR
      a.biography LIKE '%franc%' OR
      a.biography LIKE '%puerto%' OR
      a.biography LIKE '%col%' OR
      a.biography LIKE '%dominican%'
    )
)
SELECT pais_detectado, COUNT(*) AS cantidad_artistas
FROM artistas_con_pais
GROUP BY pais_detectado
ORDER BY cantidad_artistas DESC;

-- 8.	Número de canciones. Si tiene canciones nuevas o se siguen escuchando canciones de años pasados:

	# Número de canciones por artista y año.

SELECT artist_name, year, COUNT(*) AS num_tracks
FROM tracks
GROUP BY artist_name, year
ORDER BY artist_name, year;

	# Número de canciones totales de cada artista.
SELECT artist_name, COUNT(DISTINCT track_name) AS num_tracks
FROM tracks
GROUP BY artist_name
ORDER BY artist_name;

	# Del top 5 de artistas de cada género, si tienen canciones nuevas o se siguen escuchando canciones de años pasados, artistas que ya no suben contenido nuevo:

SELECT artist_name, AVG(popularity) promedio_popularidad,
  SUM(CASE WHEN year = 2024 THEN 1 ELSE 0 END) AS songs_this_year,
  SUM(CASE WHEN year  < 2024 THEN 1 ELSE 0 END) AS songs_previous_years
FROM tracks
WHERE genre = 'reggaeton'
GROUP BY artist_name
ORDER BY promedio_popularidad DESC
LIMIT 5;

--  9. Cantidad de canciones que tienen contenido explícito, dónde hay más, en qué género hay menos, estudiado para cada año:

SELECT year año, genre género,
  SUM(explicit) AS canciones_contenido_explicito,
  COUNT(*) AS total_canciones,
  ROUND(100.0 * SUM(explicit) / COUNT(*), 2) AS porcentaje_contenido_explicito
FROM tracks
GROUP BY year, genre;

	# Cómo ha evolucionado el contenido explícito a lo largo de estas dos últimas décadas en general, sin tener en cuenta cada género: 

SELECT year,
  COUNT(*) AS total_canciones,
  SUM(explicit) AS total_explicitas,
  ROUND(100.0 * SUM(explicit) / COUNT(*), 2) AS porcentaje_explicitas 
FROM tracks
GROUP BY year
ORDER BY year;

	# Para obetenr un valor, en porcentaje general, de cada género estudiado, cuántas canciones con contenido explícito ha sacado durante todos los años juntos:
SELECT genre, COUNT(*) AS total_canciones_genero, SUM(explicit) AS total_explicit, ROUND(100*SUM(explicit)/COUNT(*),2) AS porcentage_explicit
FROM tracks
GROUP BY genre
ORDER BY porcentage_explicit DESC;

-- 10. Generos asociados al top 10 de canciones más escuchadas cada año:

SELECT genre, COUNT(*) AS veces
FROM (
	SELECT genre
	FROM tracks
    WHERE year = 2024
	ORDER BY popularity DESC
	LIMIT 10) AS top3
GROUP BY genre
ORDER BY veces DESC
;

-- 11. Top 3 de canciones más populares en cada año estudiado, para visualizar de qué género son:

SELECT genre, COUNT(*) AS veces_en_top3
FROM (
    SELECT * FROM (
        SELECT genre
        FROM tracks
        WHERE year = 2008
        ORDER BY popularity DESC
        LIMIT 3
    ) AS top_2008

    UNION ALL

    SELECT * FROM (
        SELECT genre
        FROM tracks
        WHERE year = 2012
        ORDER BY popularity DESC
        LIMIT 3
    ) AS top_2012

    UNION ALL

    SELECT * FROM (
        SELECT genre
        FROM tracks
        WHERE year = 2016
        ORDER BY popularity DESC
        LIMIT 3
    ) AS top_2016

    UNION ALL

    SELECT * FROM (
        SELECT genre
        FROM tracks
        WHERE year = 2020
        ORDER BY popularity DESC
        LIMIT 3
    ) AS top_2020

    UNION ALL

    SELECT * FROM (
        SELECT genre
        FROM tracks
        WHERE year = 2024
        ORDER BY popularity DESC
        LIMIT 3
    ) AS top_2024
) AS top3_total
GROUP BY genre
ORDER BY veces_en_top3 DESC;

--  12.	Evolución del género según la popularidad de sus canciones durante los años estudiados:

SELECT year, genre, ROUND(AVG(popularity),2) popularidad_media
    FROM tracks
    GROUP BY genre, year
    ORDER BY year, popularidad_media DESC;

-- 13.Top 3 de canciones con más popularidad en el 2024:

SELECT genre, track_name, popularity, artist_name
FROM (
	SELECT genre, track_name, popularity, artist_name
	FROM tracks
    WHERE year = 2024
	ORDER BY popularity DESC
	LIMIT 3) AS top3;

-- 14. Canciones más significativas de grupos que han despuntado en un momento concreto y, pese a su evolución, el público sigue escuchando esas canciones entre 2008 y 2024:

SELECT
  f.genre,
  f.track_name AS hit_2008,
  f.popularity AS pop_2008,
  l.track_name AS hit_2024,
  l.popularity AS pop_2024
FROM ( SELECT t1.genre, t1.track_name, t1.popularity
  FROM tracks t1
  WHERE t1.year = 2008 AND t1.popularity = (
		SELECT MAX(t2.popularity)
		FROM tracks t2
		WHERE t2.genre = t1.genre AND t2.year = 2008)
 ) AS f
JOIN ( SELECT t1.genre, t1.track_name, t1.popularity
  FROM tracks t1
  WHERE t1.year = 2024 AND t1.popularity = (
		SELECT MAX(t2.popularity)
		FROM tracks t2
		WHERE t2.genre = t1.genre AND t2.year = 2024)
) AS l
  ON f.genre = l.genre;
  
-- 15.	El largo de los títulos  

SELECT length(track_name) largo, popularity
FROM tracks
WHERE track_name NOT LIKE '%(%'
AND track_name NOT LIKE '%\/%'
AND track_name NOT LIKE '%-%'
AND track_name NOT LIKE '%[%'
ORDER BY largo ASC;

-- 16. Comprobar el artista con mas popularidad en uno de sus tracks de cada género que esté de tour: 

SELECT 
  t.genre,
  t.artist_name,
  t.track_name,
  t.popularity AS popularidad_maxima
FROM tracks t
JOIN artist a ON t.artist_name = a.artist_name
WHERE a.on_tour = 1
  AND (t.genre, t.popularity) IN (
    SELECT genre, MAX(popularity)
    FROM tracks t2
    JOIN artist a2 ON t2.artist_name = a2.artist_name
    WHERE a2.on_tour = 1
    GROUP BY genre
  )
ORDER BY t.genre;

# EXTRA:
	-- Para saber los generos más populares de las canciones top 5 de 2008 y 2024:
    
    (SELECT
    '2008' AS year,
    track_name,
    artist_name,
    genre,
    popularity
  FROM tracks
  WHERE year = 2008
  ORDER BY popularity DESC
  LIMIT 5)
UNION ALL
   (SELECT
    '2024' AS year,
    track_name,
    artist_name,
    genre,
    popularity
  FROM tracks
  WHERE year = 2024
  ORDER BY popularity DESC
  LIMIT 5)
ORDER BY year;

-- Para obtener la biografía de Billie Eilish para el cartel de la WEB:

SELECT DISTINCT t.genre, a.artist_name, a.biography, t.popularity
FROM artist a
JOIN tracks t on a.artist_name = t.artist_name
ORDER BY t.popularity DESC
LIMIT 1;