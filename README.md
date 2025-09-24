# ITSM Ticket Pipeline  

This project processes and visualizes IT Service Management (ITSM) data using **Apache Airflow, DBT, Postgres, and Apache Superset**.  

## 📌 Project Overview  
- **Data Ingestion**: Load raw CSV ticket dump into Postgres.  
- **Transformation (DBT)**:  
  - Clean data (remove duplicates, handle nulls, standardize dates).  
  - Extract Year, Month, Day from `Created Date`.  
  - Calculate average resolution time per Category & Priority.  
  - Calculate closure rate per Assigned Group.  
  - Create Monthly Ticket Summary (tickets, resolution time, closure rate).  
- **Orchestration (Airflow)**:  
  - DAG schedules ingestion + transformations once every 24 hours.  
- **Visualization (Superset)**:  
  - **Ticket Volume Trends** → Line Chart (tickets per day).  
  - **Resolution Time** → Bar Chart (avg. time per Category).  
  - **Closure Rate** → Pie Chart (by Assigned Group).  
  - **Ticket Backlog** → Table (open tickets grouped by Priority).  
  - Filters → Week, Category, Priority.  

## 🛠️ Tech Stack  
- Apache Airflow  
- DBT (Data Build Tool)  
- PostgresDB  
- Apache Superset  

## 🚀 How to Run Locally  
1. Clone the repo:  
   ```bash
   git clone https://github.com/natarajaguhank/itsm_ticket_pipeline.git
   cd itsm_ticket_pipeline
   ```
2. Start services:  
   ```bash
   docker-compose up --build
   ```
3. Place dataset at:  
   ```
   data/itsm_tickets.csv
   ```
4. Airflow DAG (`itsm_dag.py`) will:  
   - Load CSV → Postgres  
   - Run DBT models  
   - Update tables for visualization  
5. Access Superset at: [http://localhost:8088](http://localhost:8088)  
   - Import the provided **`itsm_dashboard.json`** to view dashboards.  

## 📂 Repository Structure  
```
itsm_ticket_pipeline/
├── airflow/              # Airflow DAGs & configs
├── airflow-image/        # Custom Airflow image (dbt, psycopg2)
├── dbt_project/          # DBT models & transformations
├── superset/             # Dashboard export (JSON)
├── data/                 # Input CSV dataset
├── docker-compose.yml
├── README.md
└── .gitignore
```

## ✅ Deliverables  
- Airflow DAG file  
- DBT project files & SQL models  
- Superset dashboard export (JSON)  
- Documentation (this README)  
