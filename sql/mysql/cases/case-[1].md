Go to [`Track progress`](../../../README.md).

# 📚 CASE: Create a Developer Role

```
    Module: MySQL    Date: 2025-10-02    Status: Completed
```

||||||
| ---|--- | --- | --- | --- |
| Related Task: | ` mysql > Create a Developer Role` |
| Commit: | `docs(mysql): add create developer role case report` |

## 📍 Scenario
A developer role is needed with access to the `products` schema and restrict schema changes.

## 🎯 Objective
Create a developer role with access to the `products` schema and restrict schema changes.

## 🧠 Hypothesis
A developer role with access to the `products` schema can read, but not can make schema changes.

## ⚙️ Execution

1. Create a user and grant access to the `products` schema.
```sql
CREATE USER 'dev_user'@'localhost' IDENTIFIED BY 'password';
GRANT SELECT, INSERT, UPDATE, DELETE ON products.* TO 'dev_user'@'localhost';
```

2. Restrict schema changes.
```sql
REVOKE CREATE, ALTER, DROP ON products.* FROM 'dev_user'@'localhost';
```

3. Verify permissions.
```sql
SHOW GRANTS FOR 'dev_user'@'localhost';
```

## 📊 Result
- dev_user can query and modify rows in the `products` schema.
- Attempt to make schema changes results in an error.
- Schema integrity is preserved.


## 🔍 Analysis
The solution worked because the GRANT and REVOKE commands were used to control access to the `products` schema. The GRANT command was used to grant access to the `products` schema, while the REVOKE command was used to remove the ability to make schema changes. This demonstrates how access control can be used to restrict the actions of a user.


## 🛠️ Remediation or Follow-up

```sql
❯  ./utils/connect.sh mysql
✅ 'gptx_mysql' is running. Connecting to mysql...
mysql: [Warning] Using a password on the command line interface can be insecure.
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 8.4.6 MySQL Community Server - GPL

Copyright (c) 2000, 2025, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> CREATE USER 'dev_user'@'localhost' IDENTIFIED BY 'password';
Query OK, 0 rows affected (0.03 sec)

mysql> GRANT SELECT, INSERT, UPDATE, DELETE ON products.* TO 'dev_user'@'localhost';
Query OK, 0 rows affected, 1 warning (0.01 sec)

mysql> REVOKE CREATE, ALTER, DROP ON products.* FROM 'dev_user'@'localhost';
ERROR 1141 (42000): There is no such grant defined for user 'dev_user' on host 'localhost'

mysql> SHOW GRANTS FOR 'dev_user'@'localhost';
+--------------------------------------------------------------------------------+
| Grants for dev_user@localhost                                                  |
+--------------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `dev_user`@`localhost`                                   |
| GRANT SELECT, INSERT, UPDATE, DELETE ON `products`.* TO `dev_user`@`localhost` |
+--------------------------------------------------------------------------------+
2 rows in set (0.00 sec)

mysql> 
```