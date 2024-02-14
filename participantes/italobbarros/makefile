# Makefile

# Alvo padrão (executado ao chamar apenas 'make')
all: up test

build-test: build up test
up-test: up test
# Alvo para construir a imagem Docker
build:
	@echo "Construindo a imagem Docker com a versão $(VERSION)..."
	docker-compose build

# Alvo para iniciar o Docker Compose
up:
	@echo "Iniciando o Docker Compose..."
	docker-compose up -d

# Alvo para executar o script de teste
test:
	@echo "Executando o script de teste..."
	sh test.sh

# Alvo para parar e remover os contêineres Docker
down:
	@echo "Parando e removendo os contêineres Docker..."
	docker-compose down

# Alvo para construir, iniciar e testar
build-test: build up test down

# Alvo para limpar a construção e os contêineres
clean:
	@echo "Limpando a construção e os contêineres Docker..."
	docker-compose down --volumes --remove-orphans
