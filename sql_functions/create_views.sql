DROP VIEW IF EXISTS view_irradiacao_solar_media_por_hora;

CREATE VIEW view_irradiacao_solar_media_por_hora AS
SELECT 
    DATE_FORMAT(dt.horario, '%H:%i') AS hora_minuto,
    ROUND(AVG(f.m_luminosidade * 100 / 10000), 2) AS media_area_irradiacao
FROM 
    fato_dados f
JOIN 
    dim_tempo dt ON f.id_tempo = dt.id_tempo
WHERE 
    f.m_luminosidade IS NOT NULL
GROUP BY 
    DATE_FORMAT(dt.horario, '%H:%i')
ORDER BY 
    DATE_FORMAT(dt.horario, '%H:%i');

SELECT * FROM view_irradiacao_solar_media_por_hora;

