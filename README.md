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

## Project Structure

```text
clinical data quality/
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