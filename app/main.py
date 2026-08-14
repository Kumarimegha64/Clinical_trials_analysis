from fastapi import FastAPI, Depends, HTTPException
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import pandas as pd
from pathlib import Path


DATA_PATH = Path("data/processed/clean_trials_data.csv")


app = FastAPI(
    title="Clinical Trials Data Quality API",
    description="API for the Clinical Trials Data Quality & Analytics Challenge",
    version="1.0.0"
)


security = HTTPBearer()


@app.get("/")
def root():
    return {
        "message": "Clinical Data Quality API is running"
    }


@app.get("/health")
def health():
    return {
        "status": "ok"
    }


@app.get("/data/summary")
def data_summary():
    if not DATA_PATH.exists():
        raise HTTPException(
            status_code=404,
            detail="Clinical trials dataset not found"
        )

    df = pd.read_csv(DATA_PATH)

    return {
        "rows": len(df),
        "columns": len(df.columns),
        "column_names": df.columns.tolist()
    }


@app.get("/trials/search")
def search_trials(
    status: str | None = None,
    phase: str | None = None,
    country: str | None = None,
    limit: int = 20
):
    if not DATA_PATH.exists():
        raise HTTPException(
            status_code=404,
            detail="Clinical trials dataset not found"
        )

    df = pd.read_csv(DATA_PATH)

    if status:
        df = df[
            df["status"].astype(str).str.contains(
                status,
                case=False,
                na=False
            )
        ]

    if phase:
        df = df[
            df["phase"].astype(str).str.contains(
                phase,
                case=False,
                na=False
            )
        ]

    if country:
        df = df[
            df["country"].astype(str).str.contains(
                country,
                case=False,
                na=False
            )
        ]

    df = df.head(limit)

    results = (
        df.astype(object)
        .where(pd.notna(df), None)
        .to_dict(orient="records")
    )

    return {
        "count": len(results),
        "results": results
    }


@app.post("/auth/login")
def login(username: str, password: str):
    if username == "reviewer" and password == "clinical123":
        return {
            "access_token": "clinical-trials-review-token",
            "token_type": "bearer"
        }

    raise HTTPException(
        status_code=401,
        detail="Invalid username or password"
    )


@app.get("/protected")
def protected(
    credentials: HTTPAuthorizationCredentials = Depends(security)
):
    if credentials.credentials != "clinical-trials-review-token":
        raise HTTPException(
            status_code=401,
            detail="Invalid token"
        )

    return {
        "message": "Authentication successful",
        "route": "protected"
    }