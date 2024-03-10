SELECT @@version;

SELECT * FROM sys.databases sd;

--BEGIN
--    CREATE DATABASE opexdb;
--END

CREATE DATABASE opexdb;
USE opexdb;

--USE master;
--DROP DATABASE opexdb;

--select * from sysobjects where name='transactions' and xtype='U';

--DROP TABLE transactions;

if not exists (select * from sysobjects where name='transactions' and xtype='U')
BEGIN
	CREATE TABLE transactions (
	    transaction_id VARCHAR(255) PRIMARY KEY,
	    user_id VARCHAR(255),
	    timestamp datetime2,
	    amount DECIMAL,
	    currency VARCHAR(255),
	    city VARCHAR(255),
	    country VARCHAR(255),
	    merchant_name VARCHAR(255),
	    payment_method VARCHAR(255),
	    ip_address VARCHAR(255),
	    voucher_code VARCHAR(255),
	    affiliateId VARCHAR(255)
	)
END;

INSERT INTO
transactions(
	transaction_id, user_id, timestamp, amount, currency,
	city, country, merchant_name, payment_method,ip_address,
	affiliateId, voucher_code)
VALUES ('392b885b-5913-49ed-9c09-b4b5316b6ac5',
 'gregory38',
 '2024-03-09 07:55:02',
 640.65,
 'GBP',
 'North Johnathanstad',
 'Qatar',
 'Hancock and Sons',
 'online_transfer',
 '43.86.124.22',
 '1ce56f95-dc44-4e30-a2d0-2c48971b0894',
 '');

SELECT * from transactions t;


-- https://github.com/InterruptSpeed/sql-server-cdc-with-pyspark
-- https://medium.com/@rajatbelgundi/streaming-sql-server-data-to-kafka-using-debezium-sql-connector-on-docker-1bbb1cedfdb3
-- https://hevodata.com/learn/debezium-sql-server/#8

-- Enable CDC at the Database Level
EXEC sys.sp_cdc_enable_db;

ALTER DATABASE opexdb SET CHANGE_TRACKING = ON
(CHANGE_RETENTION = 2 DAYS, AUTO_CLEANUP = ON);

-- Enable CDC at Table level
EXEC sys.sp_cdc_enable_table
	@source_schema = 'dbo',
	@source_name = 'transactions',
	@role_name = NULL,
	@capture_instance='transactions_instance',
	@supports_net_changes = 1;

-- source_schema is the database object
-- source_name is the table name
-- capture_instance is the name of the instance of the CDC enabled table

EXEC sys.sp_cdc_help_change_data_capture;


select * from cdc.transactions_instance_CT tic
