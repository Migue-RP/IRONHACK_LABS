from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta

from pipeline.consumer import consumer_orders
from pipeline.pyspark_job import transform_and_load

default_args = {
    'owner': 'Miguel',
    'retries': 1,
    'retry_delay': timedelta(minutes=2)
}

with DAG(
    dag_id='ecommerce_pipeline',
    default_args=default_args,
    schedule='@weekly',
    start_date=datetime(2025, 1, 1),
    catchup=False,
    max_active_runs=1
) as dag:

    consumer_task = PythonOperator(
        task_id='consumer_kafka_orders',
        python_callable=consumer_orders
    )

    transform_task = PythonOperator(
        task_id='transform_and_load_snowflake',
        python_callable=transform_and_load
    )

    consumer_task >> transform_task