INSERT INTO horus_dimensional.dim_estado (estado)
SELECT DISTINCT e.estado
FROM horus_trusted.endereco e
WHERE e.estado NOT IN (SELECT estado FROM horus_dimensional.dim_estado);

INSERT INTO horus_dimensional.dim_cidade (cidade, fk_estado)
SELECT DISTINCT e.cidade, es.id_estado
FROM horus_trusted.endereco e
JOIN horus_dimensional.dim_estado es ON es.estado = e.estado
WHERE e.cidade NOT IN (SELECT cidade FROM horus_dimensional.dim_cidade);

INSERT INTO horus_dimensional.dim_empresa (nome, fk_cidade)
SELECT DISTINCT e.nome, ec.id_cidade
FROM horus_trusted.empresa e
JOIN horus_trusted.endereco ed ON ed.fk_empresa = e.id_empresa
JOIN horus_dimensional.dim_cidade ec ON ec.cidade = ed.cidade
WHERE e.nome NOT IN (SELECT nome FROM horus_dimensional.dim_empresa);

INSERT INTO horus_dimensional.dim_setor (nome, fk_empresa)
SELECT DISTINCT s.nome, de.id_empresa
FROM horus_trusted.setor s
JOIN horus_trusted.empresa te ON te.id_empresa = s.fk_empresa
JOIN horus_dimensional.dim_empresa de ON de.nome = te.nome
WHERE s.nome NOT IN (SELECT nome FROM horus_dimensional.dim_setor);

INSERT INTO horus_dimensional.dim_painel (nome, fk_setor)
SELECT DISTINCT p.nome, ds.id_setor
FROM horus_trusted.painel p
JOIN horus_trusted.setor ts ON ts.id_setor = p.fk_setor
JOIN horus_dimensional.dim_setor ds ON ds.nome = ts.nome
WHERE p.nome NOT IN (SELECT nome FROM horus_dimensional.dim_painel);

INSERT INTO horus_dimensional.dim_tempo (horario, dia, mes, ano)
SELECT DISTINCT
    TIME(dl.data) AS horario,
    DAY(dl.data) AS dia,
    MONTH(dl.data) AS mes,
    YEAR(dl.data) AS ano
FROM horus_trusted.dados_leitura dl
WHERE NOT EXISTS (
    SELECT 1
    FROM horus_dimensional.dim_tempo dt
    WHERE dt.horario = TIME(dl.data) AND dt.dia = DAY(dl.data) AND dt.mes = MONTH(dl.data) AND dt.ano = YEAR(dl.data)
);

INSERT INTO horus_dimensional.dim_orientacao (direcionamento, inclinacao)
SELECT DISTINCT dl.direcionamento, dl.inclinacao
FROM horus_trusted.dados_leitura dl
WHERE NOT EXISTS (
    SELECT 1
    FROM horus_dimensional.dim_orientacao do
    WHERE do.direcionamento = dl.direcionamento AND do.inclinacao = dl.inclinacao
);

INSERT INTO horus_dimensional.dim_ceu (ceu)
SELECT DISTINCT dl.ceu
FROM horus_trusted.dados_leitura dl
WHERE dl.ceu NOT IN (SELECT ceu FROM horus_dimensional.dim_ceu);

INSERT INTO horus_dimensional.fato_dados (
    id_tempo, id_painel, id_orientacao, id_ceu,
    m_temp_interna, m_temp_externa, m_energia_esperada,
    m_energia_gerada, m_luminosidade, m_eficiencia,
    m_umidade, m_tensao, m_obstrucao
)
SELECT
    dt.id_tempo, dp.id_painel, do.id_orientacao, dc.id_ceu,
    dl.temperatura_interna, dl.temperatura_externa, dl.energia_esperada,
    dl.energia_gerada, dl.luminosidade, dl.eficiencia,
    dl.umidade, dl.tensao, dl.obstrucao
FROM horus_trusted.dados_leitura dl
JOIN horus_dimensional.dim_tempo dt ON dt.horario = TIME(dl.data) AND dt.dia = DAY(dl.data) AND dt.mes = MONTH(dl.data) AND dt.ano = YEAR(dl.data)
JOIN horus_dimensional.dim_painel dp ON dp.nome = (SELECT nome FROM horus_trusted.painel WHERE id_painel = dl.fk_painel)
JOIN horus_dimensional.dim_orientacao do ON do.direcionamento = dl.direcionamento AND do.inclinacao = dl.inclinacao
JOIN horus_dimensional.dim_ceu dc ON dc.ceu = dl.ceu;
