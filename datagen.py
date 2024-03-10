import random
import time
from datetime import datetime

import faker
import pymssql

fake = faker.Faker()


def generate_transaction():
    user = fake.simple_profile()

    return {
        "transactionId": fake.uuid4(),
        "userId": user["username"],
        "timestamp": datetime.utcnow().timestamp(),
        "amount": round(random.uniform(10, 1000), 2),
        "currency": random.choice(["USD", "GBP"]),
        "city": fake.city(),
        "country": fake.country(),
        "merchantName": fake.company(),
        "paymentMethod": random.choice(
            ["credit_card", "debit_card", "online_transfer"]
        ),
        "ipAddress": fake.ipv4(),
        "voucherCode": random.choice(["", "DISCOUNT10", ""]),
        "affiliateId": fake.uuid4(),
    }


def create_table(conn):
    cursor = conn.cursor()

    cursor.execute(
        """
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
        """
    )

    cursor.close()
    conn.commit()


if __name__ == "__main__":
    NOBSV = 10
    SLEEP = 2
    # Define the connection parameters
    server = "localhost"
    database = "opexdb"
    username = "sa"
    password = "pass123@MSSQL"

    # # conn = pymssql.connect(server=server, database=database, user=username, password=password)
    # # Create a cursor object to execute SQL queries
    # cursor = conn.cursor()
    # # Execute a sample query
    # cursor.execute('SELECT * FROM transactions')
    # # Fetch the results
    # results = cursor.fetchall()
    # # Process the results
    # for row in results:
    #     print(row)
    # # Close the cursor and connection
    # cursor.close()
    # conn.close()

    # Connect to the MSSQL server
    conn = pymssql.connect(
        server=server, database=database, user=username, password=password
    )

    for i in range(NOBSV):
        create_table(conn)

        transaction = generate_transaction()
        cur = conn.cursor()
        print(transaction)

        cur.execute(
            """
            INSERT INTO transactions(transaction_id, user_id, timestamp, amount, currency, city, country, merchant_name, payment_method,
            ip_address, affiliateId, voucher_code)
            VALUES (%s, %s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
            """,
            (
                transaction["transactionId"],
                transaction["userId"],
                datetime.fromtimestamp(transaction["timestamp"]).strftime(
                    "%Y-%m-%d %H:%M:%S"
                ),
                transaction["amount"],
                transaction["currency"],
                transaction["city"],
                transaction["country"],
                transaction["merchantName"],
                transaction["paymentMethod"],
                transaction["ipAddress"],
                transaction["affiliateId"],
                transaction["voucherCode"],
            ),
        )

        time.sleep(SLEEP)

    cur.close()
    conn.commit()
