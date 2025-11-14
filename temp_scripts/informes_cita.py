import pandas as pd
import numpy as np
import random
from datetime import timedelta, time

# --- Load inputs ---
informe_df = pd.read_csv("csvs/Informe.csv", sep=";")
traballa_df = pd.read_csv("csvs/TraballaEn.csv", sep=";")
paciente_df = pd.read_csv("csvs/Paciente.csv", sep=";")  # Use Paciente.csv instead of Persona.csv

# Ensure id_medico and id_paciente are integers
traballa_df["id_medico"] = traballa_df["id_medico"].astype(int)
informe_df["id_medico"] = informe_df["id_medico"].astype(int)
informe_df["id_paciente"] = informe_df["id_paciente"].astype(int)
paciente_df["id_paciente"] = paciente_df["id_paciente"].astype(int)

# Convert date fields
informe_df["fecha"] = pd.to_datetime(informe_df["fecha"])

# Prepare outputs
citas = []
informe_cita = []

id_cita_counter = 1

# --- STEP 1: Create Citas linked to Informes ---
for _, row in informe_df.iterrows():
    if random.random() < 0.95:  # 90% chance this informe has a cita
        id_paciente = row["id_paciente"]
        id_informe = row["id_informe"]
        id_medico = row["id_medico"]

        # find where this doctor works
        works = traballa_df[traballa_df["id_medico"] == id_medico]
        if works.empty:
            continue  # skip if doctor has no work record

        selected_work = works.sample(1).iloc[0]
        id_hospital = selected_work["id_hospital"]
        nome_area = selected_work["nome_area"]

        # generate cita date = same day or up to 3 days before report
        fecha_cita = row["fecha"] - timedelta(days=random.choice([0, 1, 2, 3]))
        hora_inicio = time(random.randint(8, 16), random.choice([0, 15, 30, 45]))
        duracion = timedelta(minutes=random.choice([15, 30, 45, 60]))
        hora_fin = (pd.Timestamp.combine(pd.Timestamp.now(), hora_inicio) + duracion).time()

        razon = random.choice([
            "Revisión general", "Chequeo anual", "Consulta de seguimiento",
            "Dolor agudo", "Control de medicación", "Evaluación diagnóstica", "Terapia"
        ])
        presencial = random.choice([True, False])

        citas.append({
            "id_paciente": id_paciente,
            "id_cita": id_cita_counter,
            "id_medico": int(id_medico),
            "id_hospital": id_hospital,
            "nome_area": nome_area,
            "fecha": fecha_cita.date(),
            "hora_comezo": hora_inicio,
            "hora_finalización": hora_fin,
            "razon": razon,
            "presencial": presencial
        })

        informe_cita.append({
            "id_paciente": id_paciente,
            "id_informe": id_informe,
            "id_cita": id_cita_counter
        })

        id_cita_counter += 1

# --- STEP 2: Add extra random Citas without informes ---

num_extra_citas = int(len(citas) * 0.6)   # e.g., 60% more citas without informes

# random doctors who appear in TraballaEn
possible_docs = traballa_df["id_medico"].unique()
possible_pacientes = paciente_df["id_paciente"].tolist()

for _ in range(num_extra_citas):
    id_medico = random.choice(possible_docs)
    id_paciente = random.choice(possible_pacientes)
    work = traballa_df[traballa_df["id_medico"] == id_medico].sample(1).iloc[0]

    fecha_cita = pd.Timestamp("2024-01-01") + timedelta(days=random.randint(0, 365))
    hora_inicio = time(random.randint(8, 16), random.choice([0, 15, 30, 45]))
    duracion = timedelta(minutes=random.choice([15, 30, 45, 60]))
    hora_fin = (pd.Timestamp.combine(pd.Timestamp.now(), hora_inicio) + duracion).time()

    razon = random.choice([
        "Revisión general", "Chequeo anual", "Consulta de seguimiento",
        "Dolor agudo", "Control de medicación", "Evaluación diagnóstica", "Terapia"
    ])
    presencial = random.choice([True, False])

    citas.append({
        "id_paciente": id_paciente,
        "id_cita": id_cita_counter,
        "id_medico": int(id_medico),
        "id_hospital": work["id_hospital"],
        "nome_area": work["nome_area"],
        "fecha": fecha_cita.date(),
        "hora_comezo": hora_inicio,
        "hora_finalización": hora_fin,
        "razon": razon,
        "presencial": presencial
    })
    id_cita_counter += 1

# --- Save outputs ---

cita_df = pd.DataFrame(citas)
informe_cita_df = pd.DataFrame(informe_cita)

cita_df.to_csv("csvs/Cita.csv", sep=";", index=False)
informe_cita_df.to_csv("csvs/InformeCita.csv", sep=";", index=False)

print(f"✅ Generated {len(cita_df)} Citas ({len(informe_cita_df)} linked to Informes).")
print(cita_df.head())
print(informe_cita_df.head())
