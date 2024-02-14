until cqlsh localhost -f /tmp/schema.cql; do
  echo "cqlsh: Cassandra is unavailable to initialize - will retry later"
  sleep 5
done &

exec /docker-entrypoint.sh "$@"