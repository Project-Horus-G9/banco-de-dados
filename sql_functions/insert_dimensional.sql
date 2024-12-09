INSERT INTO horus_dimensional.dim_estado (estado)
SELECT DISTINCT e.estado
FROM horus_trusted.endereco e
INNER JOIN horus_trusted.empresa em ON e.fk_empresa = em.id_empresa;


INSERT INTO horus_dimensional.dim_cidade (cidade, fk_estado)
SELECT DISTINCT e.cidade, ds.id_estado
FROM horus_trusted.endereco e
INNER JOIN horus_trusted.empresa em ON e.fk_empresa = em.id_empresa
INNER JOIN horus_dimensional.dim_estado ds ON e.estado = ds.estado;


INSERT INTO horus_dimensional.dim_empresa (nome, fk_cidade)
SELECT DISTINCT em.nome, dc.id_cidade
FROM horus_trusted.empresa em
INNER JOIN horus_trusted.endereco e ON e.fk_empresa = em.id_empresa
INNER JOIN horus_dimensional.dim_cidade dc ON e.cidade = dc.cidade;

INSERT INTO horus_dimensional.dim_setor (nome, fk_empresa)
SELECT DISTINCT s.nome, de.id_empresa
FROM horus_trusted.setor s
INNER JOIN horus_trusted.empresa em ON s.fk_empresa = em.id_empresa
INNER JOIN horus_dimensional.dim_empresa de ON em.nome = de.nome;

INSERT INTO horus_dimensional.dim_painel (nome, fk_setor)
SELECT DISTINCT p.nome, ds.id_setor
FROM horus_trusted.painel p
INNER JOIN horus_trusted.setor s ON p.fk_setor = s.id_setor
INNER JOIN horus_dimensional.dim_setor ds ON s.nome = ds.nome;

INSERT INTO horus_dimensional.dim_tempo (horario, dia, mes, ano)
SELECT DISTINCT 
    TIME(dl.data), 
    DAY(dl.data), 
    MONTH(dl.data), 
    YEAR(dl.data)
FROM horus_trusted.dados_leitura dl;


INSERT INTO horus_dimensional.dim_umidade (umidade)
SELECT DISTINCT dl.umidade
FROM horus_trusted.dados_leitura dl;

INSERT INTO horus_dimensional.dim_tensao (tensao)
SELECT DISTINCT dl.tensao
FROM horus_trusted.dados_leitura dl;

INSERT INTO horus_dimensional.dim_orientacao (direcionamento, inclinacao)
SELECT DISTINCT dl.direcionamento, dl.inclinacao
FROM horus_trusted.dados_leitura dl;

INSERT INTO horus_dimensional.fato_dados (
    id_tempo, 
    id_painel, 
    id_umidade, 
    id_tensao, 
    id_orientacao, 
    m_temp_interna, 
    m_temp_externa, 
    m_energia_esperada, 
    m_energia_gerada, 
    m_luminosidade, 
    m_eficiencia, 
    m_obstrucao, 
    m_ceu
)
SELECT 
    dt.id_tempo,
    dp.id_painel,
    du.id_umidade,
    dtens.id_tensao,
    dor.id_orientacao,
    dl.temperatura_interna,
    dl.temperatura_externa,
    dl.energia_esperada,
    dl.energia_gerada,
    dl.luminosidade,
    dl.eficiencia,
    dl.obstrucao,
    dl.ceu
FROM horus_trusted.dados_leitura dl
INNER JOIN horus_dimensional.dim_tempo dt ON TIME(dl.data) = dt.horario 
    AND DAY(dl.data) = dt.dia AND MONTH(dl.data) = dt.mes AND YEAR(dl.data) = dt.ano
INNER JOIN horus_dimensional.dim_painel dp ON dl.fk_painel = dp.id_painel
INNER JOIN horus_dimensional.dim_umidade du ON dl.umidade = du.umidade
INNER JOIN horus_dimensional.dim_tensao dtens ON dl.tensao = dtens.tensao
INNER JOIN horus_dimensional.dim_orientacao dor ON dl.direcionamento = dor.direcionamento 
    AND dl.inclinacao = dor.inclinacao;