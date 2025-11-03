import pandas as pd
from datetime import datetime, timedelta
import random
import os

# Ensure output folder exists
os.makedirs("csvs", exist_ok=True)

# Load Cita table
df_citas = pd.read_csv("csvs/Cita.csv", sep=";")

ingreso_data = []

for _, cita in df_citas.iterrows():
    if random.random() > 0.15:
        continue
    # Parse the appointment date in ISO format YYYY-MM-DD
    fecha_cita = datetime.strptime(cita["fecha"], "%Y-%m-%d")

    # Generate fecha_alta at least 1 day later, up to 10 days later
    fecha_alta = fecha_cita + timedelta(days=random.randint(0, 10))

    ingreso_data.append({
        "id_cita": cita["id_cita"],
        "fecha_alta": fecha_alta.strftime("%Y-%m-%d")  # match Cita.csv format
    })

# Convert to DataFrame
df_ingreso = pd.DataFrame(ingreso_data)

# Save CSV
df_ingreso.to_csv("csvs/Ingreso.csv", index=False, sep=";", encoding="utf-8-sig")

print(f"✅ Generated {len(df_ingreso)} ingresos.")
print(df_ingreso.head())
