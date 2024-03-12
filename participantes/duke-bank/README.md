# Rinha de Backend 2024 Q1: Duke Bank - Explorando paradigmas e I/O não bloqueante com Java 21 e Quarkus! ☕

# Stack
**Plataformas**: Java 21, Quarkus 3 & Vert.x <br>
**Banco de dados**: PostgreSQL <br>
**Load Balancer**: NGINX <br>
**Runtime:** GraalVM Mandrel ([micro-imagem nativa](https://hub.docker.com/layers/fercomunello/rinha-backend-duke-bank-2024q1/latest/images/sha256-d3ab6ecb3a80db5b803ff66b5777869c0c580d1bfe0f0099691b6e262c04451e?context=explore) ~ 32 MB) <br>

# Objetivo
Meu principal objetivo nesta edição da rinha foi explorar conceitos de programação reativa e paradigmas de programação introduzidos na última versão do Java como DOP e paradigmas já consolidados como OOP & FP, assim construí um projeto com mais itens além dos que foram pedidos pela Rinha de Backend, pensei um pouco fora da caixa para deixar o projeto o mais legal e intuitivo possível. E claro, não pode faltar os shell scripts interativos e várias linhas de testes com PL/pgSQL como de praxe! :) 

# Aprendizados
"Reactive Programming is kinda bad, like it's bad but it's tolerable." - Gavin King, criador do Hibernate.

Não gastei muito tempo dividindo os recursos da melhor forma possível, mas um fato curioso que notei é que com I/O não bloqueante acabou valendo mais a pena liberar apenas **2 conexões** com o PostgreSQL, uma para cada event-loop. Talvez o objetivo maior da programação reativa seja atender o maior número de requisições sem "abrir o bico", como muitos dizem, e com um consumo baixo de recursos, diferentemente de estratégias tradicionais como pool de worker threads e threads virtuais que costumam usar muito mais memória e/ou CPU mas que podem entregar uma performance melhor, aqui me refiro a tempo de execução em ms e não ao throughput.

Então uma lição importante é a seguinte: Async/NIO não significa performance mas sim **eficiência**, entregar o resultado na medida do possível mas com muito **menos consumo de recursos**, um exemplo disso é na parte de consulta do extrato, em vez de rodar a consulta do saldo + a consulta das últimas 10 transações de forma sequencial, podemos combinar ambas operações em uma só usando [pipelining](https://quarkus.io/guides/reactive-sql-clients#pipelining) a nível de conexão e em paralelo sem alocar outra thread.

E aqui vai mais uma lição importante para o debate de Imperative Programming vs Reactive Programming: **"Measure don't guess"**, é isso! xD

Uma boa ideia para fins de comparação seria replicar o schema do banco de dados deste projeto usando um pool de worker threads e implementando uma camada de comunicação direta com o driver JDBC do Postgres, eu explico essa abordagem em detalhes em um [vídeo](https://www.youtube.com/watch?v=3eZeS31dnCg) no meu canal:

<a href="https://www.youtube.com/watch?v=3eZeS31dnCg" alt="Learn how to improve JDBC API code on Quarkus & Jakarta EE!">
<img src="https://img.youtube.com/vi/3eZeS31dnCg/mqdefault.jpg"></a>

# Redes
- Youtube: [@ferjava](https://www.youtube.com/@ferjava)
- Github: [@fercomunello](https://github.com/fercomunello)
- Twitter: [@fercomunello](https://twitter.com/fercomunello)
- Site: [fercomunello.github.io](https://fercomunello.github.io/br)

**Repositório**: [fercomunello/duke-bank-rb-2024](https://github.com/fercomunello/duke-bank-rb-2024/)

# Overview
Eu tinha iniciado com uma stored function (procedure), mas optei por substituir ela por uma query que realiza todas as operações no mesmo statement, ou seja, lock pessimista, UPDATE e INSERT em uma roundtrip (aka "Go Horse" 🤔 haha). 

![Screenshot from 2024-03-11 01-33-32](https://github.com/fercomunello/rinha-de-backend-2024-q1/assets/66500627/c027e042-5830-4714-b77b-2495ae096d1e)
![Screenshot from 2024-03-11 01-34-41](https://github.com/fercomunello/rinha-de-backend-2024-q1/assets/66500627/26d25690-c1f9-42b5-9f0b-7c429ce28be8)

# Gatling
![photo_2024-03-11_00-51-37](https://github.com/fercomunello/rinha-de-backend-2024-q1/assets/66500627/2352caf8-f567-47cc-b5d1-1fdeabe05448)

# Estrutura do projeto
```

$$$$$$$\            $$\                       $$$$$$$\                      $$\       
$$  __$$\           $$ |                      $$  __$$\                     $$ |      
$$ |  $$ |$$\   $$\ $$ |  $$\  $$$$$$\        $$ |  $$ | $$$$$$\  $$$$$$$\  $$ |  $$\
$$ |  $$ |$$ |  $$ |$$ | $$  |$$  __$$\       $$$$$$$\ | \____$$\ $$  __$$\ $$ | $$  |
$$ |  $$ |$$ |  $$ |$$$$$$  / $$$$$$$$ |      $$  __$$\  $$$$$$$ |$$ |  $$ |$$$$$$  /
$$ |  $$ |$$ |  $$ |$$  _$$<  $$   ____|      $$ |  $$ |$$  __$$ |$$ |  $$ |$$  _$$<  
$$$$$$$  |\$$$$$$  |$$ | \$$\ \$$$$$$$\       $$$$$$$  |\$$$$$$$ |$$ |  $$ |$$ | \$$\
\_______/  \______/ \__|  \__| \_______|      \_______/  \_______|\__|  \__|\__|  \__|

duke-bank
 - postgres-local.sh -> script "hit and run" para recriar o schema do postgres na hora
├── src
│   ├── main
│   │   ├── java
│   │   │   └── com
│   │   │       └── github
│   │   │           └── bank
│   │   │               └── duke
│   │   │                   ├── Bank.java
│   │   │                   ├── BankSchema.java
│   │   │                   ├── BankStartup.java
│   │   │                   ├── BankWarmup.java
│   │   │                   ├── business -> Regras da Rinha no padrão BCE
│   │   │                   │   ├── boundary
│   │   │                   │   │   ├── BankStatementRoute.java
│   │   │                   │   │   └── BankTransactionRoute.java
│   │   │                   │   ├── control
│   │   │                   │   │   ├── BankProtocol.java
│   │   │                   │   │   ├── BankStatement.java
│   │   │                   │   │   ├── BankTransaction.java
│   │   │                   │   │   ├── BankTransactionProcedure.java
│   │   │                   │   │   └── BankTransactionResult.java
│   │   │                   │   └── entity
│   │   │                   │       ├── BankAccount.java
│   │   │                   │       ├── BankTransactionState.java
│   │   │                   │       └── TransactionType.java
│   │   │                   ├── Logger.java
│   │   │                   └── vertx -> Classes "wrappers" acopladas com o Vert.x + Mutiny,
|   |   |                          para abstrair as implementações técnicas.
│   │   │                       ├── sql -> Abstração bem simples para o PgPool, aos moldes da rinha (nada além do necessário).
│   │   │                       │   ├── Database.java
│   │   │                       │   ├── Dialect.java
│   │   │                       │   ├── function
│   │   │                       │   │   ├── RowMapper.java
│   │   │                       │   │   └── UniTask.java
│   │   │                       │   ├── SqlConnection.java
│   │   │                       │   ├── StoredFunction.java
│   │   │                       │   └── vendor
│   │   │                       │       └── Postgres.java
│   │   │                       └── web -> Uma api/lib OOP-driven para validações e i18n aos moldes da rinha
│   │   │                           ├── CachedEntry.java
│   │   │                           ├── HttpStatus.java
│   │   │                           ├── i18n
│   │   │                           │   ├── MessageBundle.java
│   │   │                           │   ├── Messages.java
│   │   │                           │   └── ValidationMessages.java
│   │   │                           ├── Media.java
│   │   │                           ├── Response.java
│   │   │                           ├── RoutingExchange.java
│   │   │                           └── validation
│   │   │                               ├── constraints
│   │   │                               │   ├── NotNull.java
│   │   │                               │   ├── PositiveInt.java
│   │   │                               │   └── TextLengthMax.java
│   │   │                               ├── failure
│   │   │                               │   ├── Constraint.java
│   │   │                               │   ├── InvalidEntry.java
│   │   │                               │   ├── ValidationError.java
│   │   │                               │   └── ValidationException.java
│   │   │                               ├── Validation.java
│   │   │                               ├── Validations.java
│   │   │                               ├── ValidationState.java
│   │   │                               └── ValidationStatus.java
│   │   └── resources
│   │       ├── application.properties
│   │       ├── i18n
│   │       │   ├── messages_en_US.properties
│   │       │   ├── messages_pt_BR.properties
│   │       │   ├── validations_en_US.properties
│   │       │   └── validations_pt_BR.properties
│   │       └── postgresql
│   │           ├── bank-schema.sql -> schema da rinha
│   │           ├── scripts
│   │           │   ├── bank-schema-dev.sql
│   │           │   └── bank-statements-test.sql  -> a primeira consulta que fiz para o extrato bancário
│   │           └── tests
│   │               └── bank-transaction-test.sql -> sim, adicionei testes integrados dentro do banco de dados O.o
│   └── test
│       ├── java
│       │   └── com
│       │       └── github
│       │           └── bank
│       │               └── duke
│       │                   ├── business
│       │                   │   ├── BankTest.java
│       │                   │   ├── boundary
│       │                   │   │   ├── BankStatementRouteTest.java -> teste de integração da rota de extratos bancários
│       │                   │   │   └── BankTransactionRouteTest.java -> teste de integração da rota de transações
│       │                   │   ├── control
│       │                   │   │   └── BankTransactionTest.java -> teste de integração para o processamento das transações
│       │                   │   └── entity
│       │                   │       └── BankAccountTest.java -> teste unitário para verificar o estado da conta bancária
```
