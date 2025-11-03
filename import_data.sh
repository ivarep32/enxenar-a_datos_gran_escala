# Asignar la contraseña de PostgreSQL password para la autentificación
PGPASSWORD=greibd2021

# Paso 1: Ejecutar el archivo HotelSchema.sql para crear las tablas y restricciones
psql -U alumnogreibd -d hotel -f HotelSchema.sql

# Paso 2: Especificar el "search_path" explícitamente para evitar errores de carga en esquemas equivocados
psql -U alumnogreibd -d hotel -c "SET search_path TO hotel, public;"


# Paso 3: Importar datos utilizando un único bloque para la transacción y el comando \COPY
psql -U alumnogreibd -d hotel <<EOF
BEGIN TRANSACTION;

-- Importar los datos
\copy hotel.hotel from Hotel.csv delimiter ',' csv header;
\copy hotel.traballador from Traballador.csv delimiter ',' csv header;
\copy hotel.contrata(id_traballador, id_hotel, data_comezo, duracion, salario) from Contrata.csv delimiter ',' csv header;
\copy hotel.servizo from Servizo.csv delimiter ',' csv header;
\copy hotel.cliente from Cliente.csv delimiter ',' csv header;
\copy hotel.reserva from Reserva.csv delimiter ',' csv header;
\copy hotel.servizos_reserva from Servizos_reserva.csv delimiter ',' csv header;
\copy hotel.lugar from Lugar.csv delimiter ',' csv header;
\copy hotel.tipo_habitacion(numero_camas, descricion, baño, balcon, cortina_blackout, cociña, vistas) from Tipo_habitacion.csv delimiter ',' csv header;
\copy hotel.habitacion from Habitacion.csv delimiter ',' csv header;
\copy hotel.habitacions_reserva from Habitacions_reserva.csv delimiter ',' csv header;
\copy hotel.contacto from Contacto.csv delimiter ',' csv header;
\copy hotel.telefono from Telefono.csv delimiter ',' csv header;
\copy hotel.correo_electronico from Correo_electronico.csv delimiter ',' csv header;
\copy hotel.incidencia(descricion, data_incidencia, resolta, coste_solucion) from Incidencia.csv delimiter ',' csv header;
\copy hotel.incide from Incide.csv delimiter ',' csv header;
\copy hotel.soluciona from Soluciona.csv delimiter ',' csv header;

COMMIT;
EOF
