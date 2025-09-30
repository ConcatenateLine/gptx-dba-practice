# Role and Permission Strategy

This document outlines a basic role-based access control (RBAC) model for SQL and NoSQL databases.

## PostgreSQL / MySQL

### Roles
- `admin`: Full privileges, including schema changes and user management.
- `developer`: Read/write access to application tables, no schema changes.
- `auditor`: Read-only access to logs and audit tables.

### Example
```sql
CREATE ROLE developer;
GRANT SELECT, INSERT, UPDATE ON users TO developer;

CREATE ROLE auditor;
GRANT SELECT ON logs TO auditor;
```

## MongoDB

Use role-based access control via createUser and roles.

```js
db.createUser({
  user: "devUser",
  pwd: "securepass",
  roles: [{ role: "readWrite", db: "gptxdb" }]
});
```

## Redis    

Redis ACLs can be configured via users.acl file or CLI.

```bash
ACL SETUSER devUser on >securepass ~* +@write
```

Notes:
- Always follow least privilege principle.
- Document role changes and audit regularly.

