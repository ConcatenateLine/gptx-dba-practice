Go to [`Track progress`](./../../../README.md).

# 📚 CASE: Create a Role with Limited Access

```
    Module: sql/postgres    Date: 2025-10-01    Status: Completed
```

||||||
| ---|--- | --- | --- | --- |
| Related Task: | `postgres > Create a Role with Limited Access` |
| Commit: | `docs(postgres): add role creation case report` |

## 📍 Scenario
Create a `reporting_user` role with read-only access to `users` table.

## 🎯 Objective
Validate that the role has the correct permissions.

## 🧠 Hypothesis
The role should have read-only access to the `users` table.

## ⚙️ Execution

1. Create a `reporting_user` role with read-only access to `users` table.
```sql
CREATE ROLE reporting_user WITH LOGIN PASSWORD 'password';
GRANT SELECT ON users TO reporting_user;
```

2. Validate that the role has the correct permissions.
```sql
\du
\z users
```
3. Connect as `reporting_user` and try to insert a row.
```sql
\c - reporting_user
INSERT INTO users (id, username, email) VALUES (1, 'Lily Doe','lhemail@email.com');
```

4. Connect as `reporting_user` and try to select a row.
```sql
\c - reporting_user
SELECT * FROM users;
```

## 📊 Result
The role has the correct permissions. The user can select from the `users` table but cannot insert a new row.

## 🔍 Analysis
The new role was created with read-only access to the `users` table, but it was not granted the necessary permissions to perform the insert operation. So, the user can select from the `users` table but cannot perform other operations.

## 🛠️ Remediation or Follow-up

```sql
❯ ./utils/connect.sh postgres

✅ 'gptx_postgres' is running. Connecting to postgres...
psql (15.13 (Debian 15.13-1.pgdg120+1))
Type "help" for help.

gptxdb=# INSERT INTO users (id, username, email) VALUES (1, 'Jonh Doe','jhemail@email.com');
INSERT 0 1
gptxdb=# CREATE ROLE reporting_user WITH LOGIN PASSWORD 'password';
CREATE ROLE
gptxdb=# GRANT SELECT ON users TO reporting_user;
GRANT
gptxdb=# \du
                                      List of roles
   Role name    |                         Attributes                         | Member of 
----------------+------------------------------------------------------------+-----------
 admin          | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 reporting_user |                                                            | {}

gptxdb=# \z users
                               Access privileges
 Schema | Name  | Type  |   Access privileges    | Column privileges | Policies 
--------+-------+-------+------------------------+-------------------+----------
 public | users | table | admin=arwdDxt/admin   +|                   | 
        |       |       | reporting_user=r/admin |                   | 
(1 row)

gptxdb=# \c - reporting_user
You are now connected to database "gptxdb" as user "reporting_user".
gptxdb=> INSERT INTO users (id, username, email) VALUES (1, 'Lily Doe','lhemail@email.com');
ERROR:  permission denied for table users
gptxdb=> SELECT * FROM users;
 id | username |       email       |         created_at         
----+----------+-------------------+----------------------------
  1 | Jonh Doe | jhemail@email.com | 2025-10-01 15:16:27.147065
(1 row)

gptxdb=>Exit 
```
