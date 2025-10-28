import pandas as pd
import numpy as np
import random
import os
from datetime import datetime, timedelta
from pathlib import Path

# === Automatically resolve paths ===
BASE_DIR = Path(__file__).resolve().parent.parent  # parent folder of temp_scripts
CSV_DIR = BASE_DIR / "csvs"
SUMMARY_DIR = BASE_DIR / "summaries"

# === Load existing data ===
df_pacientes = pd.read_csv(CSV_DIR / "Paciente.csv", sep=";")
df_medicos = pd.read_csv(CSV_DIR / "Medico.csv", sep=";")

# === Load text summaries ===
summary_files = [f for f in os.listdir(SUMMARY_DIR) if f.endswith(".txt")]

if len(summary_files) == 0:
    raise ValueError(f"No .txt files found in '{SUMMARY_DIR}'")

# Read all summary texts
summary_texts = []
for filename in summary_files:
    with open(SUMMARY_DIR / filename, "r", encoding="utf-8") as f:
        text = f.read().strip()
        if text:
            summary_texts.append(text)

if len(summary_texts) == 0:
    raise ValueError("No usable (non-empty) text files found in 'summaries'.")

# === Parameters ===
mean_informes_per_medico = 40
std_dev_informes = 10
categorias = [
    "Radiología", "Consulta General", "Cardiología", "Urgencias",
    "Neurología", "Oncología", "Pediatría", "Cirugía", "Psiquiatría"
]

def random_date_within_years(years_back=3):
    """Random date within the last N years."""
    end_date = datetime.now()
    start_date = end_date - timedelta(days=365 * years_back)
    random_days = random.randint(0, (end_date - start_date).days)
    return (start_date + timedelta(days=random_days)).date()

# === Generate informes ===
informes_data = []
id_counter = 1

# Probabilistic assignment of number of informes per patient
patient_informes = np.clip(np.random.normal(10, 8, len(df_pacientes)).astype(int), 0, 50)
patient_ids = df_pacientes["id_paciente"].tolist()
patient_informes_used = {pid: 0 for pid in patient_ids}

summary_index = 0  # to rotate through summaries

for _, medico in df_medicos.iterrows():
    n_informes = int(max(5, np.random.normal(mean_informes_per_medico, std_dev_informes)))
    medico_id = medico["id_medico"]

    for _ in range(n_informes):
        available_patients = [pid for pid, used in patient_informes_used.items()
                              if used < patient_informes[patient_ids.index(pid)]]
        if not available_patients:
            break

        pid = random.choice(available_patients)
        patient_informes_used[pid] += 1

        # Select next summary text (cycle through available texts)
        texto = summary_texts[summary_index % len(summary_texts)]
        summary_index += 1

        informes_data.append({
            "id_paciente": pid,
            "id_informe": id_counter,
            "feito_por": medico_id,
            "fecha": random_date_within_years(),
            "categoría": random.choice(categorias),
            "texto": texto
        })
        id_counter += 1

# === Save the result ===
df_informes = pd.DataFrame(informes_data)
output_path = CSV_DIR / "Informe.csv"
df_informes.to_csv(output_path, index=False, sep=";", encoding="utf-8-sig")

print(f"✅ Generated {len(df_informes)} informes.")
print(f"📁 Saved to: {output_path}")
print(df_informes.head(10))
