## Rinha de Backend 2024-Q1

<p align="center">
  <img src="docs/stack.png" alt="stack" height="200px" />
</p>

Desenvolvi este desafio utilizando **Node.js** como tecnologia principal. Para implementar o servidor REST HTTP, optei pela biblioteca **Koa.js**, enquanto para a conexão com o banco de dados **PostgreSQL**, escolhi a biblioteca **pg**.

Além disso, foram realizadas configurações tanto no Nginx quanto no PostgreSQL visando aprimorar o desempenho do sistema. Uma estratégia adotada foi utilizar apenas uma tabela no banco de dados, reduzindo assim o número de consultas necessárias.

Para avaliar o desempenho, executei o teste de carga com **Gatling** em uma instância **AWS t2.medium** (2 vCPUs e 4 GB de RAM), respeitando os limites estabelecidos para cada serviço no Docker Compose. Os resultados obtidos foram:

- [x] **75%** das requisições com **2ms** de tempo de resposta.

- [x] **99%** das requisições com **5ms** de tempo de resposta.

---

Repositório: https://github.com/trindadematheus/rinha-backend-2024-q1-nodejs

Contato: https://trindadematheus.com/
