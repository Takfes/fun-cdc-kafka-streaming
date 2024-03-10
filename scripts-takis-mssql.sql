SELECT @@version;

SELECT * FROM sys.databases sd;

--BEGIN
--    CREATE DATABASE opexdb;
--END

CREATE DATABASE opexdb;
USE opexdb;

USE master;
DROP DATABASE opexdb;

select * from sysobjects where name='transactions' and xtype='U';

DROP TABLE transactions;

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
