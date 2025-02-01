CREATE OR REPLACE DATABASE HEALTHCARE_DB;
SHOW DATABASES;


CREATE OR REPLACE STORAGE INTEGRATION healthcare_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = AZURE
  ENABLED = TRUE
  AZURE_TENANT_ID =  '132132321357-47f7-bbf3-23223'
  STORAGE_ALLOWED_LOCATIONS = ('azure://healthcaredatav1.blob.core.windows.net/healthcarecontainer');

  show integrations;

  DESC STORAGE integration healthcare_integration;

CREATE OR REPLACE FILE FORMAT healthcare_db.public.fileformat
  TYPE = CSV
  FIELD_DELIMITER = ','
  SKIP_HEADER = 1;

  SHOW FILE FORMATS;


  CREATE OR REPLACE STAGE healthcare_db.public.stage
  STORAGE_INTEGRATION = healthcare_integration
  URL = 'azure://healthcaredatav1.blob.core.windows.net/healthcarecontainer'
  FILE_FORMAT = fileformat;

LIST @healthcare_db.public.stage;


select $1,$2,$3,$4,$5 from @healthcare_db.public.stage;



CREATE OR REPLACE NOTIFICATION INTEGRATION notification_integration_healthcare
  ENABLED = TRUE
  TYPE = QUEUE
  NOTIFICATION_PROVIDER = AZURE_STORAGE_QUEUE
  AZURE_STORAGE_QUEUE_PRIMARY_URI = 'https://healthcaredatav1.queue.core.windows.net/healthqueue'
  AZURE_TENANT_ID = '1231231313-6557-47f7-bbf3-2323232';

  DESC NOTIFICATION INTEGRATION notification_integration_healthcare;


CREATE OR REPLACE TABLE healthcare_db.public.hospitals (
    hospital_name VARCHAR,
    city VARCHAR,
    state VARCHAR,
    beds NUMBER,
    specialties VARCHAR
);


CREATE OR REPLACE PIPE pipe_healthcare
  AUTO_INGEST = TRUE
  INTEGRATION = 'NOTIFICATION_INTEGRATION_HEALTHCARE'
  AS
  COPY INTO healthcare_db.public.hospitals
  FROM @healthcare_db.public.stage;


  select * from healthcare_db.public.hospitals
