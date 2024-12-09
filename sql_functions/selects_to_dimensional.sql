INSERT INTO horus_dimensional.dim_estado (estado)
SELECT DISTINCT estado
FROM horus_trusted.endereco;

INSERT INTO horus_dimensional.dim_cidade (cidade, fk_estado)
SELECT DISTINCT e.cidade, es.id_estado
FROM horus_trusted.endereco e
JOIN horus_dimensional.dim_estado es ON e.estado = es.estado;

INSERT INTO horus_dimensional.dim_empresa (nome, fk_cidade)
SELECT DISTINCT em.nome, c.id_cidade
FROM horus_trusted.empresa em
JOIN horus_trusted.endereco e ON em.id_empresa = e.fk_empresa
JOIN horus_dimensional.dim_cidade c ON e.cidade = c.cidade;

INSERT INTO horus_dimensional.dim_setor (nome, fk_empresa)
SELECT DISTINCT s.nome, em.id_empresa
FROM horus_trusted.setor s
JOIN horus_trusted.empresa em ON s.fk_empresa = em.id_empresa;

INSERT INTO horus_dimensional.dim_painel (nome, fk_setor)
SELECT DISTINCT p.nome, s.id_setor
FROM horus_trusted.painel p
JOIN horus_trusted.setor s ON p.fk_setor = s.id_setor;

INSERT INTO horus_dimensional.dim_tempo (horario, dia, mes, ano)
SELECT DISTINCT DATE_FORMAT(d.data, '%H:%i:%s') AS horario,
                DAY(d.data) AS dia,
                MONTH(d.data) AS mes,
                YEAR(d.data) AS ano
FROM horus_trusted.dados_leitura d;

INSERT INTO horus_dimensional.dim_umidade (umidade)
SELECT DISTINCT umidade
FROM horus_trusted.dados_leitura;

INSERT INTO horus_dimensional.dim_tensao (tensao)
SELECT DISTINCT tensao
FROM horus_trusted.dados_leitura;

INSERT INTO horus_dimensional.dim_orientacao (direcionamento, inclinacao)
SELECT DISTINCT direcionamento, inclinacao
FROM horus_trusted.dados_leitura;

INSERT INTO horus_dimensional.fato_dados (
    id_tempo, id_painel, id_umidade, id_tensao, id_orientacao, 
    m_temp_interna, m_temp_externa, m_energia_esperada, m_energia_gerada, 
    m_luminosidade, m_eficiencia, m_obstrucao, m_ceu)
SELECT 
    t.id_tempo, p.id_painel, u.id_umidade, tns.id_tensao, o.id_orientacao,
    d.temperatura_interna, d.temperatura_externa, d.energia_esperada, d.energia_gerada,
    d.luminosidade, d.eficiencia, d.obstrucao, d.ceu
FROM horus_trusted.dados_leitura d
JOIN horus_dimensional.dim_tempo t ON DATE_FORMAT(d.data, '%H:%i:%s') = t.horario
JOIN horus_dimensional.dim_painel p ON d.fk_painel = p.id_painel
JOIN horus_dimensional.dim_umidade u ON d.umidade = u.umidade
JOIN horus_dimensional.dim_tensao tns ON d.tensao = tns.tensao
JOIN horus_dimensional.dim_orientacao o ON d.direcionamento = o.direcionamento 
                                         AND d.inclinacao = o.inclinacao;
