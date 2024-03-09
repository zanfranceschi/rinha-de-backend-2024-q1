# Rinha de Backend 2024 - Rust artesanal

Stack: Rust, Rust e Rust

Da app, ao load balancer, ao banco de dados, tudo foi implementado artesanalmente em Rust em lives no Youtube.

Pontos importantes:
- Blazing fast(tm)
- O nome do banco de dados é espora-db, tem como ser mais maneiro?
- Consistência máxima! Se a API responder que a transação foi inserida, ela está 100% persistida em disco. Não há cache que gere consistência eventual.

# Arquitetura

Essa submissão utiliza o banco de dados espora-db embedado em cada uma das instâncias das apps. Um volume é compartilhado entre as duas instâncuias
e a sincronia de dados é feita utilizando [locks no arquivo compartilhado](https://man.freebsd.org/cgi/man.cgi?query=flock&sektion=2).
Cada uma das 5 contas tem seu próprio arquivo, então cada lock é individual por conta.

```mermaid
flowchart TD
    LB[Load balancer\nrinha-load-balancer-tcp]
    LB -.-> API1(API - instância 01\nrinha-espora-embedded)
    LB -.-> API2(API - instância 02\nrinha-espora-embedded)
    subgraph espora-db[volume compartilhado]
        direction TB
        account-1.espora
        account-2.espora
        account-3.espora
        account-4.espora
        account-5.espora
    end
    API1 -.-> espora-db
    API2 -.-> espora-db
```

Os componentes estão com os nomes que poderá ser encontrado nos diretórios do [repositório no Github](https://github.com/reu/rinha-2024)
- rinha-load-balancer-tcp: um load balancer na camada 4 que implementa round robin por conexão
- rinha-espora-embedded: implementa consistência e persistência dos dados
- espora-db: banco de dados embedado no em cada um dos processos do rinha-espora-embedded

# Lives do Youtube

A implementação de cada um dos serviços foi feita em diversas lives (recheadas de vergonha alheia) disponíveis no Youtube:

[![Dia 01 - Implementação da API](https://i.ytimg.com/vi/sCWggMruZXg/hqdefault.jpg?sqp=-oaymwEcCNACELwBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLDp2kjQqqugq0Dg_RQ7HP1qPmCkUQ)](https://www.youtube.com/watch?v=wbaw3bBMBag)
- [Dia 01 - Implementação da API](https://www.youtube.com/watch?v=wbaw3bBMBag)
- [Dia 02 - Load balancer](https://www.youtube.com/watch?v=hbUuXZMPggM)
- [Dia 03 - Banco de dados](https://www.youtube.com/watch?v=vI5vdnPvoE4)
- [Dia 04 - Integrando tudo](https://www.youtube.com/watch?v=sCWggMruZXg)

# Autor

- Repositório: [reu/rinha-2024](https://github.com/reu/rinha-2024)
- Github: [reu](https://github.com/reu)
- Twitter: [@rdrnavarro](https://twitter.com/rdrnavarro)
- Youtube: [@navarro-fn](https://www.youtube.com/channel/UCvZ7yS8QJBdSmNWzFSKKAOA)
