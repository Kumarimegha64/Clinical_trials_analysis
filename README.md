# Clinical Trials Data Quality & Analytics API

A Python-based clinical trials data quality and analytics project.

## Project Overview

This project processes clinical trial data, performs data quality checks, and provides a FastAPI service for accessing and searching clinical trial information.

## Features

- Clinical trial data cleaning and preprocessing
- Data quality validation using pytest
- FastAPI REST API
- Clinical trial search endpoint
- Data summary endpoint
- Health check endpoint
- Basic authentication endpoint
- Docker support
- Automated API and data-quality tests


# Clinical Data Quality

End-to-end clinical trial data-quality and analytics project covering **data profiling, SQL analysis, Python EDA, Power BI, FastAPI, testing, authentication, and Docker**.

## 📁 Project Structure

```text
clinical-data-quality/
├── app/
│   └── main.py
├── data/
│   └── processed/
│       └── clean_trials_data.csv
├── notebooks/
│   └── clinical_trial_notebook.ipynb
├── test/
│   └── test_data_quality.py
├── tests/
│   └── test_api.py
├── reports/
├── scripts/
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
├── README.md
└── .gitignore
```

## 🔍 Data Quality

The dataset was profiled for:

* Completeness and missing values
* Duplicate NCT IDs
* Validity of dates and enrollment
* Status and phase consistency
* Referential integrity
* Categorical standardization
* Potential outliers

### Key Findings

| Issue                        |        Finding | Impact                         |
| ---------------------------- | -------------: | ------------------------------ |
| Missing first-posted results |    669 (8.23%) | Reduced result completeness    |
| Missing interventions        | 1,225 (15.07%) | Limits intervention analysis   |
| Missing outcomes             |     37 (0.46%) | Limits outcome analysis        |
| Very high enrollment         |     24 records | Requires source validation     |
| Date/categorical issues      |     Identified | Affects trends and comparisons |

The project avoids automatically deleting unusual records and instead **flags potential quality issues for validation**.

## 📊 Analysis

Exploratory analysis covers:

* Trial status and phase
* Study type and design
* Enrollment
* Geographic distribution
* Trial activity over time
* Participant eligibility
* Gender eligibility
* Trial duration
* Missing data and outliers

The dataset contains approximately **8,089 clinical trials across 133 countries**.

## 🗄️ SQL Analysis

SQL was used for:

* Data validation and transformation
* JOINs and aggregations
* CTEs
* CASE expressions
* Window functions
* Duplicate detection
* Date calculations
* Enrollment and geographic analysis

SQL queries are maintained under `sql/` when applicable.

## 📈 Visualization

Power BI dashboards provide insights into:

* Total and recruiting trials
* Trial status and phase
* Geographic distribution
* Study type and design
* Enrollment
* Age and gender eligibility
* Trial activity over time

## 🚀 FastAPI

The project includes a FastAPI service for accessing the cleaned dataset.

### Endpoints

```text
GET  /
GET  /health
GET  /data/summary
GET  /trials/search
POST /auth/login
GET  /protected
```

Interactive Swagger documentation:

```text
http://localhost:8000/docs
```

Example search:

```text
/trials/search?limit=5
```

Authentication is included as a technical demonstration and is **not production-grade authentication**.

## 🧪 Testing

Run the test suite with:

```bash
pytest
```

The tests cover API functionality and core data-quality checks.

## 💻 Run Locally

### 1. Clone the repository

```bash
git clone <YOUR_GITHUB_REPOSITORY_URL>
cd clinical-data-quality
```

### 2. Create a virtual environment

```bash
python -m venv venv
```

Windows:

```bash
venv\Scripts\activate
```

### 3. Install dependencies

```bash
pip install -r requirements.txt
```

### 4. Start the API

```bash
uvicorn app.main:app --reload
```

API:

```text
http://localhost:8000
```

Swagger:

```text
http://localhost:8000/docs
```

## 🐳 Docker

Build and run:

```bash
docker compose up --build
```

Stop:

```bash
docker compose down
```

## 🔐 Authentication

Demo credentials:

```text
username: reviewer
password: clinical123
```

The returned bearer token can be used with:

```text
GET /protected
```

## 🔮 Future Improvements

* Automated data-quality monitoring
* GitHub Actions CI/CD
* Schema-drift detection
* Data-quality alerts
* Data-quality defect tracking
* Trial completion prediction
* Enrollment forecasting
* Anomaly detection
* Recruitment-risk prediction

## ⚠️ Limitations

The dataset contains intentionally realistic data-quality issues. Missing values, incomplete dates, extreme enrollment values, and later-year completeness can affect analysis.

This project is intended for **analytical and technical demonstration**, not regulatory submission.

## 🤖 AI Assistance

AI tools were used for development support, including troubleshooting, API implementation, testing, documentation, and error interpretation. Generated code was reviewed, tested, and adapted as part of the implementation.

## 📌 Conclusion

This project demonstrates an end-to-end approach to clinical-trial data analysis and quality assurance.

> **Data should be assessed for quality before analytical conclusions are trusted.**

Exploratory data analysis
Visualization
API development
Automated testing
Docker
Documentation
