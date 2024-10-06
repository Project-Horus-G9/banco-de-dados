create database horus;

use horus;

create table endereco (
    id_endereco int not null auto_increment,
    rua varchar(100) not null,
    numero int not null,
    bairro varchar(100) not null,
    cidade varchar(100) not null,
    estado varchar(100) not null,
    cep varchar(8) not null,
    primary key (id_endereco)
);

create table empresa (
    id_empresa int not null auto_increment,
    nome varchar(100) not null,
    cnpj varchar(14) not null,
    id_endereco int not null,
    primary key (id_empresa),
    foreign key (id_endereco) references endereco(id_endereco)
);

create table usuario (
    id_usuario int not null auto_increment,
    nome varchar(100) not null,
    email varchar(100) not null,
    senha varchar(100) not null,
    id_empresa int not null,
    primary key (id_usuario),
    foreign key (id_empresa) references empresa(id_empresa)
);

create table setor (
    id_setor int not null auto_increment,
    nome varchar(100) not null,
    id_empresa int not null,
    primary key (id_setor),
    foreign key (id_empresa) references empresa(id_empresa)
);

create table painel (
    id_painel int not null auto_increment,
    nome varchar(100) not null,
    id_setor int not null,
    primary key (id_painel),
    foreign key (id_setor) references setor(id_setor)
);

create table temperatura (
    id_temperatura int not null auto_increment,
    temperatura_externa float not null,
    temperatura_interna float not null
);

create table energia (
    id_energia int not null auto_increment,
    energia_gerada float not null,
    energia_esperada float not null,
    tensao float not null,
    eficiencia float not null
);

create table info_externa (
    id_info_externa int not null auto_increment,
    direcionamento varchar(100) not null,
    inclinacao float not null
);

create table ambiente (
    id_ambiente int not null auto_increment,
    luminosidade float not null,
    ceu varchar(100) not null,
    umidade float not null,
    obstrucao varchar(100) not null
);

create table data (
    id_data int not null auto_increment,
    data_hora datetime not null
);

create table dado (
    id_dado int not null auto_increment,
    id_temperatura int not null,
    id_energia int not null,
    id_info_externa int not null,
    id_ambiente int not null,
    id_data int not null,
    primary key (id_dado),
    foreign key (id_temperatura) references temperatura(id_temperatura),
    foreign key (id_energia) references energia(id_energia),
    foreign key (id_info_externa) references info_externa(id_info_externa),
    foreign key (id_ambiente) references ambiente(id_ambiente),
    foreign key (id_data) references data(id_data)
);
