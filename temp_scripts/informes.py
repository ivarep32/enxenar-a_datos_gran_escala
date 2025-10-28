import pandas as pd
import numpy as np
import random
from datetime import datetime, timedelta

# === Load existing data ===
df_pacientes = pd.read_csv("csvs/Paciente.csv", sep=";")
df_medicos = pd.read_csv("csvs/Medico.csv", sep=";")

# === Parameters ===
mean_informes_per_medico = 40
std_dev_informes = 10  # some variation
categorias = [
    "Radiología", "Consulta General", "Cardiología", "Urgencias",
    "Neurología", "Oncología", "Pediatría", "Cirugía", "Psiquiatría"
]


# === Helper functions ===
def random_date_within_years(years_back=3):
    """Random date within the last `years_back` years."""
    end_date = datetime.now()
    start_date = end_date - timedelta(days=365 * years_back)
    random_days = random.randint(0, (end_date - start_date).days)
    return (start_date + timedelta(days=random_days)).date()


def generate_random_text():
    """Fake placeholder text for informes."""
    samples = [
        "El paciente presenta evolución favorable.",
        "Se recomienda control en 3 semanas.",
        "No se observan anomalías en la exploración.",
        "Se prescribe tratamiento con antibióticos.",
        "Se solicita estudio complementario.",
        "Paciente asintomático, seguimiento rutinario.",
        "Resultados dentro de los valores normales."
    ]
    return random.choice(samples)


# === Generate informes ===
informes_data = []
id_counter = 1

# Precompute how many informes each patient can have
# (0–50, with 0–15 more likely)
patient_informes = np.clip(np.random.normal(10, 8, len(df_pacientes)).astype(int), 0, 50)
patient_ids = df_pacientes["id_paciente"].tolist()

# Track how many informes each patient has used
patient_informes_used = {pid: 0 for pid in patient_ids}

for _, medico in df_medicos.iterrows():
    n_informes = int(max(5, np.random.normal(mean_informes_per_medico, std_dev_informes)))
    medico_id = medico["id_medico"]

    for _ in range(n_informes):
        # Choose a patient weighted by remaining available informes
        available_patients = [pid for pid, used in patient_informes_used.items() if
                              used < patient_informes[patient_ids.index(pid)]]
        if not available_patients:
            break
        pid = random.choice(available_patients)
        patient_informes_used[pid] += 1

        informes_data.append({
            "id_paciente": pid,
            "id_informe": id_counter,
            "feito_por": medico_id,
            "fecha": random_date_within_years(),
            "categoría": random.choice(categorias),
            "texto": generate_random_text()
        })
        id_counter += 1

# === Build DataFrame ===
df_informes = pd.DataFrame(informes_data)

# === Save to CSV ===
df_informes.to_csv("csvs/Informe.csv", index=False, sep=";", encoding="utf-8-sig")

print(f"Generated {len(df_informes)} informes.")
print(df_informes.head(10))
