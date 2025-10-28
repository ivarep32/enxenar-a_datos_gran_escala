# enxenar-a_datos_gran_escala
TO DO:

Informe(id_paciente, id_informe, feito_por, fecha, categoría, texto) - empiezo 
Clave foránea: id_paciente -> Paciente(id_paciente)
Clave foránea: feito_por-> Médico(id_medico)

Medicamento(id_medicamento, nome, principio_activo)

Receita(id_paciente, id_medico, id_medicamento, fecha, razon)
Clave foránea: id_paciente -> Paciente(id_paciente)
Clave foránea: id_medico -> Médico(id_medico)
Clave foránea: id_medicamento -> Medicamento(id_medicamento)


TraballaEn(id_medico, id_hospital, nome_area)
Clave foránea: id_medico -> Médico(id_medico)
Clave foránea: id_hospital, nome_area -> Area(id_hospital, nome_area)

Cita(id_paciente, id_cita, id_medico, id_hopsital, nome_area, fecha, hora_comezo, hora_finalización, razon, presencial)
Clave foránea: id_paciente -> Paciente(id_paciente)
Clave foránea: id_medico -> Médico(id_medico)
Clave foránea: id_hospital, nome_area -> Area(id_hospital, nome_area)


Ingreso(id_cita, fecha_alta)

InformesCita(id_informe, id_cita)






