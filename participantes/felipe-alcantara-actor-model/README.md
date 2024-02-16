# Submissão para Rinha de Backend, Segunda Edição: 2024/Q1 - Controle de Concorrência

## Felipe Ribeiro de Alcântara (feat. Eduardo Serafini Munhoz)
## Submissão feita com:
### - `Actor model` Todo controle de concorrência é feito a nível de processo da aplicação usando uma implementação própia do modelo de concorrência **actor model** [Vaughn Vernon](https://www.youtube.com/watch?v=KtRLIzG5c54)
### - `Event sourcing "like"` Implementação próxima do que seria um event sourcing para controle de estado do actor (ex para cálculo do saldo final do cliente)
### - `Snapshoting` Implementação própria para aumentar o desempenho dos rebuilds
### - `Load balancer` Implementação própia com algoritmo simples de distribuição para atuar como uma espécie de "consistent hashing"
### - `mongodb` escolha arbitrária, pois como nessa implementação o controle de concorrência fica a cargo da app, qualquer banco de dados atenderia
### - `golang` para api e load balancer
### - [repositório da api](https://github.com/feralc/rinha-de-backend-2024)

## [@felipe-ribeiro-de-alcantara](https://www.linkedin.com/in/felipe-ribeiro-de-alcantara/) @ Linkedin