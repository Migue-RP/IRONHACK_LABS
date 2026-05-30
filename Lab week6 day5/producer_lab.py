from kafka import KafkaProducer
import json
import time

# Create Kafka producer
producer = KafkaProducer(
    bootstrap_servers='localhost:9092',
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

# Sample orders
orders = [
    {"customer": "John", "amount": 500},
    {"customer": "Sara", "amount": 1200},
    {"customer": "Mike", "amount": 300},
    {"customer": "Alice", "amount": 1500}
]

# Continuously send messages
while True:
    for order in orders:
        producer.send("orders", order)
        print(f"Sent: {order}")
        time.sleep(2)

