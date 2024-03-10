# Submissao - Rinha Backend - .NET 8 w/ Native AOT.

Made by: [Braya Ortega](https://www.linkedin.com/in/brenonortega/)

API para a rinha de backend 2024 - Quarter 1 feita em .NET 8 usando a nova feature de deployment com compilacao Ahead-Of-Time, gerando um binario nativo com tamanho e maior otimizacao dos recursos do container.

## Link do Repositorio
https://github.com/BrenonOrtega/rinha-backend-q1-2024-dotnet

## Arquitetura da Solucao

A arquitetura da API eh bem simples.

                    Load Balancer
                   /             \
    Database <--> webapi1 - - - webapi2 <--> Message Broker 
                    \          /             
                       Cache        

## Descricao

A webapi faz a leitura do database e inicializa o cache gerando o snapshot das contas com seu estado atual.
A partir dai toda leitura eh feita em cima do cache que mantem para o extrato as ultimas 10 transacoes que ocorrem na conta.
Toda nova transacao eh adicionada ao extrato e o cache eh atualizado com o novo saldo da conta baseado nessa transacao.
Em paralelo uma mensagem eh publicada ao message broker que distribui as mensagens nos workers que salvam as transacoes em batch no banco de dados.

As instancias da WebAPI, Cache e o message broker tem mais recursos que o necessario para rodar mas distribui para alocar todos os recursos disponiveis para a rinha, assim garantindo folga para a execucao da API.

## Tecnologias utilizadas

- .NET 8 
- Native AOT Compilation
- Redis - Sorted Sets
- NATS
- PostgreSQL
- Channels
- Threads
- Background services

# Known Issues

- 1 Validacao de saldo falha no inicio do teste de carga, sempre no mesmo instante, infelizmente no periodo de submeter a solucao nao tive tempo de instrumentar o codigo para fazer o debug de por qual motivo isso pasa. [Palpite pessoal] O fato disso ocorrer quer dizer que pode ocorrer algum problema de sincronizacao logo no inicio que se estabiliza apos transacoes iniciais. Carece de mais analises.
att: A issue esta ocorrendo com diversas atualizacoes concorrentes disparadas no mesmo segundo, implementar o uso do algoritmo de lock distribuido Redlock seria um possivel fix para isso, porem nao sera feito por questao de tempo.