import pandas as pd

# Load the CSV
df = pd.read_csv("csvs/Areas.csv", sep=";")

print(f"Antes: {len(df)} filas")

# Remove duplicate rows based on both columns
df_unique = df.drop_duplicates(subset=["id_hospital", "nome_area"]).reset_index(drop=True)

print(f"Después: {len(df_unique)} filas")

# Save the cleaned CSV
df_unique.to_csv("csvs/Areas.csv", sep=";", index=False, encoding="utf-8-sig")
