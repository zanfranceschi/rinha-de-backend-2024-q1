docker compose down
docker rm $(docker ps --filter status=exited -q)
docker volume rm $(docker volume ls -q)
docker rmi $(docker images -f  -q)
docker image rm $(docker image ls -f  -q)
docker compose up --build


