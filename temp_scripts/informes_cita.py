import pandas as pd

# Load data
cita_df = pd.read_csv("csvs/Cita.csv", sep=";")
informe_df = pd.read_csv("csvs/Informe.csv", sep=";")

# Convert dates to datetime
cita_df["fecha"] = pd.to_datetime(cita_df["fecha"])
informe_df["fecha"] = pd.to_datetime(informe_df["fecha"])

# Merge based on patient + doctor
merged = pd.merge(
    informe_df,
    cita_df,
    on=["id_paciente", "id_medico"],
    suffixes=("_informe", "_cita")
)


# Keep only the relevant relationship columns
rel_df = merged[["id_paciente", "id_cita", "id_informe"]].drop_duplicates()

# Save the relationship
rel_df.to_csv("csvs/Informe_Cita.csv", sep=";", index=False)

print("Informe_Cita generated correctly:")
print("Number of rows:", len(rel_df))
print(rel_df.head())

