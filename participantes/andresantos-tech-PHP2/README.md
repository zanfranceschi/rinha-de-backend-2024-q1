# Submissão para Rinha de Backend, Segunda Edição: Controle de Concorrência

<img src="https://github.com/andresantos-tech/rinha-de-backend-2024-q1_V2_source/raw/master/images/nginx.svg" alt="logo nginx" width="150" height="auto" align="left" style="margin: 38px 30px 0 0; ">
<img src="https://github.com/andresantos-tech/rinha-de-backend-2024-q1_V2_source/raw/master/images/php.svg" alt="logo PHP" width="150" height="auto" align="left" style="margin: 15px 30px 0 0;" />
<img src="https://github.com/andresantos-tech/rinha-de-backend-2024-q1_V2_source/raw/master/images/postgres.svg" alt="logo postgres" width="100" height="auto" >

<img src="https://github.com/andresantos-tech/rinha-de-backend-2024-q1_V2_source/raw/master/images/RoadRunner.png" alt="logo RoadRunner" width="200" height="auto" style="margin: 21px 30px 0 0;" />
<br>

Nova submissão para testar quatro coisas diferentes [do que tinha feito antes](https://github.com/zanfranceschi/rinha-de-backend-2024-q1/tree/main/participantes/andresantos-tech-PHP):
- Impacto de performance ao remover o web framework [Spiral](https://spiral.dev/) [baseado na submissão do Gianluca Bine (Pr3d4dor)]
- Uso de 5 workers do RoadRunner por API ao invés de 1
- Impacto de performance por mover as regras de validação do saldo para dentro do Postgres [baseado na submissão do @giovannibassi]
- Atualização do PHP 8.2 para 8.3 (o tempo de resposta das validações aumentou um pouco, mas decidi manter assim)

Também tentei fazer um "warmup" da aplicação (simulando X requisições antes do teste começar) mas não rolou. Fica pra próxima rinha :)

## 🚀 Como rodar o projeto
```
docker compose up
```

## 💻 Tecnologias utilizadas
- [`nginx`](https://www.nginx.com/) (load balancer)
- [`postgres`](https://www.postgresql.org/) (banco de dados)
- [`php`](https://www.php.net/) (linguagem)
- [`roadrunner`](https://roadrunner.dev/) (application server)

## 💾 Repositório
- [andresantos-tech / **rinha-de-backend-2024-q1_V2_source**](https://github.com/andresantos-tech/rinha-de-backend-2024-q1_V2_source/)

<hr>

### Desenvolvido por: André Santos
[![twitter/X](https://img.shields.io/badge/Twitter-000000?style=for-the-badge&logo=X&logoColor=white)](https://twitter.com/andresantos_eu)
[![linkedin](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/andresantos-tech/)
[![github](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/andresantos-tech)




