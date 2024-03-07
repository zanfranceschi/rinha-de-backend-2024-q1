# RinhaDeBackend2024Q1

Olá!! Meu nome é Jeferson esse é meu projeto para participar da rinha.

contato: [LinkedIn](https://www.linkedin.com/in/jeferson-baixo-77b00711a/)
[Discord](https://discord.com/users/jefersonbaixo)
[email](jeferson.baixo@gmail.com)

link do projeto: [rinha-de-backend-2024-q1](https://github.com/jefersonbaixo/rinha_de_backend_2024_q1)

# Rodando o projeto

Para rodar o projeto são necessários alguns comandos. Infelizmente não consegui fazer funcionar incluindo os comandos no arquivo do compose :/ (Sou meio novo nesse rolê de backend, rsrs)

`$ docker-compose up -d`

`$ docker exec api01-phoenix sh -c "mix ecto.migrate && mix run priv/repo/seeds.exs"`

`$ ./executar-test-local.sh`

- Caso for rodar os testes novamente é importante apagar a pasta `postgres` dentro do projeto para limpar o banco de dados.

## Stack

- Elixir
- Phoenix
- Postgres
- Nginx

### Boa rinha pra nós :D
