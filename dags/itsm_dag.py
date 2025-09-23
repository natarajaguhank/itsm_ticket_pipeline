import os
import pandas as pd
from sqlalchemy import create_engine
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.utils.dates import days_ago
import subprocess

# Path to CSV inside container
CSV_FILE = '/opt/airflow/dbt/data/itsm_tickets.csv'

# Postgres connection string
POSTGRES_CONN = 'postgresql+psycopg2://{user}:{password}@{host}:{port}/{db}'.format(
    user=os.environ.get('POSTGRES_USER'),
    password=os.environ.get('POSTGRES_PASSWORD'),
    host='postgres',   # matches docker-compose service name
    port=os.environ.get('POSTGRES_PORT', 5432),
    db=os.environ.get('POSTGRES_DB')
)

def load_csv_to_postgres():
    if not os.path.exists(CSV_FILE):
        raise FileNotFoundError(f"{CSV_FILE} not found inside container")
    
    df = pd.read_csv(CSV_FILE)

    # Ensure all expected columns exist
    expected_cols = [
        'inc_business_service', 'inc_category', 'inc_number', 'inc_priority',
        'inc_sla_due', 'inc_sys_created_on', 'inc_resolved_at', 'inc_assigned_to',
        'inc_state', 'inc_cmdb_ci', 'inc_caller_id', 'inc_short_description',
        'inc_assignment_group', 'inc_close_code', 'inc_close_notes'
    ]
    
    df = df[expected_cols]

    # Connect to Postgres and write table
    engine = create_engine(POSTGRES_CONN)
    df.to_sql('itsm_tickets_raw', engine, if_exists='replace', index=False)
    print(f"Loaded {len(df)} rows into Postgres table 'itsm_tickets_raw'")

def run_dbt_models():
    subprocess.run(
        ["dbt", "run", "--project-dir", "/opt/airflow/dbt", "--profiles-dir", "/opt/airflow/dbt/profiles"],
        check=True
    )

# Define DAG
with DAG(
    'itsm_ticket_pipeline',
    start_date=days_ago(1),
    schedule_interval='@daily',
    catchup=False,
    tags=['itsm', 'tickets']
) as dag:

    ingest_task = PythonOperator(
        task_id='ingest_csv_to_postgres',
        python_callable=load_csv_to_postgres
    )

    dbt_task = PythonOperator(
        task_id='run_dbt_models',
        python_callable=run_dbt_models
    )

    ingest_task >> dbt_task
