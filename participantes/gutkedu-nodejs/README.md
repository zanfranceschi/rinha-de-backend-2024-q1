<h1 align="center">Rinha de Backend - Nodejs- 2024/Q1</h1>

> [!NOTE]  
> **O repositório com o código-fonte está disponível [aqui](https://github.com/gutkedu/rinha_2024q1_nodejs).**

A imagem utilizada para o projeto é a nodejs:21-bullseye-slim. As dependências foram escolhidas com base no menor número possível de dependências (small footprint).

-  [**Fastify**](https://fastify.dev/): Framework web para aplicações javascript com foco em performance;
-  [**Drizzle**](https://orm.drizzle.team): ORM para TypeScript;
-  [**Zod**](https://zod.dev): Validação de dados com TypeScript;
-  [**PostgreSQL**](https://orm.drizzle.team/docs/get-started-postgresql): Banco de dados relacional;
-  [**Vitest**](https://vitest.dev/): Framework de testes, utilizado para realizar testes unitários;

## Instruções

Utilizar o docker compose up, o script de init irá realizar as migrations automaticamente;

```sh
$ docker compose up
```

## Tamanho da imagem (não comprimida)

```bash
❯ docker image ls gutkedu/rinha_2024q1_nodejs:main
REPOSITORY                    TAG       IMAGE ID       CREATED          SIZE
gutkedu/rinha_2024q1_nodejs   main      49eb40fbb697   19 minutes ago   239MB
```

## Autor

- Eduardo Gutkoski — Linkedin: [/in/eduardopgutkoski](https://www.linkedin.com/in/eduardogutkoski/)


