IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'opexdb')
BEGIN
    CREATE DATABASE opexdb;
END
