import uuid
import random
from datetime import datetime, timedelta
from faker import Faker

fake = Faker()
random.seed(42)
Faker.seed(42)

SEGMENTS = ['RETAIL', 'RETAIL', 'RETAIL', 'SME', 'SME', 'CORPORATE']
CITIES = ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix',
          'Philadelphia', 'San Antonio', 'San Diego', 'Dallas', 'Miami']

def generate_customers(n=5000):
    customers = []
    base_date = datetime(2018, 1, 1)
    
    for _ in range(n):
        created = base_date + timedelta(days=random.randint(0, 1800))
        updated = created + timedelta(days=random.randint(0, 400))
        customers.append({
            'customer_id':   str(uuid.uuid4()),
            'first_name':    fake.first_name(),
            'last_name':     fake.last_name(),
            'date_of_birth': fake.date_of_birth(minimum_age=18, maximum_age=75),
            'city':          random.choice(CITIES),
            'country':       'US',
            'segment':       random.choice(SEGMENTS),
            'email':         fake.email(),
            'phone':         fake.phone_number()[:20],
            'created_at':    created,
            'updated_at':    updated,
            'is_deleted':    random.random() < 0.02  # 2% churned
        })
    return customers