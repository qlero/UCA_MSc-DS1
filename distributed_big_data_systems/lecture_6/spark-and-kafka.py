"""
This code should be run with `spark-submit` and `packages` argument:

spark-submit --packages org.apache.spark:spark-sql-kafka-0-10_2.11:2.3.4 \
             spark-and-kafka.py
"""
from time import sleep

from pyspark.sql import SparkSession
from pyspark.sql.functions import col
from pyspark.sql.types import StringType

# creating SparkSession is the same as for batch job
# Main difference here is `spark.sql.streaming.checkpointLocation` which can be set to any folder you like
spark = (
    SparkSession.builder
    .config("spark.sql.streaming.checkpointLocation", "/tmp/qlr")
    .getOrCreate()
)
# to read from Kafka, one need to specify Kafka servers and topic names
main_topic = (
    spark.readStream.format("kafka")
    .option("kafka.bootstrap.servers", "pkc-4r297.europe-west1.gcp.confluent.cloud:9092")
    .option("security.protocol", "SASL_SSL")
    .option("sasl.mechanism", "PLAIN")
    .option("sasl.plain.username", "{KEY}")
    .option("sasl.plain.password", "{SECRET}")
    .option("subscribe", "qlr")
    .option("startingOffsets", "earliest")
    .load()
)
# for writing new events to another Kafka topic also needs Kafka servers and
# a topic name
(
    main_topic.writeStream.format("kafka")
    .option("kafka.bootstrap.servers", "pkc-4r297.europe-west1.gcp.confluent.cloud:9092")
    .option("security.protocol", "SASL_SSL")
    .option("sasl.mechanism", "PLAIN")
    .option("sasl.plain.username", "{KEY}")
    .option("sasl.plain.password", "{SECRET}")
    .option("topic", "main_topic")
    .start()
)
# in production we run streaming jobs forever, here we wait for several seconds
sleep(2)
# when writing aggregated values, we need to set output mode to `complete`
# also, for writing to Kafka some values, we need to have the only string
# column named `value`
(
    main_topic.groupby()
    .count()
    .select(col("count").cast(StringType()).alias("value"))
    .writeStream.format("kafka")
    .option("kafka.bootstrap.servers", "pkc-4r297.europe-west1.gcp.confluent.cloud:9092")
    .option("security.protocol", "SASL_SSL")
    .option("sasl.mechanism", "PLAIN")
    .option("sasl.plain.username", "{KEY}")
    .option("sasl.plain.password", "{SECRET}")
    .option("topic", "main_topic")
    .outputMode("complete")
    .start()
)
sleep(2)