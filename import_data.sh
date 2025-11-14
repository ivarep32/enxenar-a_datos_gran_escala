# Asignar la contraseña de PostgreSQL
PGPASSWORD=pwalumnobd

# Paso 1: Ejecutar el archivo HospitalSchema.sql para crear las tablas y restricciones
psql -U alumnobd -d hospital -f HospitalSchema.sql

# Paso 2: Establecer el search_path para evitar errores
psql -U alumnobd -d hospital -c "SET search_path TO hospital, public;"

# Paso 3: Importar datos usando una única transacción y \COPY
psql -U alumnobd -d hospital <<EOF
BEGIN TRANSACTION;

\copy hospital.persona           from Persona.csv           delimiter ',' csv header;
\copy hospital.paciente          from Paciente.csv          delimiter ',' csv header;
\copy hospital.medico            from Medico.csv            delimiter ',' csv header;
\copy hospital.hospital          from Hospital.csv          delimiter ',' csv header;
\copy hospital.area              from Areas.csv              delimiter ',' csv header;
\copy hospital.cita              from Cita.csv              delimiter ',' csv header;
\copy hospital.ingreso           from Ingreso.csv           delimiter ',' csv header;
\copy hospital.informe           from Informe.csv           delimiter ',' csv header;
\copy hospital.medicamento       from Medicamento.csv       delimiter ',' csv header;
\copy hospital.receta            from Receta.csv            delimiter ',' csv header;
\copy hospital.trabaja_en        from TrabajaEn.csv        delimiter ',' csv header;
\copy hospital.informe_cita      from InformeCita.csv      delimiter ',' csv header;

COMMIT;
EOF
