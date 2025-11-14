CREATE SCHEMA IF NOT EXISTS hospital;

ALTER DATABASE hospital SET search_path TO hospital, public;

--DROP TYPE IF EXISTS hospital.estado_reserva_enum CASCADE;
--DROP TYPE IF EXISTS hospital.vistas_enum CASCADE;

DROP TABLE IF EXISTS hospital.persona CASCADE;
DROP TABLE IF EXISTS hospital.paciente CASCADE;
DROP TABLE IF EXISTS hospital.medico CASCADE;
DROP TABLE IF EXISTS hospital.informe CASCADE;
DROP TABLE IF EXISTS hospital.hospital CASCADE;
DROP TABLE IF EXISTS hospital.area CASCADE;
DROP TABLE IF EXISTS hospital.cita CASCADE;
DROP TABLE IF EXISTS hospital.ingreso CASCADE;
DROP TABLE IF EXISTS hospital.informe CASCADE;
DROP TABLE IF EXISTS hospital.medicamento CASCADE;
DROP TABLE IF EXISTS hospital.receta CASCADE;
DROP TABLE IF EXISTS hospital.trabaja_en CASCADE;
DROP TABLE IF EXISTS hospital.informes_cita CASCADE;

--CREATE TYPE hotel.estado_reserva_enum AS ENUM ('Check-Out', 'Canceled', 'Upcoming', 'No-Show');
--CREATE TYPE hotel.vistas_enum AS ENUM ('No views', 'Partial views', 'Full views');

-- Tabla Persona
CREATE TABLE hospital.persona (
    id_persona INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    genero VARCHAR(50),
    fecha_nacimiento DATE,
    pais VARCHAR(50),
    localidad VARCHAR (50),
    codigo_postal VARCHAR(20),
    calle VARCHAR(100),
    numero VARCHAR(20),
    numero_telefono VARCHAR(20)
);

-- Tabla Paciente
CREATE TABLE hospital.paciente (
    id_paciente INT PRIMARY KEY,
    grupo_sanguineo VARCHAR(5),
    FOREIGN KEY (id_paciente) REFERENCES hospital.persona(id_persona)
);

-- Tabla Medico
CREATE TABLE hospital.medico (
    id_medico INT PRIMARY KEY,
    id_jefe INT,
    FOREIGN KEY (id_medico) REFERENCES hospital.persona(id_persona),
    FOREIGN KEY (id_jefe) REFERENCES hospital.medico(id_medico)
);

-- Tabla Informe
CREATE TABLE hospital.informe (
    id_paciente INT,
    id_informe INT,
    id_medico INT NOT NULL,
    fecha DATE NOT NULL,
    categoria VARCHAR(20),
    texto TEXT NOT NULL,
    FOREIGN KEY (id_paciente) REFERENCES hospital.paciente,
    FOREIGN KEY (id_medico) REFERENCES hospital.medico(id_medico),
    PRIMARY KEY (id_paciente, id_informe)
);

-- Tabla Hospital
CREATE TABLE hospital.hospital (
    id_hospital INT PRIMARY KEY ,
    nombre VARCHAR(50) NOT NULL,
    pais VARCHAR(50) NOT NULL,
    localidad VARCHAR(50),
    codigo_postal VARCHAR(20) NOT NULL,
    calle VARCHAR(50),
    numero VARCHAR(15),
    latitud DECIMAL(10, 8),
    longitud DECIMAL(11, 8),
    tipo VARCHAR(10)
);

-- Tabla Area
CREATE TABLE hospital.area (
    id_hospital INT,
    nombre_area VARCHAR(50),
    FOREIGN KEY (id_hospital) REFERENCES hospital.hospital,
    PRIMARY KEY (id_hospital, nombre_area)
);

-- Tabla Cita
CREATE TABLE hospital.cita (
    id_paciente INT,
    id_cita INT,
    id_medico INT NOT NULL,
    id_hospital INT NOT NULL,
    nombre_area VARCHAR(50) NOT NULL,
    fecha DATE NOT NULL,
    hora_comienzo TIME NOT NULL,
    hora_fin TIME NOT NULL,
    razon VARCHAR(50) NOT NULL,
    presencial BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (id_paciente) REFERENCES hospital.paciente,
    FOREIGN KEY (id_medico) REFERENCES hospital.medico,
    FOREIGN KEY (id_hospital, nombre_area) REFERENCES hospital.area (id_hospital, nombre_area),
    PRIMARY KEY (id_paciente, id_cita)
);
-- Tabla Ingreso
CREATE TABLE hospital.ingreso (
    id_paciente INT,
    id_cita INT,
    fecha_alta DATE NOT NULL,
    FOREIGN KEY (id_paciente, id_cita) REFERENCES hospital.cita(id_paciente, id_cita),
    PRIMARY KEY (id_paciente, id_cita)
);

-- Tabla Medicamento
CREATE TABLE hospital.medicamento (
    id_medicamento INT PRIMARY KEY ,
    nombre VARCHAR(50) NOT NULL,
    principio_activo VARCHAR(50) NOT NULL
);

-- Tabla Receta
CREATE TABLE hospital.receta (
    id_receta INT PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    id_medicamento INT NOT NULL,
    fecha DATE NOT NULL,
    razon TEXT NOT NULL,
    FOREIGN KEY (id_paciente) REFERENCES hospital.paciente(id_paciente),
    FOREIGN KEY (id_medico) REFERENCES hospital.medico(id_medico),
    FOREIGN KEY (id_medicamento) REFERENCES hospital.medicamento(id_medicamento)
);

-- Tabla Trabaja_En
CREATE TABLE hospital.trabaja_en (
    id_medico INT,
    id_hospital INT,
    nombre_area VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_medico) REFERENCES hospital.medico,
    FOREIGN KEY (id_hospital, nombre_area) REFERENCES hospital.area (id_hospital, nombre_area),
    PRIMARY KEY (id_medico, id_hospital)
);

-- Tabla InformesCita
CREATE TABLE hospital.informes_cita (
    id_paciente INT,
	id_informe INT,
    id_cita INT,
    FOREIGN KEY (id_paciente, id_informe) REFERENCES hospital.informe(id_paciente, id_informe),
    FOREIGN KEY (id_paciente, id_cita) REFERENCES hospital.cita(id_paciente, id_cita),
    PRIMARY KEY (id_informe, id_paciente, id_cita)
);