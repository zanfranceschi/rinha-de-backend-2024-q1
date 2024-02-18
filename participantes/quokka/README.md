# quokka (by leandronsp)

[quokka](https://github.com/leandronsp/quokka) é uma modesta versão Rust para esta segunda edição da **famosa e distinta** rinha de backend que visa a construção de um web server utilizando sockets e uma thread/connection pool com fila duplamente terminada _just for fun_.

## Stack

* 2x Rust apps
* 1x PostgreSQL
* 1x NGINX

Esta versão contempla uma stack _handmade_ com Rust puro, sem Tokio nem outro runtime ou biblioteca de server, com o intuito de explorar características interessantes no Rust, tais como controle de concorrência e programação em sockets.

## Autor

### Leandro Proença

[quokka](https://github.com/leandronsp/quokka) • [Github](https://github.com/leandronsp) • [Twitter](https://twitter.com/leandronsp) • [DEV](https://dev.to/leandronsp)

## Running

```bash
$ docker compose up -d
```
