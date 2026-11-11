import uuid
import random
from datetime import datetime, timedelta

LOAN_TYPES   = ['PERSONAL', 'MORTGAGE', 'AUTO', 'BUSINESS']
LOAN_STATUSES = ['CURRENT', 'CURRENT', 'CURRENT', 'OVERDUE', 'DEFAULT', 'PAID_OFF']

def generate_loans(customers, n=2000):
    eligible = [c for c in customers if c['segment'] in ('RETAIL', 'SME', 'CORPORATE')]
    loans = []
    
    for _ in range(n):
        customer = random.choice(eligible)
        principal = round(random.uniform(5000, 500000), 2)
        issue_date = datetime(2019, 1, 1) + timedelta(days=random.randint(0, 1460))
        loan_status = random.choice(LOAN_STATUSES)
        dpd = 0
        if loan_status == 'OVERDUE':
            dpd = random.randint(1, 89)
        elif loan_status == 'DEFAULT':
            dpd = random.randint(90, 365)
        
        loans.append({
            'loan_id':       str(uuid.uuid4()),
            'customer_id':   customer['customer_id'],
            'loan_type':     random.choice(LOAN_TYPES),
            'principal':     principal,
            'outstanding':   round(principal * random.uniform(0.1, 1.0), 2),
            'interest_rate': round(random.uniform(3.5, 18.0), 2),
            'issue_date':    issue_date.date(),
            'due_date':      (issue_date + timedelta(days=random.randint(365, 2555))).date(),
            'loan_status':   loan_status,
            'days_past_due': dpd,
            'created_at':    issue_date
        })
    return loans