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
DROP TABLE IF EXISTS hospital.informe_cita CASCADE;

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
    id_paciente INT PRIMARY KEY,
    id_informe INT PRIMARY KEY,
    id_medico INT NOT NULL,
    fecha DATE NOT NULL,
    categoria VARCHAR(20),
    texto TEXT NOT NULL,
    FOREIGN KEY (id_paciente) REFERENCES hospital.paciente,
    FOREIGN KEY (id_medico) REFERENCES hospital.medico(id_medico)
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
    id_hospital INT PRIMARY KEY ,
    nombre_area VARCHAR(50) PRIMARY KEY ,
    FOREIGN KEY (id_hospital) REFERENCES hospital.hospital
);

-- Tabla Cita
CREATE TABLE hospital.cita (
    id_paciente INT PRIMARY KEY ,
    id_cita INT PRIMARY KEY ,
    id_medico INT NOT NULL,
    id_hospital INT NOT NULL,
    nombre_area INT NOT NULL,
    fecha DATE NOT NULL,
    hora_comienzo TIME NOT NULL,
    hora_fin TIME NOT NULL,
    razon VARCHAR(50) NOT NULL,
    presencial BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (id_paciente) REFERENCES hospital.paciente,
    FOREIGN KEY (id_medico) REFERENCES hospital.medico,
    FOREIGN KEY (id_hospital, nombre_area) REFERENCES hospital.area
);
-- Tabla Ingreso
CREATE TABLE hospital.ingreso (
    id_cita VARCHAR(9) PRIMARY KEY,
    fecha_alta DATE NOT NULL,
    FOREIGN KEY (id_cita) REFERENCES hospital.cita

);

-- Tabla Medicamento
CREATE TABLE hospital.medicamento (
    id_medicamento VARCHAR(9) PRIMARY KEY ,
    nombre VARCHAR(20) NOT NULL,
    principio_activo VARCHAR(20) NOT NULL
);

-- Tabla Receta
CREATE TABLE hospital.receta (
    id_paciente VARCHAR(9) PRIMARY KEY ,
    id_medico VARCHAR(9) PRIMARY KEY,
    id_medicamento VARCHAR(9) PRIMARY KEY,
    fecha DATE NOT NULL,
    razon TEXT NOT NULL,
    FOREIGN KEY (id_paciente) REFERENCES hospital.paciente(id_paciente),
    FOREIGN KEY (id_medico) REFERENCES hospital.medico(id_medico),
    FOREIGN KEY (id_medicamento) REFERENCES hospital.medicamento(id_medicamento)

);

-- Tabla Trabaja_En
CREATE TABLE hospital.trabajaEn (
    id_medico VARCHAR(9) NOT NULL,
    id_hospital VARCHAR(9) NOT NULL,
    nombre_area VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_medico) REFERENCES hospital.medico,
    FOREIGN KEY (id_hospital, nombre_area) REFERENCES hospital.area
);

-- Tabla InformesCita
CREATE TABLE hospital.informesCita (
	id_informe VARCHAR(9) PRIMARY KEY ,
    id_cita VARCHAR(9) PRIMARY KEY ,
    FOREIGN KEY (id_informe) REFERENCES hospital.informe,
    FOREIGN KEY (id_cita) REFERENCES hospital.cita
);

-- RESTRICCIÓNS

-- Función para asegurar que cada cliente tenga al menos un contacto
CREATE OR REPLACE FUNCTION verificar_contactos_cliente_func()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM hotel.contacto 
        WHERE contacto.id_cliente = COALESCE(OLD.id_cliente, NEW.id_cliente)
    ) THEN
        RAISE EXCEPTION 'Cada cliente debe ter como mínimo un contacto asociado.';
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Trigger para verificar contactos cuando añadimos el cliente
CREATE CONSTRAINT TRIGGER verificar_contactos_en_cliente
AFTER INSERT OR UPDATE ON hotel.cliente
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION verificar_contactos_cliente_func();

-- Trigger para verificar contactos cuando modificamos los contactos
CREATE CONSTRAINT TRIGGER verificar_contactos_en_contactos
AFTER UPDATE OR DELETE ON hotel.contacto
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION verificar_contactos_cliente_func();

-- Función para asegurar que todas las tuplas de contacto estén referenciadas
CREATE OR REPLACE FUNCTION verificar_herdanza_total_contacto_func()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM hotel.telefono WHERE telefono.id = COALESCE(OLD.id, NEW.id)
    ) AND NOT EXISTS (
        SELECT 1 FROM hotel.correo_electronico WHERE correo_electronico.id = COALESCE(OLD.id, NEW.id)
    ) THEN
        RAISE EXCEPTION 'Todas as tuplas de contacto deben estar referenciadas en telefono ou correo_electronico.';
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Trigger para verificar herencia total contacto
CREATE CONSTRAINT TRIGGER verificar_herdanza_total_contacto
AFTER INSERT OR UPDATE OR DELETE ON hotel.contacto
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION verificar_herdanza_total_contacto_func();


-- Función para verificar servicios reserva
CREATE OR REPLACE FUNCTION verificar_servizos_reserva_func()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM hotel.servizos_reserva sr
        JOIN hotel.reserva r ON sr.id = r.id
        WHERE sr.id_hotel <> r.id_hotel
    ) THEN
        RAISE EXCEPTION 'Os servizos deben pertencer ao mesmo hotel da reserva.';
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Trigger para verificar servicios reserva
CREATE TRIGGER verificar_servizos_reserva
AFTER INSERT OR UPDATE ON hotel.servizos_reserva
FOR EACH ROW
EXECUTE FUNCTION verificar_servizos_reserva_func();

-- Función para verificar habitaciones reserva
CREATE OR REPLACE FUNCTION verificar_habitacions_reserva_func()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM hotel.habitacions_reserva hr
        JOIN hotel.reserva r ON hr.id = r.id
        WHERE hr.id_hotel <> r.id_hotel
    ) THEN
        RAISE EXCEPTION 'As habitacións deben pertencer ao mesmo hotel da reserva.';
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Trigger para verificar habitaciones reserva
CREATE TRIGGER verificar_habitacions_reserva
AFTER INSERT OR UPDATE ON hotel.habitacions_reserva
FOR EACH ROW
EXECUTE FUNCTION verificar_habitacions_reserva_func();

-- Función para verificar mínimo habitaciones en una reserva
CREATE OR REPLACE FUNCTION verificar_minimo_habitacions_reserva_func()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM hotel.habitacions_reserva
        WHERE id = COALESCE(OLD.id, NEW.id)
    ) THEN
        RAISE EXCEPTION 'Cada reserva debe ter como mínimo unha habitación asociada.';
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Trigger para verificar al modificar o insertar en reserva
CREATE CONSTRAINT TRIGGER verificar_minimo_habitacions_reserva_reserva
AFTER INSERT OR UPDATE ON hotel.reserva
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION verificar_minimo_habitacions_reserva_func();

-- Trigger para verificar al eliminar en habitacions_reserva
CREATE CONSTRAINT TRIGGER verificar_minimo_habitacions_reserva_habitacions
AFTER UPDATE OR DELETE ON hotel.habitacions_reserva
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION verificar_minimo_habitacions_reserva_func();
