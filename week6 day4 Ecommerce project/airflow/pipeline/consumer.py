from kafka import KafkaConsumer
import json
import pandas as pd

def consumer_orders():

    consumer = KafkaConsumer(
        'miniproject_orders',
        bootstrap_servers='host.docker.internal:19092',
        auto_offset_reset='earliest',
        enable_auto_commit=True,
        group_id='orders-group-v2',
        value_deserializer=lambda x: json.loads(x.decode('utf-8')),
        consumer_timeout_ms=10000
    )

    rows = []

    for i, event in enumerate(consumer):
        rows.append(event.value)

        if i >= 9999:
            break

    df = pd.DataFrame(rows)

    df.to_csv('/opt/airflow/data/ecommerce_project/raw_orders.csv', index=False)

    print("Raw orders batch written to CSV.")