from kafka import KafkaProducer
import json
import random
import time
from datetime import datetime

producer = KafkaProducer(
    bootstrap_servers='localhost:9092',
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)
status = ['COMPLETED', 'PENDING', 'CANCELLED']
payments = ['Transfer', 'Card', 'Cash']
order_id = 1
for i in range(10000):

    random_day = random.randint(1, 7)
    random_hour = random.randint(0, 23)
                                 
    order = {
        "order_id": order_id,
        "customer_id": random.randint(1,1000),
        "product_id": random.randint(1,20),
        "amount": round(random.uniform(500, 5000), 2),
        "payment_mode": random.choice(payments),
        "order_time": f"2026-05-0{random_day} {random_hour}:00:00",
        "status": random.choice(status)
    }
    producer.send('miniproject_orders', value=order)
    print("Sent:", order)
    order_id += 1

print("Finished producing 10,000 events.")