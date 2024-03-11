# Rinha de Backend 2024 - Q1

```
 ____  _       _                 _        ____             _                  _  
|  _ \(_)_ __ | |__   __ _    __| | ___  | __ )  __ _  ___| | _____ _ __   __| | 
| |_) | | '_ \| '_ \ / _` |  / _` |/ _ \ |  _ \ / _` |/ __| |/ / _ \ '_ \ / _` |
|  _ <| | | | | | | | (_| | | (_| |  __/ | |_) | (_| | (__|   <  __/ | | | (_| | 
|_| \_\_|_| |_|_| |_|\__,_|  \__,_|\___| |____/ \__,_|\___|_|\_\___|_| |_|\__,_| 
                                           
```

## Tecnológias

- Linguagem: **Golang**
- Banco de Dados: **PostgreSQL**
- Load Balancer: **nginx**
- Repositório: [dksedlak/rinha-de-backend-2024-q1](https://github.com/dksedlak/rinha-de-backend-2024-q1)

## Solução

A minha abordagem para a solução proposta centra-se na eficiência e simplicidade ao utilizar uma única tabela, onde cada cliente é representado por apenas uma linha. A inovação reside na decisão de armazenar as últimas 10 transações de cada cliente em uma coluna do tipo JSON.

Esta estratégia foi projetada para otimizar o tempo de leitura e escrita, mantendo uma complexidade constante O(k), onde "k" representa uma constante relacionada à eficiência do processo. Evitei a criação de índices e a ordenação de árvores durante a inserção, o que contribui para um desempenho mais eficiente, especialmente em operações de grande volume.

```SQL
CREATE TABLE IF NOT EXISTS accounts(
    id INTEGER NOT NULL,
    credit_limit BIGINT NOT NULL,
    balance BIGINT NOT NULL,
    last_transactions JSON[] NOT NULL,
    CONSTRAINT pk_balance PRIMARY KEY(id),
    CONSTRAINT check_balance_limit CHECK (credit_limit + balance >= 0)
);
```

Diferentemente de alguns bancos de dados, como o MySQL, onde transações com o nível de isolamento *READ UNCOMMITTED* podem resultar em leituras inconsistentes, essa problema não ocorre no **PostgreSQL**. A escolha desse banco de dados destaca-se pela sua habilidade em preservar a integridade dos dados, mesmo em circunstâncias em que outros sistemas poderiam permitir leituras inconsistentes **(dirty reads)**.

| Isolation Level     | Dirty Read                      | Nonrepeatable Read              | Phantom Read                    | Serialization Anomaly          |
|----------------------|---------------------------------|----------------------------------|---------------------------------|---------------------------------|
| Read uncommitted     | Not possible (including PG)     | Possible                         | Possible                        | Possible                        |
| Read committed       | Not possible                    | Possible                         | Possible                        | Possible                        |
| Repeatable read      | Not possible                    | Not possible                     | Not possible (including PG)     | Possible                        |
| Serializable         | Not possible                    | Not possible                     | Not possible                    | Not possible                    |

---

### Resumindo:
>Valeu pelo desafio! Foi massa pensar numa solução eficiente. Tive umas boas horas de bate papo com os meus amigos sobre isso. Ansioso por mais desafios e para poder ter mais trocas de ideias. 

Até a próxima!

## Contato
- **LinkedIn:** [Deryk Sedlak](https://www.linkedin.com/in/deryksedlak/)