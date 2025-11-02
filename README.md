# enxenar-a_datos_gran_escala
TO DO:
EMPIEZO CON TRABALLA

TraballaEn(id_medico, id_hospital, nome_area)
Clave foránea: id_medico -> Médico(id_medico)
Clave foránea: id_hospital, nome_area -> Area(id_hospital, nome_area)

Cita(id_paciente, id_cita, id_medico, id_hopsital, nome_area, fecha, hora_comezo, hora_finalización, razon, presencial)
Clave foránea: id_paciente -> Paciente(id_paciente)
Clave foránea: id_medico -> Médico(id_medico)
Clave foránea: id_hospital, nome_area -> Area(id_hospital, nome_area)


Ingreso(id_cita, fecha_alta)

InformesCita(id_informe, id_cita)











