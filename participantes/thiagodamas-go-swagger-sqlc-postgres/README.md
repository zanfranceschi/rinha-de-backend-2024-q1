# rinha2024-q1-go-swagger-sqlc-postgres

O propósito deste protótipo é testar 2 frameworks que eu já tinha experiência, mas não juntos:
- go-swagger ([https://github.com/go-swagger/go-swagger](https://github.com/go-swagger/go-swagger))
- sqlc ([https://github.com/sqlc-dev/sqlc](https://github.com/sqlc-dev/sqlc))

Ainda, para trabalhar na parte de concorrência no banco de dados temos 2 possíveis soluções:
- *explicit locking*
- *advisory locking*

Escolhi a primeira, brincando ainda em fazer um único *statement* (com cláusulas ```WITH``` e ```FOR UPDATE```), sem a utilização de funções no banco.

Como a biblioteca para acesso ao PostgreSQL tem suporte a *prepared statements*, apesar da query ter ficado grande, ela já está preparada para execução no banco.

~~Estou ansioso para verificar a performance. Não fiz tuning de CPU nem memória no docker-compose, ainda tem espaço para mexer.~~

Fiz tuning primeiramente utiliando o PGO (profiling), e depois ajustando a distribuição de CPU entre os serviços, sempre olhando o resultado o *docket stats* durante o processo. O resultado ficou assim:

<img src="https://i.imgur.com/xkRWhW8.png" width="100%">

Repositório com o código fonte:
[https://github.com/thiagodamas/rinha2024-q1-go-swagger-sqlc-postgres](https://github.com/thiagodamas/rinha2024-q1-go-swagger-sqlc-postgres)