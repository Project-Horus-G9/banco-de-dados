CREATE DATABASE horus_trusted;

USE horus_trusted;

CREATE TABLE empresa(
    id_empresa  INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    cnpj CHAR(14)
);

CREATE TABLE usuario(
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    email VARCHAR(100),
    senha VARCHAR(100),
    fk_empresa INT,
    FOREIGN KEY (fk_empresa) REFERENCES empresa(id_empresa) ON DELETE CASCADE
);

CREATE TABLE endereco(
    id_endereco INT PRIMARY KEY AUTO_INCREMENT,
    rua VARCHAR(100),
    numero INT,
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    estado VARCHAR(100),
    cep CHAR(8),
    fk_empresa INT,
    FOREIGN KEY (fk_empresa) REFERENCES empresa(id_empresa) ON DELETE CASCADE
);

CREATE TABLE setor(
    id_setor  INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    fk_empresa INT,
    FOREIGN KEY (fk_empresa) REFERENCES empresa(id_empresa) ON DELETE CASCADE
);

CREATE TABLE painel(
    id_painel INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45),
    fk_setor INT,
    FOREIGN KEY (fk_setor) REFERENCES setor(id_setor) ON DELETE CASCADE
);

CREATE TABLE dados_leitura(
    id_dados_leitura INT PRIMARY KEY AUTO_INCREMENT,
    temperatura_interna FLOAT,
    temperatura_externa FLOAT,
    energia_gerada FLOAT,
    energia_esperada FLOAT,
    tensao FLOAT,
    eficiencia FLOAT,
    direcionamento VARCHAR(45),
    inclinacao FLOAT,
    luminosidade FLOAT,
    ceu VARCHAR(45),
    umidade FLOAT,
    obstrucao VARCHAR(45),
    data DATETIME,
    fk_painel INT,
    fk_setor INT,                -- Referência para setor
    fk_empresa INT,              -- Referência para empresa
    fk_usuario INT,              -- Referência para usuário
    fk_endereco INT,             -- Referência para endereço
    FOREIGN KEY (fk_painel) REFERENCES painel(id_painel) ON DELETE CASCADE,
    FOREIGN KEY (fk_setor) REFERENCES setor(id_setor) ON DELETE CASCADE,
    FOREIGN KEY (fk_empresa) REFERENCES empresa(id_empresa) ON DELETE CASCADE,
    FOREIGN KEY (fk_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (fk_endereco) REFERENCES endereco(id_endereco) ON DELETE CASCADE
);
