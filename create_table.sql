CREATE SCHEMA if not exists Clinic;

use Clinic;

CREATE TABLE if not exists Criatura(
	id_criatura INTEGER UNSIGNED AUTO_INCREMENT,
    nombre_criatura VARCHAR(30) NOT NULL,
    especie ENUM('cíclope','hada','unicornio', 'minotauro', 'zombi','fénix','ogra', 'grifo', 
    'elfo', 'djinn', 'leprechaun', 'elfa', 'dragón', 'gnoma', 'sirena', 'troll', 'vampiro', 
    'dragona', 'ogro', 'ninfa', 'gnomo', 'minotaura', 'vampiresa', 'tritón') not null,
    sexo ENUM('M', 'H') not null,
	PRIMARY KEY (id_criatura),
    unique(nombre_criatura, especie, sexo)
);

CREATE TABLE if not exists Enfermedad(
	id_enfermedad integer unsigned auto_increment,
    nombre_enfermedad varchar(50) unique not null,
	PRIMARY KEY (id_enfermedad)    
);


CREATE TABLE if not exists Personal(
	id_personal integer unsigned auto_increment,
    nombre_personal varchar(50) not null,
    ssexo enum('M', 'H') not null,
    especialidad enum('Rituales de Revitalización', 'Pociones de la Eternidad', 'Terapias de Aliento de Dragón',
 'Curación de Maldiciones Leves', 'Tratamientos de Invisibilidad', 'Encantamientos de Fortaleza', 
 'Terapias de Transformación', 'Encantamientos de Belleza', 'Curación de Maldiciones Graves'),
    rol_personal enum('Encargado', 'Asistente', 'Director', 'Aprendiz', 'Maestro')  not null,
    PRIMARY KEY (id_personal),
    UNIQUE(nombre_personal, ssexo, especialidad, rol_personal)
);

CREATE TABLE if not exists Tratamiento(
	id_tratamiento integer unsigned auto_increment,
    nombre_tratamiento varchar(50) unique not null,
    descripcion_tratamiento varchar(100),
    id_enfermedad integer not null unique not null,
    PRIMARY KEY(id_tratamiento)
);

CREATE TABLE if not exists Ingrediente(
	id_ingrediente integer unsigned auto_increment,
    nombre_ingrediente varchar(50) unique not null,
    precio integer not null,
    PRIMARY KEY(id_ingrediente)
);


CREATE TABLE if not exists enfermo(
	id_criatura integer unsigned,
    id_enfermedad integer unsigned,
    PRIMARY KEY (id_criatura, id_enfermedad),
    CONSTRAINT
		FOREIGN KEY (id_criatura)
        REFERENCES Criatura(id_criatura)
        on delete restrict
        on update cascade,
	
    CONSTRAINT
		FOREIGN KEY (id_enfermedad)
        REFERENCES Enfermedad(id_enfermedad)
        on delete restrict
        on update cascade
);



CREATE TABLE if not exists necesita(
	id_tratamiento integer unsigned,
    id_ingrediente integer unsigned,
    PRIMARY KEY (id_tratamiento, id_ingrediente),
    
    CONSTRAINT
		FOREIGN KEY (id_tratamiento)
        REFERENCES Tratamiento(id_tratamiento)
        on delete restrict
        on update cascade,
	
    CONSTRAINT
		FOREIGN KEY (id_ingrediente)
        REFERENCES Ingrediente(id_ingrediente)
        on delete restrict
        on update cascade    
);


CREATE TABLE if not exists cita(
	id_criatura integer unsigned,
    id_personal integer unsigned,
    fecha_y_hora datetime,
    id_tratamiento integer unsigned default 0,
    PRIMARY KEY (id_criatura, id_personal, fecha_y_hora, id_tratamiento),
    
    CONSTRAINT
		FOREIGN KEY (id_criatura)
        REFERENCES Criatura(id_criatura)
        on delete restrict
        on update cascade,
	
    CONSTRAINT
		FOREIGN KEY (id_personal)
        REFERENCES Personal(id_personal)
        on delete restrict
        on update cascade    

    
);