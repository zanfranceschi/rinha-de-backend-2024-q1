docker rm $(docker ps --filter status=exited -q)
docker volume rm $(docker volume ls -q)