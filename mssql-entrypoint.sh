#!/bin/bash
# Start SQL Server
/opt/mssql/bin/sqlservr &

# Wait for it to be available
echo "Waiting for MS SQL to be available..."
sleep 20s

# Run the initialization script
echo "Running the initialization script..."
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "mssqlpsw" -d master -i /mssql-init.sql

# Keep container running
tail -f /dev/null
