DROP DATABASE IF EXISTS horus_dimensional;

CREATE DATABASE horus_dimensional;

USE horus_dimensional;

CREATE TABLE dim_estado(
	id_estado INT PRIMARY KEY AUTO_INCREMENT,
    estado varchar(45)
);

CREATE TABLE dim_cidade(
	id_cidade INT PRIMARY KEY AUTO_INCREMENT,
    cidade varchar(45),
    fk_estado int,
    FOREIGN KEY (fk_estado) REFERENCES dim_estado(id_estado) ON DELETE CASCADE
);

CREATE TABLE dim_empresa(
	id_empresa INT PRIMARY KEY AUTO_INCREMENT,
    nome varchar(100),
    fk_cidade int,
    FOREIGN KEY (fk_cidade) REFERENCES dim_cidade(id_cidade) ON DELETE CASCADE
);

CREATE TABLE dim_setor(
	id_setor INT PRIMARY KEY AUTO_INCREMENT,
    nome varchar(45),
    fk_empresa int,
    FOREIGN KEY (fk_empresa) REFERENCES dim_empresa(id_empresa) ON DELETE CASCADE
);

CREATE TABLE dim_painel(
	id_painel INT PRIMARY KEY AUTO_INCREMENT,
    nome varchar(45),
    fk_setor int,
    FOREIGN KEY (fk_setor) REFERENCES dim_setor(id_setor) ON DELETE CASCADE
);

CREATE TABLE dim_tempo(
	id_tempo INT PRIMARY KEY AUTO_INCREMENT,
    horario TIME,
    dia int,
    mes int,
    ano int
);

CREATE TABLE dim_orientacao(
	id_orientacao INT PRIMARY KEY AUTO_INCREMENT,
    direcionamento varchar(45),
    inclinacao float
);

CREATE TABLE dim_ceu(
    id_ceu INT PRIMARY KEY AUTO_INCREMENT,
    ceu varchar(45)
);

CREATE TABLE fato_dados(
	id_dados INT PRIMARY KEY AUTO_INCREMENT,
    id_tempo int,
    id_painel int,
    id_orientacao int,
    id_ceu int,
    m_temp_interna float,
    m_temp_externa float,
    m_energia_esperada float,
    m_energia_gerada float,
    m_luminosidade float,
    m_eficiencia float,
    m_umidade float,
    m_tensao float,
    m_obstrucao float,
    FOREIGN KEY (id_painel) REFERENCES dim_painel(id_painel) ON DELETE CASCADE,
    FOREIGN KEY (id_tempo) REFERENCES dim_tempo(id_tempo) ON DELETE CASCADE,
    FOREIGN KEY (id_orientacao) REFERENCES dim_orientacao(id_orientacao) ON DELETE CASCADE,
    FOREIGN KEY (id_ceu) REFERENCES dim_ceu(id_ceu) ON DELETE CASCADE
);