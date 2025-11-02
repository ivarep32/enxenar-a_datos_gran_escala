import pandas as pd
import random
import os

# Ensure output folder exists
os.makedirs("../csvs", exist_ok=True)

# Load tables
df_medicos = pd.read_csv("../csvs/Medico.csv", sep=";")
df_areas = pd.read_csv("../csvs/Areas.csv", sep=";")  # Must contain (id_hospital, nome_area)

traballa_en_data = []

for _, medico in df_medicos.iterrows():
    id_medico = medico["id_medico"]

    # Choose how many areas this doctor works in (biased to 1-2)
    n_areas = random.choices([1, 2, 3], weights=[0.6, 0.3, 0.1])[0]

    # Sample n areas from ALL available hospital-area combos without repetition
    assigned = df_areas.sample(n=n_areas, replace=False)

    for _, area in assigned.iterrows():
        traballa_en_data.append({
            "id_medico": id_medico,
            "id_hospital": area["id_hospital"],
            "nome_area": area["nome_area"]
        })

# Create DataFrame
df_traballa = pd.DataFrame(traballa_en_data)

# Save CSV
df_traballa.to_csv("../csvs/TraballaEn.csv", index=False, sep=";", encoding="utf-8-sig")

print(f"✅ Generated {len(df_traballa)} rows in TraballaEn.")
print(df_traballa.head())
