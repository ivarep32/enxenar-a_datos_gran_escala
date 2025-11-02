import pandas as pd
import random

# Number of medications to generate
num_meds =1000

# Example medication names and active substances
# (These are realistic but simplified)
medication_names = [
    ("Advil", "Ibuprofeno"),
    ("Aspirina", "Ácido Acetilsalicílico"),
    ("Paracetamol", "Paracetamol"),
    ("Nolotil", "Metamizol"),
    ("Augmentine", "Amoxicilina + Ácido Clavulánico"),
    ("Amoxicilina", "Amoxicilina"),
    ("Omeprazol", "Omeprazol"),
    ("Ibuprofeno", "Ibuprofeno"),
    ("Enantyum", "Dexketoprofeno"),
    ("Voltaren", "Diclofenaco"),
    ("Prednisona", "Prednisona"),
    ("Ramipril", "Ramipril"),
    ("Atorvastatina", "Atorvastatina"),
    ("Simvastatina", "Simvastatina"),
    ("Amlodipino", "Amlodipino"),
    ("Metformina", "Metformina"),
    ("Insulina Lantus", "Insulina Glargina"),
    ("Insulina Humalog", "Insulina Lispro"),
    ("Sertralina", "Sertralina"),
    ("Fluoxetina", "Fluoxetina"),
    ("Clonazepam", "Clonazepam"),
    ("Diazepam", "Diazepam"),
    ("Lorazepam", "Lorazepam"),
    ("Cetirizina", "Cetirizina"),
    ("Loratadina", "Loratadina"),
    ("Salbutamol", "Salbutamol"),
    ("Budesonida", "Budesonida"),
    ("Codeína", "Codeína"),
    ("Tramadol", "Tramadol"),
    ("Clopidogrel", "Clopidogrel")
]

# If we need more than available, we sample with replacement
meds_sample = random.choices(medication_names, k=num_meds)

# Build dataframe
data = []
for i, (name, active) in enumerate(meds_sample, start=1):
    data.append({
        "id_medicamento": i,
        "nome": name,
        "principio_activo": active
    })

df_meds = pd.DataFrame(data)

# Save to CSV
df_meds.to_csv("../csvs/Medicamento.csv", index=False, sep=";", encoding="utf-8-sig")

print(f"Generated {len(df_meds)} medications.")
print(df_meds.head())
