# Submissão para Rinha de Backend, Segunda Edição: 2024/Q1 - Controle de Concorrência

## Felipe R. Alcântara (featr. Eduardo Serafini)

### *Usando **menos recursos** do que o estipulado pela rinha!!

Estamos utilizando apenas **240MB** de memória economizando **310MB** dos 550MB que poderíamos ter usado!

## Submissão feita com:
### - `Actor model` 
Implementamos o controle de concorrência em nível de processo da aplicação, seguindo uma abordagem baseada no **modelo de ator**. Inspirado nas ideias de **Vaughn Vernon**, este modelo oferece uma estrutura poderosa para lidar com a concorrência de forma eficiente e escalável. Para entender melhor, recomendo este [vídeo](https://www.youtube.com/watch?v=KtRLIzG5c54).

### - `Event sourcing "like"` 
Essa implementação se aproxima do conceito de *event sourcing*, permitindo um controle mais preciso e granular do estado dos actors. Especificamente útil para cálculos complexos, como o saldo final do cliente, este método garante uma visão abrangente do histórico de eventos que moldam o estado atual, no caso cada **Transaction** é como um evento na stream de um actor. Como só precisamos manter as ultimas 10 transações no extrato, parece fazer muito sentido manter esse histório em memória.

### - `Snapshoting` 
Para otimizar o desempenho dos rebuilds, implementamos uma técnica de *snapshoting*. Isso nos permite capturar o estado dos actors em momentos específicos, reduzindo a carga de processamento necessária para reconstruir o estado completo em caso de restart dos servidores da API.

### - `Load balancer com backends gRPC` 
Optamos por uma implementação personalizada de um load balancer http que faz proxy para os backends rodando em gRPC. Nele implementamos um algoritmo extremamente simples de **consistent hashing**, porém eficaz para os objetivos da rinha, onde garantimos uma distribuição equilibrada do tráfego entre os nós da aplicação. Esse processo distribui os clientes, direcionando a requisição de um cliente específico sempre para o mesmo nó, o que elimina a necessidade de cache externo, já que o estado de um actor é mantido sempre em memória, proporcionando um acesso rápido e eficiente aos dados. Assim, não só garantimos uma distribuição uniforme do tráfego, mas também otimizamos o desempenho do sistema.

### - `MongoDB + non blocking I/O` 
Foi uma escolha arbitrária. Como o controle de concorrência é tratado pela aplicação, qualquer banco de dados poderia ser utilizado (até mesmo um arquivo, ou SQLite). Mas para atender aos requisitos da rinha, decidimos ter um server de banco de dados mesmo.

### - `Go + gRPC` 
Escolhemos Go para desenvolver tanto a API quanto o Load Balancer devido à sua eficiência, simplicidade e excelente suporte para concorrência. A linguagem Go oferece uma combinação única de desempenho de execução, facilidade de desenvolvimento e robustez, tornando-a ideal para sistemas distribuídos e de alta concorrência e no ifm se encaixou muito bem com o design do nosso actor model.

### [Repositório da API](https://github.com/feralc/rinha-de-backend-2024)

## [\@felipe-ribeiro-de-alcantara](https://www.linkedin.com/in/felipe-ribeiro-de-alcantara/) @ Linkedin
