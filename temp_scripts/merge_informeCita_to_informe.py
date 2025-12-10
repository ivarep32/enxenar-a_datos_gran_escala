import pandas as pd

# --- Load inputs ---
informe_df = pd.read_csv("csvs/Informe.csv", sep=";")
informe_cita_df = pd.read_csv("csvs/InformeCita.csv", sep=";")

# Ensure merging keys are integers
informe_df["id_informe"] = informe_df["id_informe"].astype(int)
informe_cita_df["id_informe"] = informe_cita_df["id_informe"].astype(int)
informe_cita_df["id_cita"] = informe_cita_df["id_cita"].astype(int)

# --- Merge ---
informe_final = informe_df.merge(
    informe_cita_df[["id_informe", "id_cita"]],
    on="id_informe",
    how="left"
)

# --- Convert id_cita to nullable integer ---
informe_final["id_cita"] = informe_final["id_cita"].astype("Int64")

# --- Save output ---
informe_final.to_csv("csvs/InformeFinal.csv", sep=";", index=False)

print("✅ InformeFinal.csv created with correct integer id_cita.")
print(informe_final.dtypes)
print(informe_final.head())
