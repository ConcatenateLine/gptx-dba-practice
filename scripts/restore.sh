#!/bin/bash
docker exec -i gptx_postgres psql -U admin gptxdb < ./scripts/backup/postgres_$1.sql
docker exec -i gptx_mysql mysql -u root -prootpass gptxdb < ./scripts/backup/mysql_$1.sql

