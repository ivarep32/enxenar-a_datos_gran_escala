import pandas as pd

# Load the CSV
df = pd.read_csv("csvs/Cita.csv", sep=";")

print("Antes:")
print(df.dtypes)

# Convert id_medico (and optionally other ID columns) to integer
df["id_medico"] = df["id_medico"].astype(int)

# If you want, convert other IDs too:
df["id_paciente"] = df["id_paciente"].astype(int)
df["id_cita"] = df["id_cita"].astype(int)
df["id_hospital"] = df["id_hospital"].astype(int)

print("Después:")
print(df.dtypes)

# Save cleaned CSV
df.to_csv("csvs/Cita.csv", sep=";", index=False, encoding="utf-8-sig")
