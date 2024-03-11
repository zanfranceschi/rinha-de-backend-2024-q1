#!/bin/bash

# URLs
transactionUrl1="http://localhost:8081/clientes/0/transacoes"
extratoUrl1="http://localhost:8081/clientes/0/extrato"
transactionUrl2="http://localhost:8082/clientes/0/transacoes"
extratoUrl2="http://localhost:8082/clientes/0/extrato"

# Headers
contentType="Content-Type: application/json"

# Initialize counter
counter=0
batchSize=10  # Control the concurrency level

# Debug message
echo "Starting warmup..."

# Start time
start=$SECONDS

# Loop for approximately 10 seconds
while [ $(($SECONDS - $start)) -lt 10 ]; do
    activeJobs=$(jobs -p | wc -l)
    if [ "$activeJobs" -lt "$batchSize" ]; then
        # Increment counter
        ((counter++))
        
        # Alternating transaction type for each iteration
        transactionType=$([ $(($counter % 2)) -eq 0 ] && echo "c" || echo "d")

        payload="{\"valor\": 1, \"tipo\": \"$transactionType\", \"descricao\": \"warmup\"}"

        # Execute curl commands in parallel & silently
        curl -s -X POST -H "$contentType" -d "$payload" "$transactionUrl1" --max-time 1 > /dev/null 2>&1 &
        curl -s -X POST -H "$contentType" -d "$payload" "$transactionUrl2" --max-time 1 > /dev/null 2>&1 &
        curl -s -X GET "$extratoUrl1" --max-time 1 > /dev/null 2>&1 &
        curl -s -X GET "$extratoUrl2" --max-time 1 > /dev/null 2>&1 &

        if [ $(($counter % 100)) -eq 0 ]; then
            echo "Executed $counter requests..."
        fi
    fi
done

wait # Wait for all background jobs to finish

echo "Warmup completed. Total requests: $counter"
