IMAGE_NAME = "a-go-rinha"
DOCKER_USER = "nicolasmmb"


build-and-submit:
	@docker buildx build --platform linux/amd64 -t $(DOCKER_USER)/$(IMAGE_NAME):latest . --push
	@docker buildx build --platform linux/arm64 -t $(DOCKER_USER)/$(IMAGE_NAME):latest-arm . --push

build-run:
	@cd app && go build -o bin/server -ldflags="-s -w" ./main.go
	@cd app && ./bin/server


composer-start:
	@docker-compose -f "docker-composer.yaml" up -d --build --force-recreate --remove-orphans

composer-stop:
	@docker-compose -f "docker-composer.yaml" down --remove-orphans

composer-restart: composer-stop composer-start