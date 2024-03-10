# # from terminal
# curl localhost:8093/connectors
# curl -XGET localhost:8093/connectors?expand=status | jq
# curl -XGET localhost:8093/connectors?expand=info | jq
# curl -XGET localhost:8093/connectors/postgres-connector | jq
# curl -XDELETE localhost:8093/connectors/mssql-connector

# from terminal
curl -H 'Content-Type: application/json' -X POST localhost:8093/connectors --data '{
  "name": "postgres-connector",
  "config": {
    "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
    "plugin.name": "pgoutput",
    "database.hostname": "postgres",
    "database.port": "5432",
    "database.user": "postgres",
    "database.password": "postgres",
    "database.dbname": "opexdb",
    "database.server.name": "postgres",
    "table.include.list": "public.transactions",
    "topic.prefix": "cdc",
    "decimal.handling.mode": "string"
  }
}'

# curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" localhost:8093/connectors -d '{
# "database.dbname": "opexdb",
# "encrypt": "false",
# "trustServerCertificate": "true"
# "database.sslmode": "disable"
curl -H 'Content-Type: application/json' -X POST localhost:8093/connectors --data '{
  "name": "mssql-connector",
  "config": {
    "connector.class": "io.debezium.connector.sqlserver.SqlServerConnector",
    "database.hostname": "mssql",
    "database.port": "1433",
    "database.user": "sa",
    "database.password": "pass123@MSSQL",
    "database.names": "opexdb",
    "database.server.name": "mssql",
    "table.include.list": "dbo.transactions",
    "database.history.kafka.bootstrap.servers": "broker:9092",
    "database.history.kafka.topic": "dbhistory.transactions",
    "topic.prefix": "mssqlcdc",
    "decimal.handling.mode": "string",
    "database.sslmode": "require",
    "database.trustServerCertificate": "true",
    "schema.history.internal.kafka.topic": "schema-changes.transactions",
    "schema.history.internal.kafka.bootstrap.servers": "broker:9092"
  }
}'

# curl -H 'Content-Type: application/json' -X POST localhost:8093/connectors --data '{
#   "name": "mssql-connector",
#   "config": {
#     "connector.class": "io.debezium.connector.sqlserver.SqlServerConnector",
#     "database.hostname": "mssql",
#     "database.port": "1433",
#     "database.user": "sa",
#     "database.password": "pass123@MSSQL",
#     "database.dbname": "opexdb",
#     "database.server.name": "mssql",
#     "database.names": "opexdb",
#     "table.include.list": "dbo.transactions",
#     "database.history.kafka.bootstrap.servers": "broker:9092",
#     "database.history.kafka.topic": "dbhistory.transactions",
#     "topic.prefix": "cdcc",
#     "decimal.handling.mode": "string",
#     "database.history.consumer.security.protocol": "SASL_SSL",
#     "database.history.consumer.sasl.mechanism": "PLAIN",
#     "database.history.consumer.sasl.jaas.config": "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"sa\" password=\"pass123@MSSQL\";",
#     "database.history.producer.security.protocol": "SASL_SSL",
#     "database.history.producer.sasl.mechanism": "PLAIN",
#     "database.history.producer.sasl.jaas.config": "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"sa\" password=\"pass123@MSSQL\";",
#     "database.sslmode": "require",
#     "database.trustServerCertificate": "true"
#   }
# }'

# # from inside debezium container
# curl -H 'Content-Type: application/json' -X POST debezium:8083/connectors --data '{
#   "name": "postgres-connector",
#   "config": {
#     "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
#     "plugin.name": "pgoutput",
#     "database.hostname": "postgres",
#     "database.port": "5432",
#     "database.user": "postgres",
#     "database.password": "postgres",
#     "database.dbname": "opexdb",
#     "database.server.name": "postgres",
#     "table.include.list": "public.transactions",
#     "topic.prefix": "cdc",
#     "decimal.handling.mode": "string"
#   }
# }'
