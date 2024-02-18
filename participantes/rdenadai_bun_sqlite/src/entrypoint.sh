#!/bin/sh

cd /src

if [ "$START_DB" = "yes" ]; then
    echo "Database not found, creating..."
    rm -rf ./data/rinhabackend.db
    sh -c "cat init.sql | sqlite3 ./data/rinhabackend.db"
fi

bun run index.js