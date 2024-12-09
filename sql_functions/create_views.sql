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

CREATE VIEW view_obstrucao_eficiencia AS
SELECT
    DATE_FORMAT(dt.horario, '%H:%i') AS hora_minuto,
    ROUND(AVG(f.m_obstrucao), 2) AS media_obstrucao,
    ROUND(AVG(f.m_eficiencia), 2) AS media_eficiencia
FROM
    fato_dados f
JOIN
    dim_tempo dt ON f.id_tempo = dt.id_tempo
WHERE
    f.m_obstrucao IS NOT NULL
GROUP BY
    DATE_FORMAT(dt.horario, '%H:%i')
ORDER BY
    DATE_FORMAT(dt.horario, '%H:%i');

CREATE VIEW view_eficiencia_por_inclinacao_direcionamento AS
SELECT
    do.direcionamento,
    do.inclinacao,
    ROUND(AVG(f.m_eficiencia), 2) AS media_eficiencia
FROM
    fato_dados f
JOIN
    dim_orientacao do ON f.id_orientacao = do.id_orientacao
WHERE
    f.m_eficiencia IS NOT NULL
GROUP BY
    do.direcionamento, do.inclinacao
ORDER BY
    do.direcionamento, do.inclinacao;

CREATE VIEW view_energia_gerada_energia_esperada_geral AS
SELECT
    ROUND(SUM(f.m_energia_gerada), 2) AS total_energia_gerada,
    ROUND(SUM(f.m_energia_esperada), 2) AS total_energia_esperada
FROM
    fato_dados f
WHERE
    f.m_energia_gerada IS NOT NULL AND f.m_energia_esperada IS NOT NULL;

CREATE VIEW view_energia_gerada_energia_esperada_por_hora AS
SELECT
    DATE_FORMAT(dt.horario, '%H:%i') AS hora_minuto,
    ROUND(AVG(f.m_energia_gerada), 2) AS total_energia_gerada,
    ROUND(AVG(f.m_energia_esperada), 2) AS total_energia_esperada
FROM
    fato_dados f
JOIN
    dim_tempo dt ON f.id_tempo = dt.id_tempo
WHERE
    f.m_energia_gerada IS NOT NULL AND f.m_energia_esperada IS NOT NULL
GROUP BY
    DATE_FORMAT(dt.horario, '%H:%i')
ORDER BY
    DATE_FORMAT(dt.horario, '%H:%i');

CREATE VIEW view_tempetura_interna_externa AS
SELECT
    DATE_FORMAT(dt.horario, '%H:%i') AS hora_minuto,
    ROUND(AVG(f.m_temp_interna), 2) AS media_temperatura_interna,
    ROUND(AVG(f.m_temp_externa), 2) AS media_temperatura_externa
FROM
    fato_dados f
JOIN
    dim_tempo dt ON f.id_tempo = dt.id_tempo
WHERE
    f.m_temp_interna IS NOT NULL AND f.m_temp_externa IS NOT NULL
GROUP BY
    DATE_FORMAT(dt.horario, '%H:%i')
ORDER BY
    DATE_FORMAT(dt.horario, '%H:%i');

CREATE VIEW view_area_irradiacao_por_setor_e_eficiencia AS
SELECT
    ds.nome AS setor,
    ROUND(AVG(f.m_luminosidade * 100 / 10000), 2) AS media_area_irradiacao,
    ROUND(AVG(f.m_eficiencia), 2) AS media_eficiencia
FROM
    fato_dados f
JOIN
    dim_painel dp ON f.id_painel = dp.id_painel
JOIN
    dim_setor ds ON dp.fk_setor = ds.id_setor
WHERE
    f.m_luminosidade IS NOT NULL 
    AND f.m_eficiencia IS NOT NULL
GROUP BY
    ds.nome
ORDER BY
    ds.nome;

CREATE VIEW view_obstrucao_por_setor_e_eficiencia AS
SELECT
    ds.nome AS setor,
    ROUND(AVG(f.m_obstrucao), 2) AS media_obstrucao,
    ROUND(AVG(f.m_eficiencia), 2) AS media_eficiencia
FROM
    fato_dados f
JOIN
    dim_painel dp ON f.id_painel = dp.id_painel
JOIN
    dim_setor ds ON dp.fk_setor = ds.id_setor
WHERE
    f.m_obstrucao IS NOT NULL
    AND f.m_eficiencia IS NOT NULL  
GROUP BY
    ds.nome
ORDER BY
    ds.nome;

CREATE VIEW view_eficiencia_media_por_painel AS
SELECT 
    p.nome AS painel, 
    ROUND(AVG(f.m_eficiencia), 2) AS eficiencia_media
FROM fato_dados f
JOIN dim_painel p ON f.id_painel = p.id_painel
GROUP BY p.nome;

CREATE VIEW view_energia_gerada_total AS
SELECT 
    t.ano, 
    t.mes, 
    t.dia, 
    ROUND(SUM(f.m_energia_gerada), 2) AS energia_total
FROM fato_dados f
JOIN dim_tempo t ON f.id_tempo = t.id_tempo
GROUP BY t.ano, t.mes, t.dia;

CREATE VIEW view_energia_esperada_vs_real AS
SELECT 
    t.ano, 
    t.mes, 
    t.dia, 
    ROUND(SUM(f.m_energia_gerada), 2) AS energia_gerada, 
    ROUND(SUM(f.m_energia_esperada), 2) AS energia_esperada,
    ROUND((SUM(f.m_energia_gerada) / NULLIF(SUM(f.m_energia_esperada), 0)) * 100, 2) AS percentual_realizado
FROM fato_dados f
JOIN dim_tempo t ON f.id_tempo = t.id_tempo
GROUP BY t.ano, t.mes, t.dia;

CREATE VIEW view_temperatura_media AS
SELECT 
    c.cidade, 
    ROUND(AVG(f.m_temp_interna), 2) AS temperatura_media_interna,
    ROUND(AVG(f.m_temp_externa), 2) AS temperatura_media_externa
FROM fato_dados f
JOIN dim_painel p ON f.id_painel = p.id_painel
JOIN dim_setor s ON p.fk_setor = s.id_setor
JOIN dim_empresa e ON s.fk_empresa = e.id_empresa
JOIN dim_cidade c ON e.fk_cidade = c.id_cidade
GROUP BY c.cidade;

CREATE VIEW view_impacto_umidade AS
SELECT 
    ROUND(f.m_umidade, 2) AS umidade, 
    ROUND(AVG(f.m_eficiencia), 2) AS eficiencia_media
FROM fato_dados f
GROUP BY f.m_umidade;

CREATE VIEW view_luminosidade_media_por_ceu AS
SELECT 
    ceu.ceu, 
    ROUND(AVG(f.m_luminosidade), 2) AS luminosidade_media
FROM fato_dados f
JOIN dim_ceu ceu ON f.id_ceu = ceu.id_ceu
GROUP BY ceu.ceu;

CREATE VIEW view_impacto_obstrucao AS
SELECT 
    ROUND(f.m_obstrucao, 2) AS obstrucao, 
    ROUND(AVG(f.m_eficiencia), 2) AS eficiencia_media
FROM fato_dados f
GROUP BY f.m_obstrucao;

CREATE VIEW view_producao_por_periodo AS
SELECT 
    t.horario, 
    ROUND(SUM(f.m_energia_gerada), 2) AS energia_gerada_total
FROM fato_dados f
JOIN dim_tempo t ON f.id_tempo = t.id_tempo
GROUP BY t.horario;

CREATE VIEW view_pico_eficiencia AS
SELECT 
    t.ano, 
    t.mes, 
    t.dia, 
    ROUND(MAX(f.m_eficiencia), 2) AS pico_eficiencia
FROM fato_dados f
JOIN dim_tempo t ON f.id_tempo = t.id_tempo
GROUP BY t.ano, t.mes, t.dia;

CREATE VIEW view_paineis_subutilizados AS
SELECT 
    p.nome AS painel, 
    ROUND(AVG(f.m_eficiencia), 2) AS eficiencia_media
FROM fato_dados f
JOIN dim_painel p ON f.id_painel = p.id_painel
GROUP BY p.nome
HAVING AVG(f.m_eficiencia) < 50; 

CREATE VIEW view_monitoramento_obstrucoes AS
SELECT 
    p.nome AS painel, 
    ROUND(AVG(f.m_obstrucao), 2) AS obstrucao_media
FROM fato_dados f
JOIN dim_painel p ON f.id_painel = p.id_painel
GROUP BY p.nome
HAVING AVG(f.m_obstrucao) > 30;

CREATE VIEW view_alertas_alta_temperatura AS
SELECT 
    p.nome AS painel, 
    ROUND(f.m_temp_interna, 2) AS temp_interna, 
    ROUND(f.m_temp_externa, 2) AS temp_externa, 
    t.ano, 
    t.mes, 
    t.dia
FROM fato_dados f
JOIN dim_painel p ON f.id_painel = p.id_painel
JOIN dim_tempo t ON f.id_tempo = t.id_tempo
WHERE f.m_temp_interna > 50 OR f.m_temp_externa > 50; 
