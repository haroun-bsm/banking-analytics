import pandas as pd
from sqlalchemy import create_engine

DB_URL = "postgresql://dbt_user:dbt_pass@localhost:5432/banking_dw"

engine = create_engine(DB_URL)

def query(sql):
    return pd.read_sql(sql, engine)