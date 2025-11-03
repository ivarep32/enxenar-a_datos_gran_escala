"""
NON SE USA XA

NON UTILIZAR

NON :D

DON'T DO IT

USA informes_cita.py
"""

import pandas as pd
import numpy as np
import random
from datetime import datetime, timedelta
import os

# Ensure output folder exists
os.makedirs("../csvs", exist_ok=True)

# Load needed data
df_pacientes = pd.read_csv("../csvs/Paciente.csv", sep=";")
df_medicos = pd.read_csv("../csvs/Medico.csv", sep=";")
df_traballa = pd.read_csv("../csvs/TraballaEn.csv", sep=";")

# Load appointments data (real scheduling data)
df_apps = pd.read_csv("appointments.csv")  # separator depends on your file, change if needed

citas_data = []
id_counter = 1

for _, app in df_apps.iterrows():

    paciente_id = random.choice(df_pacientes["id_paciente"].tolist())
    medico_id = random.choice(df_medicos["id_medico"].tolist())

    # Assign hospital + area where this doctor works
    possible_places = df_traballa[df_traballa["id_medico"] == medico_id]
    if possible_places.empty:  # fallback if needed
        possible_places = df_traballa.sample(1)
    chosen = possible_places.sample(1).iloc[0]

    id_hospital = chosen["id_hospital"]
    nome_area = chosen["nome_area"]

    # Parse time with correct format: HH/MM/SS
    start_time = datetime.strptime(app["appointment_time"], "%H:%M:%S")
    # Generate end time (15–60 min later)
    end_time = start_time + timedelta(minutes=random.randint(15, 60))

    # Presencial distribution
    presencial = "T" if random.random() < 0.7 else "F"

    citas_data.append({
        "id_paciente": paciente_id,
        "id_cita": id_counter,
        "id_medico": medico_id,
        "id_hospital": id_hospital,
        "nome_area": nome_area,
        "fecha": app["appointment_date"],             # Already DD/MM/YYYY → Keep as is
        "hora_comezo": start_time.strftime("%H:%M"),  # Standard display format
        "hora_finalización": end_time.strftime("%H:%M"),
        "razon": app["reason_for_visit"],
        "presencial": presencial
    })

    id_counter += 1

df_citas = pd.DataFrame(citas_data)
df_citas.to_csv("../csvs/Cita.csv", index=False, sep=";", encoding="utf-8-sig")

print(f"✅ Successfully generated {len(df_citas)} citas.")
print(df_citas.head())

"""
NON SE USA XA

NON UTILIZAR

NON :D

DON'T DO IT

USA informes_cita.py
"""
