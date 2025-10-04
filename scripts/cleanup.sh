#!/bin/bash

# Connect to Redis and list keys matching a pattern
echo "Scanning for expired keys..."
keys=$(redis-cli --scan --pattern 'cache:*')
echo "Found ${#keys[@]} keys matching pattern 'cache:*'"

for key in $keys; do
  ttl=$(redis-cli TTL "$key")
  
  # If TTL is -2 (expired) or -1 (no expiration), skip
  if [ "$ttl" -gt 0 ] && [ "$ttl" -lt 60 ]; then
    echo "$(date): Deleting $key with TTL $ttl" >> /var/log/redis-cleanup.log
    redis-cli DEL "$key"
  fi
done

echo "Scan completed."

