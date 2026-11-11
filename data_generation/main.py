import pandas as pd
from sqlalchemy import create_engine
from generators.customer_generator import generate_customers
from generators.account_generator import generate_accounts
from generators.transaction_generator import generate_transactions
from generators.loan_generator import generate_loans

DB_URL = "postgresql://dbt_user:${DB_PASSWORD}@localhost:5433/banking_dw" 
def load(df, table_name, engine):
    df.to_sql(table_name, engine, schema='raw',
              if_exists='replace', index=False, chunksize=5000)
    print(f"âœ… Loaded {len(df):,} rows â†’ raw.{table_name}")

def main():
    engine = create_engine(DB_URL)

    print("Generating customers...")
    customers = generate_customers(5000)
    
    print("Generating accounts...")
    accounts = generate_accounts(customers)
    
    print("Generating transactions...")
    transactions = generate_transactions(accounts, total=200000)
    
    print("Generating loans...")
    loans = generate_loans(customers, n=2000)

    load(pd.DataFrame(customers),    'customers',    engine)
    load(pd.DataFrame(accounts),     'accounts',     engine)
    load(pd.DataFrame(transactions), 'transactions', engine)
    load(pd.DataFrame(loans),        'loans',        engine)

if __name__ == "__main__":
    main()
