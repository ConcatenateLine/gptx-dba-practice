#!/bin/bash
DATE=$(date +%F)
docker exec -i gptx_postgres pg_dump -U admin gptxdb > ./scripts/backup/postgres_$DATE.sql
docker exec -i gptx_mysql mysqldump -u root -prootpass gptxdb > ./scripts/backup/mysql_$DATE.sql

