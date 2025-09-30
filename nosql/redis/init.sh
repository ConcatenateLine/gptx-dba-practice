#!/bin/bash

redis-cli -h localhost <<EOF
SET user:1:name "jc"
HSET product:1 name "Laptop" price "1299.99"
EXPIRE user:1:name 3600
EOF
