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

/*
Persoa(id_persoa, nome, apelidos, sexo, birthdate, enderezo, telefono)

Paciente(id_paciente, grupo_sanguineo)
Clave foránea: id_paciente -> Persoa(id_persoa)

Médico(id_médico, id_xefe)
Clave foránea: id_médico -> Persoa(id_persoa)
Clave foránea: id_xefe -> Médico(id_medico)

Informe(id_paciente, id_informe, feito_por, fecha, categoría, texto)
Clave foránea: id_paciente -> Paciente(id_paciente)
Clave foránea: feito_por-> Médico(id_medico)

Medicamento(id_medicamento, nome, principio_activo)

Receita(id_paciente, id_medico, id_medicamento, fecha, razon)
Clave foránea: id_paciente -> Paciente(id_paciente)
Clave foránea: id_medico -> Médico(id_medico)
Clave foránea: id_medicamento -> Medicamento(id_medicamento)


Hospital(id_hospital, nombre, pais, localidad, codigo_postal, calle, numero, latitud, longitud, tipo)



Area(id_hospital, nome_area)
Clave foránea: id_hospital -> Hospital(id_hospital)

TraballaEn(id_medico, id_hospital, nome_area)
Clave foránea: id_medico -> Médico(id_medico)
Clave foránea: id_hospital, nome_area -> Area(id_hospital, nome_area)

Cita(id_paciente, id_cita, id_medico, id_hopsital, nome_area, fecha, hora_comezo, hora_finalización, razon, presencial)
Clave foránea: id_paciente -> Paciente(id_paciente)
Clave foránea: id_medico -> Médico(id_medico)
Clave foránea: id_hospital, nome_area -> Area(id_hospital, nome_area)


Ingreso(id_cita, fecha_alta)

InformesCita(id_informe, id_cita)
*/


CREATE TYPE hotel.estado_reserva_enum AS ENUM ('Check-Out', 'Canceled', 'Upcoming', 'No-Show');
CREATE TYPE hotel.vistas_enum AS ENUM ('No views', 'Partial views', 'Full views');

-- Tabla Hotel
CREATE TABLE hotel.hotel (
    id_hotel VARCHAR(9) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    rua VARCHAR(100) NOT NULL,
    portal INT NOT NULL,
    cod_postal VARCHAR(12) NOT NULL,
    localidade VARCHAR(100) NOT NULL,
    pais VARCHAR(50) NOT NULL
);

-- Tabla Traballador
CREATE TABLE hotel.traballador (
    id_traballador VARCHAR(9) PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    apelidos VARCHAR(100),
    posto VARCHAR(50) NOT NULL
);

-- Tabla Contrata
CREATE TABLE hotel.contrata (
    id_contrato SERIAL PRIMARY KEY,
    id_traballador VARCHAR(9),
    id_hotel VARCHAR(9),
    data_comezo DATE NOT NULL,
    duracion INT NOT NULL,
    salario DECIMAL(10, 2) CHECK (salario > 0),
    FOREIGN KEY (id_hotel) REFERENCES hotel.hotel,
    FOREIGN KEY (id_traballador) REFERENCES hotel.traballador
);

-- Tabla Servizo
CREATE TABLE hotel.servizo (
    id_hotel VARCHAR(9),
    nome VARCHAR(50),
    precio DECIMAL(10, 2) NOT NULL,
    descricion VARCHAR(200) DEFAULT '',
    PRIMARY KEY (id_hotel, nome),
    FOREIGN KEY (id_hotel) REFERENCES hotel.hotel
);

-- Tabla Cliente
CREATE TABLE hotel.cliente (
    id_cliente VARCHAR(9) PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    apelidos VARCHAR(100) NOT NULL,
    rua VARCHAR(100),
    portal INT,
    localidade VARCHAR(100),
    provincia VARCHAR(100),
    rexion VARCHAR(100),
	cod_postal VARCHAR(12),
    pais VARCHAR(100)
);

-- Tabla Reserva
CREATE TABLE hotel.reserva (
    id INT PRIMARY KEY,
    id_cliente VARCHAR(9) NOT NULL,
    id_hotel VARCHAR(9) NOT NULL,
    data_reserva DATE NOT NULL,
    data_chegada DATE NOT NULL,
    duracion INT NOT NULL CHECK (duracion > 0),
    n_adultos INT NOT NULL CHECK (n_adultos > 0),
    n_nenos INT NOT NULL CHECK (n_nenos >= 0),
    precio DECIMAL(10, 2) CHECK (precio >= 0),
    estado hotel.estado_reserva_enum DEFAULT 'Upcoming',
    FOREIGN KEY (id_hotel) REFERENCES hotel.hotel,
    FOREIGN KEY (id_cliente) REFERENCES hotel.cliente
);

-- Tabla Servizos_Reserva
CREATE TABLE hotel.servizos_reserva (
    id INT,
    id_hotel VARCHAR(9),
    nome VARCHAR(50),
    PRIMARY KEY (id, id_hotel, nome),
    FOREIGN KEY (id) REFERENCES hotel.reserva,
    FOREIGN KEY (id_hotel, nome) REFERENCES hotel.servizo
);

-- Tabla Lugar
CREATE TABLE hotel.lugar (
    id_hotel VARCHAR(9),
    piso INT,
    nome VARCHAR(50),
    anotacions VARCHAR(500) DEFAULT '',
    PRIMARY KEY (id_hotel, piso, nome),
    FOREIGN KEY (id_hotel) REFERENCES hotel.hotel
);

-- Tabla Tipo_Habitación
CREATE TABLE hotel.tipo_habitacion (
    id SERIAL PRIMARY KEY,
    numero_camas DECIMAL(3, 1) NOT NULL,
    descricion VARCHAR(200),
    baño BOOLEAN,
    balcon BOOLEAN,
    cociña BOOLEAN,
    vistas hotel.vistas_enum,
    cortina_blackout BOOLEAN
);

-- Tabla Habitación
CREATE TABLE hotel.habitacion (
    id_hotel VARCHAR(9),
    piso INT,
    nome VARCHAR(50),
    tipo_habitacion INT,
    PRIMARY KEY (id_hotel, piso, nome),
    FOREIGN KEY (id_hotel, piso, nome) REFERENCES hotel.lugar,
    FOREIGN KEY (tipo_habitacion) REFERENCES hotel.tipo_habitacion(id)
);

-- Tabla Habitacións_Reserva
CREATE TABLE hotel.habitacions_reserva (
    id INT,
    id_hotel VARCHAR(9),
    piso INT,
    nome VARCHAR(50),
    PRIMARY KEY (id, id_hotel, piso, nome),
    FOREIGN KEY (id) REFERENCES hotel.reserva,
    FOREIGN KEY (id_hotel, piso, nome) REFERENCES hotel.habitacion
);

-- Tabla Contacto
CREATE TABLE hotel.contacto (
	id INT,
    id_cliente VARCHAR(9),
    PRIMARY KEY (id, id_cliente),
    FOREIGN KEY (id_cliente) REFERENCES hotel.cliente
);

-- Tabla Telefono
CREATE TABLE hotel.telefono (
    id INT,
    id_cliente VARCHAR(9),
    telefono VARCHAR(25) NOT NULL,
    PRIMARY KEY (id, id_cliente),
    FOREIGN KEY (id, id_cliente) REFERENCES hotel.contacto
);

-- Tabla Correo_electrónico
CREATE TABLE hotel.correo_electronico (
    id INT,
    id_cliente VARCHAR(9),
    direcion VARCHAR(50) NOT NULL,
    PRIMARY KEY (id, id_cliente),
    FOREIGN KEY (id, id_cliente) REFERENCES hotel.contacto
);

-- Tabla Incidencia
CREATE TABLE hotel.incidencia (
    id_incidencia SERIAL PRIMARY KEY,
    descricion VARCHAR(500) NOT NULL,
    data_incidencia DATE NOT NULL,
    resolta BOOLEAN DEFAULT False,
    coste_solucion DECIMAL(10, 2) DEFAULT 0
);

-- Tabla Incide
CREATE TABLE hotel.incide (
    id_incidencia INT,
    id_hotel VARCHAR(9),
    piso INT,
    nome VARCHAR(50),
    PRIMARY KEY (id_incidencia, id_hotel, piso, nome),
    FOREIGN KEY (id_incidencia) REFERENCES hotel.incidencia,
    FOREIGN KEY (id_hotel, piso, nome) REFERENCES hotel.lugar
);

-- Tabla Soluciona
CREATE TABLE hotel.soluciona (
    id_incidencia INT,
    id_traballador VARCHAR(9),
    PRIMARY KEY (id_traballador, id_incidencia),
    FOREIGN KEY (id_traballador) REFERENCES hotel.traballador,
    FOREIGN KEY (id_incidencia) REFERENCES hotel.incidencia
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
