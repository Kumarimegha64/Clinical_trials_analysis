import pandas as pd
from sqlalchemy import create_engine

# -----------------------------
# PostgreSQL Connection
# -----------------------------
username = "postgres"
password = "123456"
host = "localhost"
port = "5432"
database = "clinical_trials"

engine = create_engine(
    f"postgresql://{username}:{password}@{host}:{port}/{database}"
)

# -----------------------------
# Read CSV
# -----------------------------
csv_file = r"C:\Users\Acer\Desktop\Megha Project\clinical data quality\data\raw\covid_clinical_trials.csv"

df = pd.read_csv(csv_file)

df.columns = [
    "rank",
    "nct_number",
    "title",
    "acronym",
    "status",
    "study_results",
    "conditions",
    "interventions",
    "outcome_measures",
    "sponsor_collaborators",
    "gender",
    "age",
    "phases",
    "enrollment",
    "funded_bys",
    "study_type",
    "study_designs",
    "other_ids",
    "start_date",
    "primary_completion_date",
    "completion_date",
    "first_posted",
    "results_first_posted",
    "last_update_posted",
    "locations",
    "study_documents",
    "url"
]

print("CSV Loaded Successfully!")
print(df.head())
print(df.columns.to_list())
print(df.shape)

# -----------------------------
# Load into PostgreSQL
# -----------------------------
df.to_sql(
    "raw_trials",
    engine,
    if_exists="append",
    index=False
)

print("Data Imported Successfully!")