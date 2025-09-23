FROM apache/airflow:2.7.1

# Switch to airflow user to install Python packages
USER airflow

# Install DBT, Postgres driver, Pandas, SQLAlchemy
RUN pip install --no-cache-dir dbt-postgres psycopg2-binary pandas sqlalchemy

# Switch back to root to copy wait script (optional, or you can keep airflow)
USER root

# Copy wait-for-postgres.sh script into container
COPY wait-for-postgres.sh /opt/airflow/wait-for-postgres.sh
RUN chmod +x /opt/airflow/wait-for-postgres.sh

# Switch back to airflow user
USER airflow
