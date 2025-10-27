import pandas as pd
import glob
import random
from faker import Faker

fake = Faker('es_ES')  # Español

# Carpeta donde están los archivos
folder_path = "temp_scripts/addresses"

# Leer todos los archivos que empiecen con 'spain'
all_files = glob.glob(f"{folder_path}/spain*.csv")

# Concatenar todos los CSVs
addresses = pd.concat([pd.read_csv(f) for f in all_files], ignore_index=True)

print(f"Total de direcciones disponibles: {len(addresses)}")

# Número de hospitales a generar
N = 219

# Asegurarnos de no generar más hospitales que direcciones
assert N <= len(addresses), "No hay suficientes direcciones para generar esa cantidad de hospitales."


# Separar las direcciones que se usarán y las que no
used_addresses = addresses.iloc[:N].reset_index(drop=True)
unused_addresses = addresses.iloc[N:].reset_index(drop=True)

# Guardar direcciones no usadas
unused_addresses.to_csv("temp_scripts/unused_addresses.csv", index=False, encoding="utf-8-sig")

# Generar nombres de hospitales más originales
hospital_types = ["Clínica", "Hospital", "Hospital Universitario", "Centro Médico", "Sanatorio"]
special_names = ["Santa María","Taylor Swift","Castelao","Rosalía de Castro","San Juan","Buenavista","Los Pinos","Virgen del Rocío","La Esperanza","Monteverde","Vistalegre","San Pedro","El Robledal","Santa Clara","San Miguel","Nuestra Señora del Carmen","San Rafael","San José","San Fernando","El Valle","Monte del Sol","La Paloma","Santa Teresa","San Martín","Las Violetas","El Pinar","San Andrés","La Candelaria","Monte Alegre","Los Almendros","San Lorenzo","El Mirador","La Rosaleda","Santa Lucía","San Vicente"]

hospitals_data = []

for i, addr in used_addresses.iterrows():
    name = f"{random.choice(hospital_types)} {random.choice(special_names)}"
    hospitals_data.append({
        "id_hospital": i + 1,
        "nombre": name,
        "pais": "España",
        "localidad": addr["Locality"],
        "codigo_postal": addr["PostalCode"],
        "calle": addr["Street"],
        "numero": addr["HouseNumber"],
        

        "latitud": addr["Latitude"],
        "longitud": addr["Longitude"],
        
        "tipo": random.choice(["Público", "Privado"])
    })

df_hospitals = pd.DataFrame(hospitals_data)

# Guardar CSV final de hospitales
df_hospitals.to_csv("csvs/Hospital.csv", index=False, encoding="utf-8-sig", sep=";")
print(df_hospitals.head())
print(f"Direcciones no usadas guardadas en 'unused_addresses.csv'")