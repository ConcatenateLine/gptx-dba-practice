Go to [`DEFAULT README.md`](./README.bk.md) for more information.

# 📁 Case Study Index

Each case corresponds to a documented solution for a task defined in `[module]/tasks.md`.
---

## 🐘 PostgreSQL

| Task | Link to Task | Tags | Link to Case (activity) |
|------|--------------|------|------|
| Create a Role with Limited Access | [task 1](./sql/postgres/tasks.md#1-create-a-role-with-limited-access) | access-control | ✅  [case-[1].md](./sql/postgres/cases/case-[1].md) |
| Optimize a Query | [task 2](./sql/postgres/tasks.md#2-optimize-a-query) | performance, indexing | ✅ [case-[2].md](./sql/postgres/cases/case-[2].md) |
| Simulate Backup and Restore | [task 3](./sql/postgres/tasks.md#3-simulate-backup-and-restore) | recovery, integrity | ✅ [case-[3].md](./sql/postgres/cases/case-[3].md) |
| Monitor Connections | [task 4](./sql/postgres/tasks.md#4-monitor-connections) | observability | ✅ [case-[4].md](./sql/postgres/cases/case-[4].md) |

---

## 🐬 MySQL

| Task | Link to Task | Tags | Link to Case (activity) |
|------|--------------|------|------|
| Create a Developer Role | [task 1](./sql/mysql/tasks.md#1-create-a-developer-role) | access-control | ✅ [case-[1].md](./sql/mysql/cases/case-[1].md) |
| Profile a Query | [task 2](./sql/mysql/tasks.md#2-profile-a-query) | performance | ✅ [case-[2].md](./sql/mysql/cases/case-[2].md) |
| Enable Slow Query Log | [task 3](./sql/mysql/tasks.md#3-enable-slow-query-log) | observability | ✅ [case-[3].md](./sql/mysql/cases/case-[3].md) |
| Test Backup/Restore | [task 4](./sql/mysql/tasks.md#4-test-backuprestore) | recovery | ✅ [case-[4].md](./sql/mysql/cases/case-[4].md) |

---

## 🔴 Redis

| Task | Link to Task | Tags | Link to Case (activity) |
|------|--------------|------|------|
| Simulate Login Cache | [task 1](./nosql/redis/tasks.md#1-simulate-login-cache) | caching, expiration | ✅ [case-[1].md](./nosql/redis/cases/case-[1].md) |
| Use Hashes for Product Info | [task 2](./nosql/redis/tasks.md#2-use-hashes-for-product-info) | data-modeling | ✅ [case-[2].md](./nosql/redis/cases/case-[2].md) |
| Monitor Keyspace | [task 3](./nosql/redis/tasks.md#3-monitor-keyspace) | observability | ✅ [case-[3].md](./nosql/redis/cases/case-[3].md) |
| Automate Cleanup | [task 4](./nosql/redis/tasks.md#4-automate-cleanup) | scripting | ✅ [case-[4].md](./nosql/redis/cases/case-[4].md) |

---

## 🍃 MongoDB

| Task | Link to Task | Tags |  Link to Case (activity) |
|------|--------------|------|------|
| Create a Replica Set | [task 1](./nosql/mongo/tasks.md#1-create-a-replica-set-local) | availability | ✅ [case-[1].md](./nosql/mongo/cases/case-[1].md) |
| Model Nested Documents | [task 2](./nosql/mongo/tasks.md#2-model-nested-documents) | schema-design | ✅ [case-[2].md](./nosql/mongo/cases/case-[2].md) |
| Profile a Query | [task 3](./nosql/mongo/tasks.md#3-profile-a-query) | performance | ✅ [case-[3].md](./nosql/mongo/cases/case-[3].md) |
| Simulate Sharding | [task 4](./nosql/mongo/tasks.md#4-simulate-sharding-optional) | scalability | ✅ [case-[4].md](./nosql/mongo/cases/case-[4].md) |

---

## ⚙️ Scripts

| Task | Link to Task | Tags | Link to Case (activity) |
|------|--------------|------|------|
| Validate Backup Script | [task 1](./scripts/tasks.md#1-validate-backup-script) | automation, integrity | Postgres: ✅ [case-[3].md](./sql/postgres/cases/case-[3].md) | MySQL: ✅ [case-[4].md](./sql/mysql/cases/case-[4].md) |
| Simulate Restore Workflow | [task 2](./scripts/tasks.md#2-simulate-restore-workflow) | recovery |  Postgres: ✅ [case-[3].md](./sql/postgres/cases/case-[3].md) | MySQL: ✅ [case-[4].md](./sql/mysql/cases/case-[4].md), MongoDB: ✅ [case-[2].md](./nosql/mongo/cases/case-[2].md) |
| Monitor PostgreSQL Connections | [task 3](./scripts/tasks.md#3-monitor-postgresql-connections) | observability | Postgres: ✅ [case-[4].md](./sql/postgres/cases/case-[4].md) |
| Add Logging to Scripts | [task 4](./scripts/tasks.md#4-add-logging-to-scripts) | scripting | ✅ Done |
| Simulate Cron-Based Automation | [task 5](./scripts/tasks.md#5-simulate-cron-based-automation) | automation | Redis: ✅ [case-[4].md](./nosql/redis/cases/case-[4].md) |
| Add Error Handling | [task 6](./scripts/tasks.md#6-add-error-handling) | scripting | ✅ Done |
| Optional: Add Email Notification (Local) | [task 7](./scripts/tasks.md#7-add-email-notification-local) | automation | ❌ Not considered |

---

## 📚 Docs

| Task | Link to Task | Tags | Link to Case (activity) |
|------|--------------|------|------|
| Define Role-Based Access Control | [task 1](./docs/tasks.md#1-define-role-based-access-control) | governance, access-control | ✅ [case-[1].md](./docs/roles.md) |
| Write Backup Policy | [task 2](./docs/tasks.md#2-write-backup-policy) | process, recovery | ✅ [case-[2].md](./docs/backup-policy.md) |
| Document Optimization Strategies | [task 3](./docs/tasks.md#3-document-optimization-strategies) | documentation | ✅ [case-[3].md](./docs/optimization.md) |
| Create Contributor Onboarding Guide | [task 4](./docs/tasks.md#4-create-contributor-onboarding-guide) | onboarding | ✅ [case-[4].md](./README.bk.md) |
| Simulate Governance Scenario | [task 5](./docs/tasks.md#5-simulate-governance-scenario) | escalation, incident-response | ✅ [case-[5].md](./docs/governance.md) |
| Optional: Add Markdown Templates | [task 6](./docs/tasks.md#6-add-markdown-templates) | documentation | Case-Template: ✅ [template-case.md](./docs/template-case-[0].md) |

