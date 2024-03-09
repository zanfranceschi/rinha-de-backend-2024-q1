
# Rinha de backend 2024 q1 

## Stack utilizada
- **Java 17 nativo**
- **Quarkus 3.7.4** clássico (não reativo)
- **nginx** como load balancer
- **PostgreSQL**
- **Panache/Hibernate** com pessimistic locking
- **Jackson** para serializar/deserializar os JSON dos endpoints REST
- **Podman** para construir os containers com a imagem nativa do quarkus
- http://quay.io para publicar as imagens


## Repositório

- https://www.github.com/marciocg/rinhaquarkus


## Instalação

Instale o projeto com

```bash
  docker compose up
```
ou
```bash
  podman-compose up
```
## Resultados do gatling
![gatling](https://github.com/marciocg/rinhaquarkus/blob/main/resultado_gatling.png)

## 🔗 Entre em contato!
[![linkedin](https://img.shields.io/badge/linkedin-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](hhttps://www.linkedin.com/in/m%C3%A1rcio-concei%C3%A7%C3%A3o-goulart-79b492275/)
[![twitter](https://img.shields.io/badge/twitter-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white)](https://twitter.com/marciocg_)
[![github](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://www.github.com/marciocg)
