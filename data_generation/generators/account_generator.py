import uuid
import random
from datetime import datetime, timedelta

ACCOUNT_TYPES = ['CHECKING', 'SAVINGS', 'TERM_DEPOSIT']
STATUSES = ['ACTIVE', 'ACTIVE', 'ACTIVE', 'CLOSED', 'FROZEN']

def generate_accounts(customers, avg_accounts=1.6):
    accounts = []
    for customer in customers:
        num_accounts = max(1, int(random.gauss(avg_accounts, 0.8)))
        for _ in range(num_accounts):
            opened = customer['created_at'] + timedelta(days=random.randint(0, 30))
            status = random.choice(STATUSES)
            closed_date = None
            if status == 'CLOSED':
                closed_date = opened + timedelta(days=random.randint(90, 900))
            
            accounts.append({
                'account_id':   str(uuid.uuid4()),
                'customer_id':  customer['customer_id'],
                'account_type': random.choice(ACCOUNT_TYPES),
                'status':       status,
                'currency':     'USD',
                'balance':      round(random.uniform(100, 500000), 2),
                'opened_date':  opened.date(),
                'closed_date':  closed_date,
                'created_at':   opened
            })
    return accounts