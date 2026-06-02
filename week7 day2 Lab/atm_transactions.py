from pyspark.sql import SparkSession
from pyspark.sql.functions import col, from_json, avg, sum, count
from pyspark.sql.types import StructType, StructField, StringType

def main():
    # 1. Initialize Spark Session with Kafka connector dependency
    spark = SparkSession.builder \
        .appName("ATM_transactions") \
        .master("local[*]") \
        .config("spark.jars.packages", "org.apache.spark:spark-sql-kafka-0-10_2.12:3.5.0") \
        .getOrCreate()

    spark.sparkContext.setLogLevel("WARN")

    # 2. Define Schema (Crucial: 'amount' is StringType to safely read the quoted JSON value)
    atm_schema = StructType([
        StructField("transaction_id", StringType(), True),
        StructField("atm_id", StringType(), True),
        StructField("country", StringType(), True),
        StructField("city", StringType(), True),
        StructField("amount", StringType(), True), 
        StructField("transaction_type", StringType(), True)
    ])

    # 3. Connect to the Kafka Topic
    kafka_stream_df = spark.readStream \
        .format("kafka") \
        .option("kafka.bootstrap.servers", "localhost:9092") \
        .option("subscribe", "europe_atm_transactions") \
        .option("startingOffsets", "latest") \
        .load()

    # Convert binary payload to usable text and break out JSON elements
    parsed_df = kafka_stream_df \
        .selectExpr("CAST(value AS STRING) as json_payload") \
        .select(from_json(col("json_payload"), atm_schema).alias("data")) \
        .select("data.*")

    # 4. Cast Data Type: Convert the string amount to a functional Integer
    clean_df = parsed_df.withColumn("amount", col("amount").cast("integer"))

    # 5. Fraud Engine: Isolate any high-value withdrawal above €3,000
    fraud_alerts_df = clean_df \
        .filter(col("amount") > 4500) \
        .select("transaction_id", "country", "city", "amount")

    # 6. Global Analytics Matrix (Aggregated by City since Country is fixed)
    kpi_summary_df = clean_df \
        .groupBy("country", "city") \
        .agg(
            count("transaction_id").alias("total_transactions"),
            sum("amount").alias("total_withdrawal_amount"),
            avg("amount").alias("avg_withdrawal_amount")
        )

    # 7. Start Streaming Sinks to Terminal Console
    
    # Real-time incident alert log (Append Mode)
    fraud_query = fraud_alerts_df.writeStream \
        .trigger(processingTime='2 seconds') \
        .outputMode("append") \
        .format("console") \
        .option("truncate", "false") \
        .start()

    # Continuous running totals block (Complete Mode)
    kpi_query = kpi_summary_df.writeStream \
        .trigger(processingTime='5 seconds') \
        .outputMode("complete") \
        .format("console") \
        .option("truncate", "false") \
        .start()

    # Maintain script execution
    fraud_query.awaitTermination()
    kpi_query.awaitTermination()

if __name__ == "__main__":
    main()