# Participação na Rinha de Backend, Segunda Edição: 2024/Q1 - Controle de Concorrência

<img src="https://upload.wikimedia.org/wikipedia/commons/c/c5/Nginx_logo.svg" alt="logo nginx" width="200" height="auto">
<br /><br />
<img src="https://hermes.dio.me/articles/cover/a722bd8a-4f4b-4327-b4df-2608448bb4b1.jpg" alt="logo Quarkus" width="200" height="auto">
<br /><br />
<img src="https://upload.wikimedia.org/wikipedia/commons/2/29/Postgresql_elephant.svg" alt="logo postgres" width="200" height="auto">

<br />

# Bônus

### API de Checagem de Saldo

Endpoint de Checagem de saldo dos clientes: [http://localhost:9999/q/swagger-ui/](http://localhost:9999/q/swagger-ui/)

curl http://localhost:9999/clientes/checa-saldo | jq

Disponível na view: (v_checa_saldo_cliente)

<br />

---

## Critérios de Divisão de Recursos (somente modo native)

- **API**: X 2
  - CPU: 0.2
  - Memória: 100MB

- **PostgreSQL**:
  - CPU: 0.8
  - Memória: 300MB

- **Nginx**:
  - CPU: 0.2
  - Memória: 50MB

---

## Reinaldo Santana

Submissão realizada com os seguintes componentes:

- **Nginx**: Utilizado como balanceador de carga.
- **PostgreSQL**: Utilizado como banco de dados.
- **Quarkus**: Utilizado para a API.

Link para o repositório da API: [rinha-de-backend-2024-q1-poc](https://github.com/zsantana/rinha-de-backend-2024-java-q1)
