IMAGE_NAME = "a-go-rinha"
DOCKER_USER = "nicolasmmb"


build-and-submit:
	@docker buildx build --no-cache --platform linux/amd64 -t $(DOCKER_USER)/$(IMAGE_NAME):latest . --push

build-run:
	@cd app && go build -o bin/server -ldflags="-s -w" ./cmd/main.go
	@cd app && ./bin/server


composer-start:
	@docker-compose -f "docker-compose.yml" up -d --build --force-recreate --remove-orphans

composer-stop:
	@docker-compose -f "docker-compose.yml" down --remove-orphans

composer-restart: composer-stop composer-start

rodar-carga: composer-stop composer-start
	@./test/executar-teste-local.sh

resetar-db:
	@docker-compose  -f "docker-compose.yml" down db
	@docker-compose  -f "docker-compose.yml" up -d --build db --force-recreate --remove-orphans