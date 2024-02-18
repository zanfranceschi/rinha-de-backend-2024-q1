# Submissão para Rinha de Backend, Segunda Edição: 2024/Q1 - Controle de Concorrência


<img src="https://upload.wikimedia.org/wikipedia/commons/c/c5/Nginx_logo.svg" alt="logo nginx" width="300" height="auto">
<br />
<img src="https://upload.wikimedia.org/wikipedia/commons/5/5d/Clojure_logo.svg" alt="logo clojure" width="200" height="auto">
<img src="https://upload.wikimedia.org/wikipedia/commons/2/29/Postgresql_elephant.svg" alt="logo postgres" width="200" height="auto">


## Fábio Naspolini
Submissão feita com:
- `nginx` como load balancer
- `postgres 16` como banco de dados
- `dotnet 8` para API com:
  - Libraries `Dapper.AOT` e `Npgsql`
  - Build Native AOT, isso gera binário nativo (runtime sem máquina virtual .NET, não é JIT)
  - Esta versão utiliza async/await
- [repositório da api](https://github.com/fabionaspolini/rinha-de-backend-2024-q1-csharp)

[@fabionaspolini](https://twitter.com/fabionaspolini) @ twitter
