# Submissão para Rinha de Backend, Segunda Edição: 2024/Q1 - Controle de Concorrência

<img src="https://upload.wikimedia.org/wikipedia/commons/c/c5/Nginx_logo.svg" alt="logo nginx" width="300" height="auto">
<br/><br/>
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/Nim-logo.png/317px-Nim-logo.png" width="200" height="auto" alt="logo nim">
<br/>
<img src="https://upload.wikimedia.org/wikipedia/commons/2/29/Postgresql_elephant.svg" alt="logo postgres" width="200" height="auto">

## Guaracy Monteiro

Submissão feita com:

- `nginx` como load balancer
- `postgres` como banco de dados
- [Nim](https://nim-lang.org/) para api com as libs `compojure` e `next.jdbc`
  - [mummy](https://github.com/guzba/mummy) para o servidor
  - [waterpark](https://github.com/guzba/waterpark) para pool de conexões com o BD
  - [jsony](https://github.com/treeform/jsony) para serialização/deserialização de JSON
- [repositório da api](https://github.com/guaracy)

[@zanfranceschi](https://twitter.com/guaracybm) @ twitter

## Considerações

- A utilização de **Nim** é para sair um pouco do convencional. Uma linguagem compilada com sintaxe semelhante ao Python.

- A escolha por **Mummy** se deve a facilidade além de ser relativamente rápido. Não se preocupar com  `{.async.}`, `Future[]` e `await` é muito legal para quem não gosta de se preocupar com as [cores das funções](https://journal.stuffwithstuff.com/2015/02/01/what-color-is-your-function/). 

- Da mesma forma, **Waterpark** fornece facilidades para trabalhar com um pool de conexões com um BD (MySQL, PostgreSQL e SQlite).

- O **JSONY**, além de ser mais rápido que a implementação original, oferece diversos recursos adicionais com ganchos para popular valores default e qualquer outra coisa que você imaginar.

## Implementação

Apesar de ter sido fornecido um exemplo, achei que tinha muita tabela para algo que apenas pretendia adicionar ou subtrair valores de uma determinada com e mostrar o saldo. O extrato mostra apenas os últimos 10 lançamentos.

Também retirei todos os procedimentos armazenados no BD. Testar no programa é mais rápido do que enviar para o SGBD, processar e retornar um erro.

Resolvi colocar o saldo juntamente com o limite na tabela de clientes e uma outra tabela para a movimentação (já teria os últimos 10 lançamentos).

Como o ID dos clientes era de 1-5 (e pediram para não colocar 6), executei o teste diretamente no programa. Evita uma leitura desnecessária no banco de dados.

Considero que as regras para a movimentação estão meio confusas. Poderia retornar erro **422**. se a entrada tivesse um débito que fosse deixar o saldo inconsistente (abaixo do limite da conta) e **400** sempre que o JSON tivesse uma valor incorreto.

Ao executar os testes no Docker, provavelmente por restrições da rinha ou desconhecimento **meu** sobre algumas configurações, o programa se comportava melhor com apenas uma conexão (o que não invalida a utilização do waterpark).

## Finalmentes

- O código tem algumas brincadeiras. Não coloquei mais para não aumentar muito o tamanho. Por exemplo, uma configuração para que o programa compilado retornasse, caso o cliente não fosse encontrado, **200** para cancelar a rinha para sempre.

- Para o problema de concorrência no saldo, utilizei `SELECT ... FOR UPDATE` com um `COMMIT` logo após a gravação do saldo para liberar nova leitura da linha. A movimentação e feita logo após, não se preocupando com a concorrência.

- O programa tratou **61503** requisições e todas as respostas foram abaixo de 800ms. Alterando um pouco as configurações (memória e cpu), obtive os seguintes resultados (quanto mais rápido melhor mas, um usuário real não veria muita diferença entre 0,097s e 0,036s):
  
  - sem alterar as configurações, o tempo máximo para resposta foi de **97ms**(0,81%) e 64,2% foram completadas em até **5ms**.
  
  - tirando 20M dos aplicativos e colocando 40M para a base de dados o tempo máximo de resposta caiu para **43ms** (1,62%) e 63,39% foram completadas em até 5ms.
  
  - tirando 0.05 de CPU para os aplicativos e e colocando 0.1CPU na base de dados, o tempo máximo de resposta caiu para **36ms** (0,81%) e o percentual de requisições atendidas em até 5ms foi de 64,21%.

- Em vez de MVC e outras coisas parecidas, como o assunto me lembou bancos e, consequentemente COBOL, resolvi fazer um programa monolítico com DATA DIVISION, PROCEDURE DIVISION, etc.

- `docker-compose build` `docker-compose up` `docker-compose down` 
