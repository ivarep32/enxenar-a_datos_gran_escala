import pandas as pd
import numpy as np
import random

# Leer personas
persona_df = pd.read_csv("csvs/Persona.csv", sep=";")

# Configurar probabilidades de roles
pct_patient_only = 0.8
pct_doctor_only = 0.15
pct_both = 0.05

# Asignar roles
roles = []
for _ in range(len(persona_df)):
    r = random.random()
    if r < pct_patient_only:
        roles.append("patient")
    elif r < pct_patient_only + pct_doctor_only:
        roles.append("doctor")
    else:
        roles.append("both")
persona_df["role"] = roles

# ---------------------------------------------
# Pacientes
blood_types = ["O+", "A+", "B+", "AB+", "O-", "A-", "B-", "AB-"]
probabilities = [0.37, 0.34, 0.10, 0.04, 0.06, 0.06, 0.02, 0.01]

paciente_df = persona_df[persona_df["role"].isin(["patient", "both"])].copy()
paciente_df["grupo_sanguineo"] = np.random.choice(
    blood_types, size=len(paciente_df), p=probabilities
)
paciente_df = paciente_df.rename(columns={"id_persona": "id_paciente"})
paciente_df = paciente_df[["id_paciente", "grupo_sanguineo"]].sort_values("id_paciente")
paciente_df.to_csv("csvs/Paciente.csv", index=False, sep=";")

# ---------------------------------------------
# Médicos
medico_df = persona_df[persona_df["role"].isin(["doctor", "both"])].copy()
medico_df = medico_df.rename(columns={"id_persona": "id_medico"})
medico_df = medico_df.reset_index(drop=True)

id_jefes = []

for i, (idx, medico) in enumerate(medico_df.iterrows()):
    if random.random() < 0.7 and i > 1:
        boss_id = random.choice(medico_df.iloc[:i]["id_medico"].tolist())
    else:
        boss_id = None
    id_jefes.append(boss_id)

medico_df["id_jefe"] = pd.Series(id_jefes, dtype="Int64")
medico_df = medico_df[["id_medico", "id_jefe"]].sort_values("id_medico")
medico_df.to_csv("csvs/Medico.csv", index=False, sep=";")

print("Pacientes y médicos generados correctamente:")
print(paciente_df.head())
print(medico_df.head())
