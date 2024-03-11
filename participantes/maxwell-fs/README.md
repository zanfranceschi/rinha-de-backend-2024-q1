# Descrição

Submissão para rinha de backend feita em C com gravação de arquivos em disco.

# Autor

**Maxwell Monteiro**
maxwell.monteiro@gmail.com

# Stack

- File System
- NGINX
- C (llhttp, jansson)

# Como Executar

**Pré-requisitos:** docker e docker-compose

```console
docker-compose up
```

# Teste de Integridade das transações

- Dump de todas as transações de um cliente: http://localhost:9999/clientes/{id}/dump 
- Saldo de todas as transações de um cliente: http://localhost:9999/clientes/{id}/saldo

# Repositório

https://github.com/maxwellmonteiro/crinha-2024-fs
