-- Inserção de dados na tabela dim_estado
INSERT INTO dim_estado (estado)
SELECT DISTINCT estado
FROM horus_trusted.endereco e
WHERE estado IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM dim_estado ds
      WHERE ds.estado = e.estado
  );

-- Inserção de dados na tabela dim_cidade
INSERT INTO dim_cidade (cidade, fk_estado)
SELECT DISTINCT e.cidade, ds.id_estado
FROM horus_trusted.endereco e
JOIN dim_estado ds ON ds.estado = e.estado
WHERE cidade IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM dim_cidade dc
      WHERE dc.cidade = e.cidade
        AND dc.fk_estado = ds.id_estado
  );

-- Inserção de dados na tabela dim_empresa
INSERT INTO dim_empresa (nome, fk_cidade)
SELECT DISTINCT nome, 
                (SELECT id_cidade FROM dim_cidade WHERE cidade = e.cidade AND fk_estado = es.id_estado LIMIT 1)
FROM horus_trusted.empresa emp
JOIN horus_trusted.endereco e ON e.id_endereco = emp.fk_endereco
JOIN dim_estado es ON es.estado = e.estado
WHERE nome IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM dim_empresa de
      WHERE de.nome = emp.nome
  );

-- Inserção de dados na tabela dim_setor
INSERT INTO dim_setor (nome, fk_empresa)
SELECT DISTINCT s.nome, de.id_empresa
FROM horus_trusted.setor s
JOIN horus_trusted.empresa e ON s.fk_empresa = e.id_empresa
JOIN dim_empresa de ON de.nome = e.nome
WHERE s.nome IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM dim_setor ds
      WHERE ds.nome = s.nome
        AND ds.fk_empresa = de.id_empresa
  );

-- Inserção de dados na tabela dim_painel
INSERT INTO dim_painel (nome, fk_setor)
SELECT DISTINCT p.nome, ds.id_setor
FROM horus_trusted.painel p
JOIN horus_trusted.setor s ON p.fk_setor = s.id_setor
JOIN dim_setor ds ON ds.nome = s.nome
WHERE p.nome IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM dim_painel dp
      WHERE dp.nome = p.nome
        AND dp.fk_setor = ds.id_setor
  );

-- Inserção de dados na tabela dim_tempo
INSERT INTO dim_tempo (horario, dia, mes, ano)
SELECT DISTINCT TIME(dl.data), DAY(dl.data), MONTH(dl.data), YEAR(dl.data)
FROM horus_trusted.dados_leitura dl
WHERE dl.data IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM dim_tempo dt
      WHERE dt.horario = TIME(dl.data)
        AND dt.dia = DAY(dl.data)
        AND dt.mes = MONTH(dl.data)
        AND dt.ano = YEAR(dl.data)
  );

-- Inserção dos dados na tabela fato_dados
INSERT INTO fato_dados (
    id_tempo,
    id_painel,
    id_orientacao,
    id_ceu,
    m_temp_interna,
    m_temp_externa,
    m_energia_esperada,
    m_energia_gerada,
    m_luminosidade,
    m_eficiencia,
    m_umidade,
    m_tensao,
    m_obstrucao
)
SELECT
    dt.id_tempo,
    dp.id_painel,
    dor.id_orientacao,
    du.id_ceu,
    dl.temperatura_interna,
    dl.temperatura_externa,
    dl.energia_esperada,
    dl.energia_gerada,
    dl.luminosidade,
    dl.eficiencia,
    dl.umidade,
    dl.tensao,
    dl.obstrucao
FROM horus_trusted.dados_leitura dl
JOIN dim_tempo dt ON dt.horario = TIME(dl.data)
                 AND dt.dia = DAY(dl.data)
                 AND dt.mes = MONTH(dl.data)
                 AND dt.ano = YEAR(dl.data)
JOIN dim_painel dp ON dp.nome = (SELECT nome FROM horus_trusted.painel WHERE id_painel = dl.fk_painel)
JOIN dim_orientacao dor ON dor.direcionamento = dl.direcionamento
                        AND dor.inclinacao = dl.inclinacao
JOIN dim_ceu du ON du.ceu = dl.ceu
WHERE dl.temperatura_interna IS NOT NULL;
