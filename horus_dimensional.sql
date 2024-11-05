DROP DATABASE horus_dimensional;

CREATE DATABASE horus_dimensional;

USE horus_dimensional;

CREATE TABLE dim_empresa(
	id_empresa INT PRIMARY KEY AUTO_INCREMENT,
    nome varchar(100)
);

CREATE TABLE estado(
	id_estado INT PRIMARY KEY AUTO_INCREMENT,
    estado varchar(45),
    fk_empresa int,
    FOREIGN KEY (fk_empresa) REFERENCES dim_empresa(id_empresa) ON DELETE CASCADE
);

CREATE TABLE cidade(
	id_cidade INT PRIMARY KEY AUTO_INCREMENT,
    cidade varchar(45),
    fk_estado int,
    FOREIGN KEY (fk_estado) REFERENCES estado(id_estado) ON DELETE CASCADE
);

CREATE TABLE dim_setor(
	id_setor INT PRIMARY KEY AUTO_INCREMENT,
    nome varchar(45)
);

CREATE TABLE dim_painel(
	id_painel INT PRIMARY KEY AUTO_INCREMENT,
    nome varchar(45)
);

CREATE TABLE dim_tempo(
	id_tempo INT PRIMARY KEY AUTO_INCREMENT,
    horario TIME,
    dia int,
    mes int,
    ano int
);

CREATE TABLE dim_umidade(
	id_umidade INT PRIMARY KEY AUTO_INCREMENT,
    umidade float
);

CREATE TABLE dim_obstrucao(
	id_obstrucao INT PRIMARY KEY AUTO_INCREMENT,
    obstrucao varchar(45)
);

CREATE TABLE dim_ceu(
	id_ceu INT PRIMARY KEY AUTO_INCREMENT,
    ceu varchar(45),
    luminosidade float
);

CREATE TABLE dim_energia(
	id_energia INT PRIMARY KEY AUTO_INCREMENT,
    energia_esperada float,
    energia_gerada float,
    eficiencia float
);

CREATE TABLE dim_tensao(
	id_tensao INT PRIMARY KEY AUTO_INCREMENT,
    tensao float
);

CREATE TABLE dim_orientacao(
	id_orientacao INT PRIMARY KEY AUTO_INCREMENT,
    direcionamento varchar(45),
    inclinacao float
);

CREATE TABLE fato_dados(
	id_dados INT PRIMARY KEY AUTO_INCREMENT,
    id_setor int,
    id_painel int,
    id_empresa int,
    id_umidade int,
    id_obstrucao int,
    id_ceu int,
    id_energia int,
    id_tensao int,
    id_orientacao int,
    m_temp_interna float,
    m_temp_externa float,
    FOREIGN KEY (id_setor) REFERENCES dim_setor(id_setor) ON DELETE CASCADE,
    FOREIGN KEY (id_painel) REFERENCES dim_painel(id_painel) ON DELETE CASCADE,
    FOREIGN KEY (id_empresa) REFERENCES dim_empresa(id_empresa) ON DELETE CASCADE,
    FOREIGN KEY (id_umidade) REFERENCES dim_umidade(id_umidade) ON DELETE CASCADE,
    FOREIGN KEY (id_obstrucao) REFERENCES dim_obstrucao(id_obstrucao) ON DELETE CASCADE,
    FOREIGN KEY (id_ceu) REFERENCES dim_ceu(id_ceu) ON DELETE CASCADE,
    FOREIGN KEY (id_energia) REFERENCES dim_energia(id_energia) ON DELETE CASCADE,
    FOREIGN KEY (id_tensao) REFERENCES dim_tensao(id_tensao) ON DELETE CASCADE,
    FOREIGN KEY (id_orientacao) REFERENCES dim_orientacao(id_orientacao) ON DELETE CASCADE
);