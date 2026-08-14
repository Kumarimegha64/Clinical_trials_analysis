DROP TABLE IF EXISTS raw_trials;

CREATE TABLE raw_trials (
    rank INTEGER,
    nct_number VARCHAR(30),
    title TEXT,
    acronym VARCHAR(100),
    status VARCHAR(100),
    study_results VARCHAR(100),
    conditions TEXT,
    interventions TEXT,
    outcome_measures TEXT,
    sponsor_collaborators TEXT,
    gender VARCHAR(50),
    age TEXT,
    phases VARCHAR(100),
    enrollment INTEGER,
    funded_bys VARCHAR(100),
    study_type VARCHAR(100),
    study_designs TEXT,
    other_ids TEXT,
    start_date TEXT,
    primary_completion_date TEXT,
    completion_date TEXT,
    first_posted TEXT,
    results_first_posted TEXT,
    last_update_posted TEXT,
    locations TEXT,
    study_documents TEXT,
    url TEXT
);

---select table from raw_trials
select count(*) from raw_trials;

---Count missing values
SELECT
COUNT(*) AS total_records,
COUNT(*) - COUNT(nct_number) AS missing_nct,
COUNT(*) - COUNT(title) AS missing_title,
COUNT(*) - COUNT(status) AS missing_status,
COUNT(*) - COUNT(phases) AS missing_phase,
COUNT(*) - COUNT(enrollment) AS missing_enrollment,
COUNT(*) - COUNT(start_date) AS missing_start_date,
COUNT(*) - COUNT(completion_date) AS missing_completion_date
FROM raw_trials;

---Find duplicate
SELECT
    nct_number,
    COUNT(*) AS occurrence_count
FROM raw_trials
WHERE nct_number IS NOT NULL
GROUP BY nct_number
HAVING COUNT(*) > 1
ORDER BY occurrence_count DESC;

---check missing nct number
SELECT
    COUNT(*) AS missing_nct_numbers
FROM raw_trials
WHERE nct_number IS NULL
   OR TRIM(nct_number) = '';

---check status 
SELECT
    status,
    COUNT(*) AS record_count
FROM raw_trials
GROUP BY status
ORDER BY record_count DESC;

---check study type 
SELECT
    "Study Type" AS study_type,
    COUNT(*) AS record_count
FROM raw_trials
GROUP BY "Study Type"
ORDER BY record_count DESC;

---check gender
SELECT
    gender,
    COUNT(*) AS record_count
FROM raw_trials
GROUP BY gender
ORDER BY record_count DESC;

---check phase
SELECT
    phases,
    COUNT(*) AS record_count
FROM raw_trials
GROUP BY phases
ORDER BY record_count DESC;

---check funded_bys
SELECT
    funded_bys,
    COUNT(*) AS record_count
FROM raw_trials
GROUP BY funded_bys
ORDER BY record_count DESC;

---check enrollment 
SELECT
    COUNT(*) AS total_records,
    COUNT(enrollment) AS non_null_enrollment,
    COUNT(*) - COUNT(enrollment) AS null_enrollment,
    MIN(enrollment) AS minimum_enrollment,
    MAX(enrollment) AS maximum_enrollment,
    AVG(enrollment) AS average_enrollment
FROM raw_trials;

---check the suspicious enrollment value
SELECT
    "nct_number",
    title,
    enrollment
FROM raw_trials
WHERE enrollment = 0
   OR enrollment >= 1000000
ORDER BY enrollment DESC;

---missing study documents
SELECT COUNT(*) AS missing_study_documents
FROM raw_trials
WHERE study_documents IS NULL
   OR TRIM(study_documents) = '';

---missing url 
SELECT COUNT(*) AS missing_url
FROM raw_trials
WHERE url IS NULL
   OR TRIM(url) = '';

---check nct number formate
SELECT nct_number
FROM raw_trials
WHERE nct_number !~ '^NCT[0-9]{8}$';

---chrck invalid enrollment 
SELECT COUNT(*) AS negative_enrollment
FROM raw_trials
WHERE enrollment < 0;

---gender group by values
SELECT gender, COUNT(*) AS record_count
FROM raw_trials
GROUP BY gender
ORDER BY record_count DESC;

---create clean_trials
CREATE TABLE clean_trials AS
SELECT *
FROM raw_trials;

---Remove accidental spaces from text fields
UPDATE clean_trials
SET
    nct_number = NULLIF(TRIM(nct_number), ''),
    title = NULLIF(TRIM(title), ''),
    acronym = NULLIF(TRIM(acronym), ''),
    status = NULLIF(TRIM(status), ''),
    study_results = NULLIF(TRIM(study_results), ''),
    conditions = NULLIF(TRIM(conditions), ''),
    interventions = NULLIF(TRIM(interventions), ''),
    outcome_measures = NULLIF(TRIM(outcome_measures), ''),
    sponsor_collaborators = NULLIF(TRIM(sponsor_collaborators), ''),
    gender = NULLIF(TRIM(gender), ''),
    age = NULLIF(TRIM(age), ''),
    phases = NULLIF(TRIM(phases), ''),
    funded_bys = NULLIF(TRIM(funded_bys), ''),
    study_type = NULLIF(TRIM(study_type), ''),
    study_designs = NULLIF(TRIM(study_designs), ''),
    other_ids = NULLIF(TRIM(other_ids), ''),
    start_date = NULLIF(TRIM(start_date), ''),
    primary_completion_date = NULLIF(TRIM(primary_completion_date), ''),
    completion_date = NULLIF(TRIM(completion_date), ''),
    first_posted = NULLIF(TRIM(first_posted), ''),
    results_first_posted = NULLIF(TRIM(results_first_posted), ''),
    last_update_posted = NULLIF(TRIM(last_update_posted), ''),
    locations = NULLIF(TRIM(locations), ''),
    study_documents = NULLIF(TRIM(study_documents), ''),
    url = NULLIF(TRIM(url), '');

---QA checks
-- =========================================================
-- FINAL DATA-QUALITY QA TESTS
-- Table: clean_trials
-- =========================================================

-- QA 1: Total records
SELECT
    'QA1_Total_Records' AS test_name,
    COUNT(*) AS result,
    CASE WHEN COUNT(*) = 8131 THEN 'PASS' ELSE 'FAIL' END AS test_result
FROM clean_trials;


-- QA 2: Duplicate NCT numbers
SELECT
    'QA2_Duplicate_NCT' AS test_name,
    COUNT(*) AS duplicate_groups,
    CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS test_result
FROM (
    SELECT nct_number
    FROM clean_trials
    GROUP BY nct_number
    HAVING COUNT(*) > 1
) d;


-- QA 3: Missing NCT numbers
SELECT
    'QA3_Missing_NCT' AS test_name,
    COUNT(*) AS missing_count,
    CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS test_result
FROM clean_trials
WHERE nct_number IS NULL OR TRIM(nct_number) = '';


-- QA 4: Missing titles
SELECT
    'QA4_Missing_Title' AS test_name,
    COUNT(*) AS missing_count,
    CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS test_result
FROM clean_trials
WHERE title IS NULL OR TRIM(title) = '';


-- QA 5: Invalid enrollment
SELECT
    'QA5_Invalid_Enrollment' AS test_name,
    COUNT(*) AS invalid_count,
    CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS test_result
FROM clean_trials
WHERE enrollment IS NOT NULL
  AND enrollment < 0;


-- QA 6: Impossible date order
SELECT
    'QA6_Invalid_Date_Order' AS test_name,
    COUNT(*) AS invalid_count,
    CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS test_result
FROM clean_trials
WHERE start_date IS NOT NULL
  AND completion_date IS NOT NULL
  AND completion_date < start_date;


-- QA 7: Missing required sponsor
SELECT
    'QA7_Missing_Sponsor' AS test_name,
    COUNT(*) AS missing_count,
    CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS test_result
FROM clean_trials
WHERE sponsor_collaborators IS NULL
   OR TRIM(sponsor_collaborators) = '';


-- QA 8: Missing first-posted date
SELECT
    'QA8_Missing_First_Posted' AS test_name,
    COUNT(*) AS missing_count,
    CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS test_result
FROM clean_trials
WHERE first_posted IS NULL
   OR TRIM(first_posted) = '';


-- QA 9: Invalid gender values
SELECT
    'QA9_Invalid_Gender' AS test_name,
    COUNT(*) AS invalid_count,
    CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS test_result
FROM clean_trials
WHERE gender IS NOT NULL
  AND LOWER(TRIM(gender)) NOT IN (
      'all',
      'female',
      'male'
  );


-- QA 10: Invalid study type
SELECT
    'QA10_Invalid_Study_Type' AS test_name,
    COUNT(*) AS invalid_count,
    CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END AS test_result
FROM clean_trials
WHERE study_type IS NOT NULL
  AND study_type NOT IN (
      'Interventional',
      'Observational',
      'Expanded Access:Intermediate-size Population',
      'Expanded Access:Treatment IND/Protocol',
      'Expanded Access:Intermediate-size Population|Treatment IND/Protocol',
      'Expanded Access:Individual Patients',
      'Expanded Access',
      'Expanded Access:Individual Patients|Treatment IND/Protocol',
      'Expanded Access:Individual Patients|Intermediate-size Population'
  );


-- QA 11: Missing locations
SELECT
    'QA11_Missing_Locations' AS test_name,
    COUNT(*) AS missing_count,
    ROUND(COUNT(*) * 100.0 / 8131, 2) AS percentage
FROM clean_trials
WHERE locations IS NULL OR TRIM(locations) = '';


-- QA 12: Missing interventions
SELECT
    'QA12_Missing_Interventions' AS test_name,
    COUNT(*) AS missing_count,
    ROUND(COUNT(*) * 100.0 / 8131, 2) AS percentage
FROM clean_trials
WHERE interventions IS NULL OR TRIM(interventions) = '';


-- QA 13: Missing outcome measures
SELECT
    'QA13_Missing_Outcomes' AS test_name,
    COUNT(*) AS missing_count,
    ROUND(COUNT(*) * 100.0 / 8131, 2) AS percentage
FROM clean_trials
WHERE outcome_measures IS NULL OR TRIM(outcome_measures) = '';


-- QA 14: Very high enrollment
SELECT
    'QA14_Very_High_Enrollment' AS test_name,
    COUNT(*) AS record_count,
    CASE
        WHEN COUNT(*) <= 24 THEN 'REVIEW'
        ELSE 'REVIEW'
    END AS test_result
FROM clean_trials
WHERE enrollment > 1000000;

---checks complition data is earlier than start date
WITH parsed_dates AS (
    SELECT
        nct_number,
        title,
        start_date,
        completion_date,

        CASE
            WHEN start_date ~ '^[A-Za-z]+ [0-9]{4}$'
                THEN TO_DATE(start_date, 'Month YYYY')
            WHEN start_date ~ '^[A-Za-z]+ [0-9]{1,2}, [0-9]{4}$'
                THEN TO_DATE(start_date, 'Month DD, YYYY')
            ELSE NULL
        END AS parsed_start_date,

        CASE
            WHEN completion_date ~ '^[A-Za-z]+ [0-9]{4}$'
                THEN TO_DATE(completion_date, 'Month YYYY')
            WHEN completion_date ~ '^[A-Za-z]+ [0-9]{1,2}, [0-9]{4}$'
                THEN TO_DATE(completion_date, 'Month DD, YYYY')
            ELSE NULL
        END AS parsed_completion_date

    FROM clean_trials
)

SELECT
    nct_number,
    title,
    start_date,
    completion_date,
    parsed_start_date,
    parsed_completion_date
FROM parsed_dates
WHERE parsed_start_date IS NOT NULL
  AND parsed_completion_date IS NOT NULL
  AND parsed_completion_date < parsed_start_date
ORDER BY parsed_start_date;

---Add columns in clean_trials
ALTER TABLE clean_trials
ADD COLUMN start_date_clean DATE,
ADD COLUMN primary_completion_date_clean DATE,
ADD COLUMN completion_date_clean DATE;
ADD COLUMN first_posted_clean DATE,
ADD COLUMN last_update_posted_clean DATE;

---clean start date
UPDATE clean_trials
SET start_date_clean =
    CASE
        WHEN TRIM(start_date) ~ '^[A-Za-z]+ [0-9]{1,2}, [0-9]{4}$'
            THEN TO_DATE(TRIM(start_date), 'Month DD, YYYY')

        WHEN TRIM(start_date) ~ '^[A-Za-z]+ [0-9]{4}$'
            THEN TO_DATE(TRIM(start_date), 'Month YYYY')

        ELSE NULL
    END;

---clean primary completion date
UPDATE clean_trials
SET primary_completion_date_clean =
    CASE
        WHEN TRIM(primary_completion_date) ~ '^[A-Za-z]+ [0-9]{1,2}, [0-9]{4}$'
            THEN TO_DATE(TRIM(primary_completion_date), 'Month DD, YYYY')

        WHEN TRIM(primary_completion_date) ~ '^[A-Za-z]+ [0-9]{4}$'
            THEN TO_DATE(TRIM(primary_completion_date), 'Month YYYY')

        ELSE NULL
    END;

---clean completion date
UPDATE clean_trials
SET completion_date_clean =
    CASE
        WHEN TRIM(completion_date) ~ '^[A-Za-z]+ [0-9]{1,2}, [0-9]{4}$'
            THEN TO_DATE(TRIM(completion_date), 'Month DD, YYYY')

        WHEN TRIM(completion_date) ~ '^[A-Za-z]+ [0-9]{4}$'
            THEN TO_DATE(TRIM(completion_date), 'Month YYYY')

        ELSE NULL
    END;
	
---first_posted_clean
UPDATE clean_trials
SET first_posted_clean =
    CASE
        WHEN TRIM(start_date) ~ '^[A-Za-z]+ [0-9]{1,2}, [0-9]{4}$'
            THEN TO_DATE(TRIM(start_date), 'Month DD, YYYY')

        WHEN TRIM(start_date) ~ '^[A-Za-z]+ [0-9]{4}$'
            THEN TO_DATE(TRIM(start_date), 'Month YYYY')

        ELSE NULL
    END;

---last_update_posted_clean
UPDATE clean_trials
SET last_update_posted_clean =
    CASE
        WHEN TRIM(start_date) ~ '^[A-Za-z]+ [0-9]{1,2}, [0-9]{4}$'
            THEN TO_DATE(TRIM(start_date), 'Month DD, YYYY')

        WHEN TRIM(start_date) ~ '^[A-Za-z]+ [0-9]{4}$'
            THEN TO_DATE(TRIM(start_date), 'Month YYYY')

        ELSE NULL
    END;


---check dates
SELECT
    start_date,
    start_date_clean,
    primary_completion_date,
    primary_completion_date_clean,
    completion_date,
    completion_date_clean,
	last_update_posted_clean
FROM clean_trials
WHERE start_date IS NOT NULL
LIMIT 10;

---delete result first posted (96.82% missing value)
ALTER TABLE clean_trials
DROP COLUMN results_first_posted;

---ckeck column and data types
SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'clean_trials'
ORDER BY ordinal_position;

---standerdise Gender
UPDATE clean_trials
SET gender =
    CASE
        WHEN LOWER(TRIM(gender)) = 'female' THEN 'Female'
        WHEN LOWER(TRIM(gender)) = 'male' THEN 'Male'
        WHEN LOWER(TRIM(gender)) = 'all' THEN 'All'
        ELSE gender
    END;

---Replace null values to All
UPDATE clean_trials
SET gender = 'All'
WHERE gender IS NULL;

---Add column country
ALTER TABLE clean_trials
ADD COLUMN country TEXT;

--- extract last word of location column data
UPDATE clean_trials
SET country =
    CASE
        WHEN locations IS NOT NULL
         AND TRIM(locations) <> ''
         AND locations LIKE '%,%'
        THEN TRIM(
            SUBSTRING(
                locations
                FROM '[^,]+$'
            )
        )
        ELSE NULL
    END;

---Recheck locations and column country
SELECT
    locations,
    country
FROM clean_trials
WHERE locations IS NOT NULL
LIMIT 30;

---Add age_category column 
ALTER TABLE clean_trials
ADD COLUMN age_category TEXT;

---update age category
UPDATE clean_trials
SET age_category =
    CASE
        WHEN age ~ '\([^)]*\)'
        THEN TRIM(
            SUBSTRING(age FROM '\(([^)]*)\)')
        )
        ELSE NULL
    END;

---