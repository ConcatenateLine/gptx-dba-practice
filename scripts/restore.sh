#!/bin/bash
psql -U admin gptxdb < backup/postgres_$1.sql
mysql -u root -prootpass gptxdb < backup/mysql_$1.sql

