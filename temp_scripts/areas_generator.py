import pandas as pd
import random

# Leer CSV de hospitales
df_hospitals = pd.read_csv("csvs/Hospital.csv", sep=";")

# Lista de posibles áreas
possible_areas = [
    "Pediatría", "Urgencias", "Ginecología", "Cirugía General",
    "Medicina Interna", "Cardiología", "Neurología", "Oncología",
    "Traumatología", "Psiquiatría", "Dermatología", "Radiología",
    "Rehabilitación", "Cuidados Intensivos", "Odontología",
    "Psicología", "Endocrinología"
]
weights = [8, 7, 4, 3, 5, 4, 1, 3, 4, 3, 3, 4, 5, 3, 3, 2, 2]
areas_data = []

for _, hospital in df_hospitals.iterrows():
    # Elegir número de áreas con probabilidad sesgada hacia pocos
    # Probabilidades: 1 área (40%), 2-3 áreas (35%), 4-5 áreas (15%), 6-10 áreas (10%)
    rand = random.random()
    if rand < 0.4:
        n_areas = 1
    elif rand < 0.75:
        n_areas = random.randint(2, 3)
    elif rand < 0.9:
        n_areas = random.randint(4,4)
    else:
        n_areas = random.randint(5, 8)
    
    n_areas = min(n_areas, len(possible_areas))
        
    areas_for_hospital = []
    # Elegir n_areas sin repetir
    if n_areas == 1 or random.random() < 0.8 / n_areas:
        areas_for_hospital.append("General")
    if n_areas > 1:
        areas_for_hospital.extend(random.choices(possible_areas, weights=weights, k=n_areas - len(areas_for_hospital)))
    
    # Añadir al dataset
    for area_name in areas_for_hospital:
        areas_data.append({
            "id_hospital": hospital["id_hospital"],
            "nome_area": area_name
        })

df_areas = pd.DataFrame(areas_data)

# Guardar CSV
df_areas.to_csv("csvs/Areas.csv", index=False, sep=";", encoding="utf-8-sig")

print(df_areas.head())
