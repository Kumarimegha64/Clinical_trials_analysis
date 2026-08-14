import pandas as pd
from pathlib import Path


DATA_PATH = Path("data/processed/clean_trials_data.csv")


def load_data():
    return pd.read_csv(DATA_PATH)


def test_dataset_exists():
    assert DATA_PATH.exists(), "Clinical trials dataset was not found"


def test_dataset_not_empty():
    df = load_data()
    assert len(df) > 0, "Dataset is empty"


def test_required_columns_exist():
    df = load_data()

    required_columns = [
        "nct_id",
        "status",
        "phase",
        "study_type",
        "start_date",
        "completion_date",
        "enrollment",
    ]

    missing_columns = [
        column for column in required_columns
        if column not in df.columns
    ]

    assert not missing_columns, f"Missing columns: {missing_columns}"