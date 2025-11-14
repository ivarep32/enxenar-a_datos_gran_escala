import pandas as pd
import glob

# Folder containing CSV files
folder_path = "csvs"

# Get all CSV files in the folder
all_files = glob.glob(f"{folder_path}/*.csv")

# Loop and print filename and number of rows
for f in all_files:
    df = pd.read_csv(f, sep=";")  # adjust sep if needed
    print(f"{f}: {len(df)} rows")
