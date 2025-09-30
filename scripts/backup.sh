#!/bin/bash
DATE=$(date +%F)
pg_dump -U admin gptxdb > backup/postgres_$DATE.sql
mysqldump -u root -prootpass gptxdb > backup/mysql_$DATE.sql

