-- Core study information
CREATE TABLE studies (
    study_id SERIAL PRIMARY KEY,
    nct_id VARCHAR(20) UNIQUE NOT NULL,
    title TEXT,
    acronym VARCHAR(50),
    status VARCHAR(50),
    phase VARCHAR(50),
    study_type VARCHAR(50),
    start_date DATE,
    completion_date DATE,
    primary_completion_date DATE,
    enrollment INTEGER,
    enrollment_type VARCHAR(20),
    brief_summary TEXT,
    eligibility_criteria TEXT,
    minimum_age VARCHAR(20),
    maximum_age VARCHAR(20),
    gender VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Study conditions/diseases
CREATE TABLE conditions (
    condition_id SERIAL PRIMARY KEY,
    study_id INTEGER REFERENCES studies(study_id),
    condition_name VARCHAR(255) NOT NULL,
    mesh_term VARCHAR(255)
);

-- Interventions
CREATE TABLE interventions (
    intervention_id SERIAL PRIMARY KEY,
    study_id INTEGER REFERENCES studies(study_id),
    intervention_type VARCHAR(50),
    name VARCHAR(255),
    description TEXT
);

-- Outcome measures
CREATE TABLE outcomes (
    outcome_id SERIAL PRIMARY KEY,
    study_id INTEGER REFERENCES studies(study_id),
    outcome_type VARCHAR(20),
    measure TEXT,
    time_frame VARCHAR(255),
    description TEXT
);

-- Sponsors
CREATE TABLE sponsors (
    sponsor_id SERIAL PRIMARY KEY,
    study_id INTEGER REFERENCES studies(study_id),
    agency VARCHAR(255),
    agency_class VARCHAR(50),
    lead_or_collaborator VARCHAR(20)
);

-- Geographic locations
CREATE TABLE locations (
    location_id SERIAL PRIMARY KEY,
    study_id INTEGER REFERENCES studies(study_id),
    facility VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    continent VARCHAR(50)
);

-- Study design
CREATE TABLE study_design (
    design_id SERIAL PRIMARY KEY,
    study_id INTEGER REFERENCES studies(study_id),
    allocation VARCHAR(50),
    intervention_model VARCHAR(100),
    masking VARCHAR(100),
    primary_purpose VARCHAR(50),
    observational_model VARCHAR(50),
    time_perspective VARCHAR(50)
);

-- ============================================
-- Indexes
-- ============================================

CREATE INDEX idx_studies_status
ON studies(status);

CREATE INDEX idx_studies_phase
ON studies(phase);

CREATE INDEX idx_studies_start_date
ON studies(start_date);

CREATE INDEX idx_conditions_name
ON conditions(condition_name);

CREATE INDEX idx_locations_country
ON locations(country);

CREATE INDEX idx_sponsors_agency
ON sponsors(agency);