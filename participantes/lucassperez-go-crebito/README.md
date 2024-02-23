# Submissão para Rinha de Backend, Segunda Edição: 2024/Q1 - Controle de Concorrência

<img src="https://upload.wikimedia.org/wikipedia/commons/c/c5/Nginx_logo.svg" alt="logo nginx" width="300" height="auto" />
<br />
<img src="https://upload.wikimedia.org/wikipedia/commons/0/05/Go_Logo_Blue.svg" alt="logo golang" width="200" height="auto" />
<br />
<img src="https://upload.wikimedia.org/wikipedia/commons/2/29/Postgresql_elephant.svg" alt="logo postgres" width="200" height="auto" />


## Lucas Perez

Submissão feita com:
- **Nginx** como load balancer
- **Go** para api com o driver [`pgx/v4`](https://github.com/jackc/pgx) para interagir com o banco de dados
- **Postgres** como banco de dados
- <a href="https://github.com/lucassperez/go-crebito" target="_blank">Repositório da API</a>

## Contato

[Github](https://github.com/lucassperez)

## Teste Gatling

<img alt="(Imagem) Estatísticas do teste com gatling, 2024/02/19." src="https://github.com/lucassperez/go-crebito/assets/60318892/62f80af7-7f66-4510-85f6-d80c446f5fd7" />

## Comentários

Resolvi participar porque estou querendo aprender mais sobre Go.
<br />
É minha primeira vez fazendo um projetinho na linguagem fora o de algum
tutorial/livro, então também quis explorar coisas como criar e aplicar um
middleware além de tentar criar uma estrutura de diretórios/arquivos/pacotes que
pudesse fazer sentido para organizar a aplicação.
<br />
Minha ideia era usar somente a biblioteca padrão, principalmente com as mudanças
no `serverMux` padrão que vieram com a versão `1.22.0` da linguagem. A única lib
externa que acabei usando mesmo foi o driver pro postgres.
<br />
Obrigado, Leandro Proença, por mostrar a Rinha (:

## Estratégia

Minha ideia foi usar um lock pessimista na tabela `clientes`, usando o sql
`FOR NO KEY UPDATE` quando feito o select para pegar o saldo do cliente.
