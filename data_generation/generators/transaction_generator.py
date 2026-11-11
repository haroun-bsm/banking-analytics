import uuid
import random
from datetime import datetime, timedelta

TXN_TYPES = ['DEPOSIT', 'DEPOSIT', 'WITHDRAWAL', 'TRANSFER', 'FEE']
CHANNELS  = ['MOBILE', 'MOBILE', 'ONLINE', 'ATM', 'BRANCH']
STATUSES  = ['COMPLETED', 'COMPLETED', 'COMPLETED', 'FAILED', 'REVERSED']

def generate_transactions(accounts, total=200000):
    active_accounts = [a for a in accounts if a['status'] == 'ACTIVE']
    transactions = []
    
    weights = [a['balance'] for a in active_accounts]
    
    for _ in range(total):
        account = random.choices(active_accounts, weights=weights, k=1)[0]
        txn_date = datetime(2020, 1, 1) + timedelta(
            days=random.randint(0, 1460),  # 4 years
            hours=random.randint(0, 23),
            minutes=random.randint(0, 59)
        )
        transactions.append({
            'transaction_id': str(uuid.uuid4()),
            'account_id':     account['account_id'],
            'txn_type':       random.choice(TXN_TYPES),
            'amount':         round(random.uniform(1, 50000), 2),
            'txn_date':       txn_date,
            'channel':        random.choice(CHANNELS),
            'status':         random.choice(STATUSES),
            'description':    f"TXN-{random.randint(10000,99999)}",
            'created_at':     txn_date
        })
    return transactions