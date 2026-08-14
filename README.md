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


##1. Data Profiling 

The dataset was profiled before analysis to identify completeness, consistency, uniqueness, validity, and potential anomalies.

The profiling process included:

Row and column counts
Missing-value analysis
Null percentages
Cardinality analysis
Duplicate detection
Data-type consistency
Categorical-value distributions
Date validation
Enrollment validation
Required-column validation
Referential-integrity considerations
Geographic consistency
Status and phase consistency

The profiling was performed using Python/Pandas and SQL-based validation queries.

**2. Data Cleaning and Transformation**

The raw clinical-trial data was transformed into a cleaner analytical dataset.

Key transformations included:

Standardizing column names
Standardizing date fields
Converting date columns to appropriate date formats
Creating a cleaned clinical-trials dataset
Standardizing categorical values
Extracting country information from location data
Creating useful analytical categories
Handling missing values explicitly
Identifying duplicate or suspicious records
Identifying unusually high enrollment values
Validating required fields
Preparing the dataset for analysis and API consumption

The final processed dataset is:

data/processed/clean_trials_data.csv
**3. Data Quality Assessment**

The data-quality assessment focused on the following dimensions:

Quality Dimension	Assessment
Completeness	Missing values were identified and quantified
Validity	Invalid dates, categories and enrollment values were investigated
Consistency	Status, phase, country and categorical values were reviewed
Uniqueness	Duplicate records and NCT identifiers were checked
Referential Integrity	Relationships between study and related entities were considered
Accuracy	Implausible values were flagged for review
Timeliness	Date fields and trial activity over time were evaluated

The intentionally imperfect nature of the dataset was treated as part of the analysis rather than automatically removing every questionable record.

**4. Data Quality Test Plan**

Automated tests were implemented using Pytest.

The test suite validates important aspects of the project, including:

API root endpoint availability
API health endpoint availability
Clinical-trial dataset availability
Dataset is not empty
Required columns exist
Trial search endpoint availability
API response validity

Additional data-quality rules considered during the project include:

Duplicate NCT IDs
Missing required identifiers
Missing important fields
Invalid date ranges
Completion date before start date
Invalid enrollment values
Unexpected phase values
Unexpected status values
Missing foreign-key references
Geographic inconsistencies

The automated test suite can be executed with:

pytest

Expected result:

7 passed
5. SQL Analysis

SQL was used for data validation, transformation, aggregation, and analytical queries.

The SQL analysis includes concepts such as:

JOINs
GROUP BY
Aggregations
CASE expressions
CTEs
Window functions
Date calculations
Duplicate detection
Data-quality validation
Status and phase analysis
Enrollment analysis
Geographic analysis

The SQL queries are stored under:

sql/
6. Exploratory Data Analysis

Exploratory analysis was performed using Python and Pandas.

The analysis investigated:

Trial status
Trial phase
Study type
Study design
Enrollment
Geographic distribution
Trial activity over time
Participant eligibility
Gender eligibility
Trial duration
Missing data
Potential enrollment outliers

The analysis explicitly considers the impact of data-quality issues when interpreting results.

7. Trial Landscape Overview

The dataset contains approximately:

8,089 clinical trials
133 countries

The analysis shows that:

Completed and recruiting trials represent major portions of the dataset.
Clinical-trial activity is geographically concentrated.
The United States is one of the largest contributors of trials.
Interventional studies are more common than observational studies.
Adult participants represent the largest age category.
Many trials allow participation across genders.

These results should be interpreted together with the identified data-quality limitations.

8. Completion and Data Reliability

Trial completion was evaluated using available status and date information.

Factors considered include:

Trial phase
Study type
Enrollment
Trial duration
Start date
Completion date
Status
Missing-date patterns

Data-quality issues can affect the reliability of completion analysis.

For example:

Missing completion dates can prevent reliable duration calculations.
Inconsistent status values can affect completion-rate calculations.
Missing enrollment values can affect comparisons between trial groups.
Incomplete records from recent years can make time-based comparisons less reliable.

Therefore, completion-related conclusions are based only on records considered sufficiently reliable for the specific analysis.

9. Enrollment Analysis

Enrollment was analyzed across trial characteristics.

The analysis included:

Enrollment distributions
Enrollment by trial type
Enrollment by phase
Enrollment trends
Identification of extreme values

A set of unusually high enrollment records was identified for review.

These records were not automatically deleted because an unusually large clinical trial may be legitimate.

Instead, they were flagged as potential data-quality issues requiring validation against the source registry.

This approach avoids confusing legitimate high-volume trials with data-entry errors.

10. Geographic and Duration Analysis

Geographic analysis examined:

Countries represented in the dataset
Trial counts by country
Regional distribution
Geographic concentration

Trial duration was evaluated using:

completion_date - start_date

Invalid or incomplete date combinations were treated as data-quality issues.

Records with:

Missing start dates
Missing completion dates
Completion dates before start dates

were considered unsuitable for reliable duration calculations.

11. Data Quality Findings

Important quality findings included:

Issue	Finding	Potential Impact
Missing first-posted results	669 (8.23%)	Reduces completeness of result-related analysis
Missing interventions	1,225 (15.07%)	Limits intervention-level analysis
Missing outcomes	37 (0.46%)	Limits outcome analysis
Very high enrollment	24 records	Requires validation against source data
Missing/inconsistent categorical values	Identified during profiling	Can distort grouping and comparisons
Missing/invalid dates	Identified during validation	Can affect duration and trend analysis
12. Significant Data Quality Issue
Missing Intervention Information

One of the most significant issues identified was missing intervention information.

Approximately 1,225 records (15.07%) were identified as missing intervention information.

Root Cause

The dataset combines information originating from clinical-trial registry records. Not every record contains complete intervention information, and transformation from the source data can also result in incomplete fields.

Impact

Missing intervention information affects:

Intervention-level analysis
Drug/device/procedure comparisons
Therapeutic analysis
Trial classification
Stakeholder reporting

It can also introduce bias if missingness is concentrated in particular study types or time periods.

Recommended Resolution

Implement automated validation rules during ingestion:

IF study_type = interventional
AND intervention information is missing
THEN flag record for review.

The pipeline should also track missingness over time and report the percentage of affected records.

13. Visualization

The project includes Power BI-based visualization of the clinical-trial dataset.

The dashboard focuses on:

Total clinical trials
Number of countries
Recruiting trials
Completed trials
Trial status
Trial phase
Geographic distribution
Top countries
Age distribution
Gender distribution
Trial activity over time
Study type
Study design
Enrollment

Interactive filters can be used to explore the dataset by relevant trial characteristics.

14. Key Findings

The analysis identified several important patterns.

Trial Activity

Clinical-trial activity increased substantially around 2020–2021, followed by lower activity in later years.

Later-year values should be interpreted cautiously because data completeness may vary by publication/update date.

Geography

Trial activity is geographically concentrated, with the United States representing a major share of the dataset.

Study Type

Interventional studies are more common than observational studies.

Participants

Adult participants represent the largest eligibility group.

Gender

A large proportion of studies allow participation across genders.

Data Quality

Missing intervention data, missing result-related information, and extreme enrollment values represent important areas for quality improvement.

15. Recommendations

Based on the analysis, the following remediation priorities are recommended.

Priority 1 — Improve Completeness

Improve the completeness of intervention, outcome and result-related information.

Priority 2 — Validate Enrollment

Implement automated rules to flag unusually high or low enrollment values.

Priority 3 — Standardize Categorical Fields

Standardize:

Trial status
Trial phase
Study type
Country
Gender
Enrollment type
Priority 4 — Validate Dates

Implement validation rules such as:

completion_date >= start_date

and flag records with missing or inconsistent dates.

Priority 5 — Automate Data Quality Monitoring

Run automated quality checks whenever new clinical-trial data is loaded.

Priority 6 — Maintain a Data Quality Defect Log

Track:

Issue
Rule violated
Number of affected records
Severity
Root cause
Resolution
Date detected
Date resolved
16. FastAPI Data Service

A lightweight FastAPI service was developed to expose the cleaned clinical-trial data.

The API provides:

Root Endpoint
GET /

Returns:

{
  "message": "Clinical Data Quality API is running"
}
Health Endpoint
GET /health

Returns:

{
  "status": "ok"
}
Dataset Summary
GET /data/summary

Returns information about:

Number of rows
Number of columns
Column names
Trial Search
GET /trials/search

Supports filters such as:

status
phase
country
limit

Example:

/trials/search?limit=5
Authentication

A login endpoint is provided:

POST /auth/login

The API also contains a protected endpoint:

GET /protected

which requires a bearer token.

17. API Documentation

When the application is running locally, FastAPI automatically provides interactive API documentation at:

http://localhost:8000/docs

The Swagger UI can be used to test the API endpoints.

18. Running the Project Locally
Step 1 — Clone the repository
git clone <YOUR_GITHUB_REPOSITORY_URL>
cd clinical-data-quality
Step 2 — Create a Python environment
python -m venv venv

Activate on Windows:

venv\Scripts\activate
Step 3 — Install dependencies
pip install -r requirements.txt
Step 4 — Run the API
uvicorn app.main:app --reload

The API will be available at:

http://localhost:8000

Swagger documentation:

http://localhost:8000/docs
19. Running Tests

Run the complete test suite:

pytest

Expected result:

7 passed

The tests cover API functionality and core dataset-quality checks.

20. Docker

The project includes Docker support for reproducible execution.

Build and start the application using:

docker compose up --build

After the container starts, access:

http://localhost:8000

API documentation:

http://localhost:8000/docs

To stop the containers:

docker compose down
21. Authentication Example

The API provides a demonstration authentication flow.

Login endpoint:

POST /auth/login

Example credentials:

username: reviewer
password: clinical123

The endpoint returns a bearer token.

The returned token can then be used to access:

GET /protected

In Swagger:

Open /docs
Execute /auth/login
Copy the returned access token
Use the Authorize button
Enter the bearer token
Call /protected

This authentication mechanism is intended as a demonstration for the technical challenge and is not production-grade authentication.

22. Bonus Questions
22.1 Data Quality at Scale

If the pipeline ran daily, I would implement automated data-quality checks at ingestion time.

Examples:

Duplicate NCT ID detection
Required-field validation
Date validation
Enrollment range validation
Status/phase domain validation
Referential-integrity validation
Missing-value monitoring
Schema-drift detection
Geographic value validation

Each execution would generate a data-quality report containing:

Rule
Records tested
Records failed
Failure percentage
Severity
Status

Thresholds could trigger alerts when data quality falls below acceptable levels.

22.2 Test Automation

The test suite could be integrated into CI/CD using GitHub Actions.

A typical workflow would be:

New data
   ↓
Data ingestion
   ↓
Data-quality tests
   ↓
All critical tests pass?
   ↓
Yes → Continue pipeline
No  → Stop pipeline + alert

Critical rules should have zero tolerance, while warning-level rules could use configurable thresholds.

22.3 Compliance Considerations

In a GxP-regulated environment, additional controls would be required.

These would include:

Documented validation procedures
Requirements traceability
Controlled change management
Audit trails
Data lineage
Version-controlled analytical code
Validation evidence
Access controls
Electronic records controls
Documented deviations
Approved SOPs
Reproducibility of analytical results

The analytical process should be validated and documented according to the applicable regulatory framework.

22.4 Stakeholder Communication
Executive Audience

The dashboard should focus on:

Overall trial volume
Major quality risks
Key trends
Geographic distribution
Business impact
Recommended actions
Clinical Operations Audience

The dashboard should provide more operational detail, including:

Trial status
Trial phase
Enrollment
Location
Completion
Data-quality exceptions
Missing information
22.5 Self-Service Analytics

The solution could be extended into a self-service analytics platform by providing:

Standardized datasets
Clearly documented business definitions
Power BI semantic models
Reusable measures
Data-quality indicators
Interactive filters
Drill-down functionality
Data dictionaries

This would allow stakeholders to explore the data without requiring direct analyst involvement for every question.

22.6 Advanced Analytics

Potential future models include:

Trial completion prediction
Enrollment forecasting
Trial duration prediction
Site performance analysis
Recruitment risk prediction
Anomaly detection
Trial segmentation
Survival analysis
Geographic recruitment analysis

These models should only be developed after the underlying data-quality issues are sufficiently controlled.

23. Limitations

Several limitations should be considered when interpreting the analysis.

The dataset contains intentionally realistic data-quality issues.
Missing values can introduce bias.
Some trial records may have incomplete dates.
Extreme enrollment values require source-level validation.
Later-year trial counts may be affected by data completeness.
The analysis does not assume that every missing value represents an error.
The cleaned dataset is intended for analytical demonstration rather than regulatory submission.

Therefore, findings should be interpreted together with the documented data-quality limitations.

24. AI Assistance

AI tools were used during development to assist with:

Code troubleshooting
API implementation
Test debugging
Documentation
Error interpretation
Development guidance

All generated code was reviewed, tested, and adapted as part of the implementation.

The final implementation decisions and understanding of the solution remain the responsibility of the author.

25. Reproducibility

The project is designed so that a reviewer can:

Clone the repository
Install dependencies
Run the automated tests
Start the FastAPI service
Open the Swagger documentation
Query the clinical-trial dataset
Run the project using Docker

This provides a reproducible environment for reviewing the implementation.

26. Conclusion

This project demonstrates an end-to-end approach to clinical-trial data analysis and quality assurance.

The key principle followed throughout the project was:

Data should be assessed for quality before analytical conclusions are trusted.

The project combines:

Data profiling
Data-quality testing
SQL analysis
Python analysis
Exploratory data analysis
Visualization
API development
Automated testing
Docker
Documentation
