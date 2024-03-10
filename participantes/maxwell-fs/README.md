# Descrição

Submissão para rinha de backend feita em C com banco de dados próprio em file system.

# Autor

**Maxwell Monteiro**
maxwell.monteiro@gmail.com

# Stack

- bando de dado em C
- NGINX
- api em C (llhttp, jansson)

# Como Executar

**Pré-requisitos:** docker e docker-compose

```console
docker-compose up
```

# Verificação de integridade das transações

- Dump em json de todas as transações de um cliente: http://localhost:9999/clientes/{id}/dump 
- Somatório de todas as transações de um cliente: http://localhost:9999/clientes/{id}/saldo 

# Repositório

https://github.com/maxwellmonteiro/crinha-2024-fs
