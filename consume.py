from kafka import KafkaConsumer

# # How to read topics
# bootstrap_servers = ["localhost:29092"]
# consumer = KafkaConsumer(bootstrap_servers=bootstrap_servers)
# topics = consumer.topics()
# [x for x in topics if not x.startswith("_confluent")]

# Replace 'localhost:9092' with your Kafka server address and port
kafka_server = "localhost:9092"

# Replace 'your_topic' with your actual topic name
topic_name = "cdc.public.transactions"

# Create a Kafka consumer
consumer = KafkaConsumer(
    topic_name,
    bootstrap_servers=[kafka_server],
    auto_offset_reset="earliest",  # Start from the earliest messages
    enable_auto_commit=True,
    # group_id="my-group",  # Consumer group id
)

# Print messages as they are received
for message in consumer:
    print(f"Received message: {message.value.decode('utf-8')}")
