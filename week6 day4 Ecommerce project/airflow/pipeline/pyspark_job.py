import os

os.environ["SPARK_LOCAL_IP"] = "127.0.0.1"
os.environ["PYSPARK_PYTHON"] = "python"
os.environ["PYSPARK_DRIVER_PYTHON"] = "python"

from pyspark.sql import SparkSession


def transform_and_load():
    # Update to point to the exact 3.14.5 and 3.0.0 filenames
    jdbc_jar = "/opt/airflow/data/jars/snowflake-jdbc-3.14.5.jar"
    connector_jar = "/opt/airflow/data/jars/spark-snowflake_2.12-3.0.0.jar"

    spark = SparkSession.builder \
        .appName("raw_orders_transformation") \
        .master("local[*]") \
        .config("spark.jars", f"{jdbc_jar},{connector_jar}") \
        .getOrCreate()

    orders_df = spark.read.csv(
        "/opt/airflow/data/ecommerce_project/raw_orders.csv",
        header=True,
        inferSchema=True
    )
    customers_df = spark.read.csv(
        "/opt/airflow/data/ecommerce_project/customers.csv",
        header=True,
        inferSchema=True
    )

    products_df = spark.read.csv(
        "/opt/airflow/data/ecommerce_project/products.csv",
        header=True,
        inferSchema=True
    )

    orders_df = orders_df.dropDuplicates()


    orders_df = orders_df \
        .withColumn("order_id", orders_df["order_id"].cast("integer")) \
        .withColumn("customer_id", orders_df["customer_id"].cast("integer")) \
        .withColumn("product_id", orders_df["product_id"].cast("integer")) \
        .withColumn("amount", orders_df["amount"].cast("double")) \
        .withColumn("order_time", orders_df["order_time"].cast("timestamp"))

    transformed_df = orders_df \
        .join(customers_df, on="customer_id", how="left") \
        .join(products_df, on="product_id", how="left")


    sfOptions = {
        "sfURL": "VYTWKTY-TC76598.snowflakecomputing.com",
        "sfUser": "MIGUERP89",
        "sfPassword": "xxxxxxx",
        "sfDatabase": "ECOMMERCE_DB",
        "sfSchema": "BATCH",
        "sfWarehouse": "COMPUTE_WH",
        "sfRole": "ACCOUNTADMIN"
    }


    transformed_df.write \
        .format("snowflake") \
        .options(**sfOptions) \
        .option("dbtable", "pyspark_transformated_orders") \
        .mode("overwrite") \
        .save()

    print("Data successfully loaded into Snowflake.")

    spark.stop()