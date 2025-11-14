import pandas as pd
import numpy as np
import random
from datetime import datetime, timedelta

# === Load existing tables ===
df_pacientes = pd.read_csv("csvs/Paciente.csv", sep=";")
df_medicos = pd.read_csv("csvs/Medico.csv", sep=";")
df_medicamentos = pd.read_csv("csvs/Medicamento.csv", sep=";")

# === Parameters ===
mean_recetas_per_medico = 160
std_recetas = 40

razones = [
    "Dolor agudo",
    "Tratamiento crónico",
    "Revisión médica",
    "Post-operatorio",
    "Infección bacteriana",
    "Crisis de ansiedad",
    "Control de alergias",
    "Inflamación localizada",
    "Migraña recurrente",
    "Dolor muscular"
]


def random_date_within_years(years_back=3):
    end_date = datetime.now()
    start_date = end_date - timedelta(days=365 * years_back)
    rand_days = random.randint(0, (end_date - start_date).days)
    return (start_date + timedelta(days=rand_days)).date()


receitas_data = []

for _, medico in df_medicos.iterrows():
    # Number of prescriptions this doctor will write
    n_recetas = int(max(20, np.random.normal(mean_recetas_per_medico, std_recetas)))

    for _ in range(n_recetas):
        id_paciente = random.choice(df_pacientes["id_paciente"].tolist())
        id_medicamento = random.choice(df_medicamentos["id_medicamento"].tolist())

        receitas_data.append({
            "id_paciente": id_paciente,
            "id_medico": int(medico["id_medico"]),
            "id_medicamento": id_medicamento,
            "fecha": random_date_within_years(),
            "razon": random.choice(razones)
        })

# === Create DataFrame ===
df_receitas = pd.DataFrame(receitas_data)

# === Save to CSV ===
df_receitas.to_csv("csvs/Receta.csv", index=False, sep=";", encoding="utf-8-sig")

print(f"✅ Generated {len(df_receitas)} recetas.")
print(df_receitas.head())
