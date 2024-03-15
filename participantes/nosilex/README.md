# [Crebito](https://github.com/nosilex/crebito) - Hexagonal Architecture in GO

Aplicação desenvolvida em Go, sem uso de framework, com arquitetura hexagonal (Ports and Adapters) e como banco de dados o MariaDB.

## Stack

- GO (`1.22` frameworkless,  with routing enhancements ⚡️)
- MariaDB
- Nginx

## Restrições

A distribuição de recursos para esse projeto foi a seguinte:

| Service       | Memory | CPU unit |
|---------------|-------:|---------:|
| API-1         |   30MB |      0.2 |
| API-2         |   30MB |      0.2 |
| Load Balancer |   20MB |      0.1 |
| Database      |  210MB |      0.7 |
| **Total**     |  290MB |      1.2 |

## Repositório

- [nosilex/crebito](https://github.com/nosilex/crebito)

## Autor

### Élison Gomes

- Twitter: [@nosilex](https://twitter.com/nosilex)
- Blog: [nosilex.com](https://www.nosilex.com/)