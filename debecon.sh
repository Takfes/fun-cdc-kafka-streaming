# # from terminal
# curl localhost:8093/connectors

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
