#!/bin/bash

# Usage: ./utils/connect.sh postgres | mysql | redis | mongo

MODULE=$1

if [ -z "$MODULE" ]; then
  echo "❌ No module specified. Usage: ./utils/connect.sh [postgres|mysql|redis|mongo]"
  exit 1
fi

# Map module to container name
case "$MODULE" in
  postgres) CONTAINER="gptx_postgres" ;;
  mysql)    CONTAINER="gptx_mysql" ;;
  redis)    CONTAINER="gptx_redis" ;;
  mongo)    CONTAINER="gptx_mongo" ;;
  *)
    echo "❌ Unknown module: $MODULE. Valid options: postgres, mysql, redis, mongo"
    exit 1
    ;;
esac

# Check health status
STATUS=$(docker inspect --format='{{.State.Status}}' "$CONTAINER" 2>/dev/null)

if [ "$STATUS" != "running" ]; then
  echo "⚠️  Container '$CONTAINER' is not running (status: $STATUS). Check logs or wait for recovery."
  exit 1
fi

# Connect based on module
echo "✅ '$CONTAINER' is running. Connecting to $MODULE..."

case "$MODULE" in
  postgres)
    docker exec -it "$CONTAINER" psql -U admin -d gptxdb
    ;;
  mysql)
    docker exec -it "$CONTAINER" mysql -u root -prootpass gptxdb
    ;;
  redis)
    docker exec -it "$CONTAINER" redis-cli
    ;;
  mongo)
    docker exec -it "$CONTAINER" mongosh gptxdb
    ;;
esac
