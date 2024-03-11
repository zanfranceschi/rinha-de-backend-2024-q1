## Gaspar Barancell Junior


## Rinha de Backend 2024

Aplicação desenvolvida em Java compilada para código de máquina com a GraalVM, sem utilizar nenhum framework, apenas as libs de jdbc do postgres e do hikari para pool de conexão com banco de dados.

Inicialmente estava utilizando a lib do gson, depois mudei para a jackson, mas removendo a lib e fazendo o parse manualmente, melhorei a performance.

Utilizei postgres como banco de dados, implementando uma procedure para validação de saldo e limite, bem como inserir a transação.

Para proxy fiz testes com o HAProxy, Envoy e Nginx o qual teve melhor performance.


##### BUILD

mvn -Pnative -Dagent package

docker build -t gasparbarancelli/rinha-2024-java-nativo:latest .


##### Repositorio Oficial

https://github.com/gasparbarancelli/rinha-backend-2024/tree/feature/nativo
https://twitter.com/gasparbjr
https://br.linkedin.com/in/gaspar-barancelli-junior-77681881




