import pandas as pd

# Load the CSV
df = pd.read_csv("csvs/Receita.csv", sep=";")

print("Antes:")
print(df.dtypes)

# Convert id_medico (and optionally other ID columns) to integer
df["id_medico"] = df["id_medico"].astype(int)

print("Después:")
print(df.dtypes)

# Save cleaned CSV
df.to_csv("csvs/Receita.csv", sep=";", index=False, encoding="utf-8-sig")
