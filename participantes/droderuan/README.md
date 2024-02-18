![8g6e2x](https://github.com/droderuan/node-rinha-backend-2024q1/assets/43659888/58908935-3f71-4a74-957d-e21767536894)

# Node.Js with express and MySQL

Minha submissão ao desafio Rinha de Backend 2024Q1 da comunidade!

Foi usado:

- Node.Js v20.11
- Express
- ~~MySQL DB and mysql2 como conector~~
- PostgreSQL 16 and pg como conector
- NGINX como load balance gateway

[![linkedin](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/ruan-ferreira-0901/)

### Migração de MySQL 8 para PostgreSQL 16

Eu ainda não estava satisfeito com o resultado dos testes e já havia descartado que o gargalo estaria na API. Percebi que diversos (se não todos) os participantes usam o PostgreSQL e imaginei que a má performance fosse o banco. Houve uma melhora **absurda**, tanto do tempo de resposta, quanto da utilização de recursos no container.

Ainda não estou satisfeito, pois gostaria de investigar mais para entender o por que de uma melhora grotesca (mais de 70%) entre um banco e outro. MySQL, sendo um dos bancos mais usados do mundo, deve ter como chegar a uma performance parecida com a do PostgreSQL, mas não sei como hehe.
