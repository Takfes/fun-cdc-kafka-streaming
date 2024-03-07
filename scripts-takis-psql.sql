-- https://www.postgresqltutorial.com/postgresql-administration/postgresql-show-tables/
psql -U postgres
\l
\c financial_db
\dt

psql -U postgres -d financial_db
\dt
\d transactions