# Rinha de Backend - 2024 Q1

- [Repositório do Projeto](https://github.com/alfmorais/RinhaBackend2024Q1)

## Tecnologias:

- Python 3.11.7
- Starlette 0.37.1
- Postgres 13
- Nginx stable-alpine3.17-slim

## Rodando o Projeto:

```bash
docker compose build --no-cache && docker compose up
```

## Resultado Preliminar:

```bash
================================================================================
---- Global Information --------------------------------------------------------
> request count                                      61503 (OK=59819  KO=1684  )
> min response time                                      0 (OK=2      KO=0     )
> max response time                                   3779 (OK=3779   KO=81    )
> mean response time                                   447 (OK=460    KO=5     )
> std deviation                                        655 (OK=660    KO=12    )
> response time 50th percentile                          7 (OK=7      KO=1     )
> response time 75th percentile                       1018 (OK=1064   KO=1     )
> response time 95th percentile                       1633 (OK=1636   KO=30    )
> response time 99th percentile                       1798 (OK=1801   KO=62    )
> mean requests/sec                                232.966 (OK=226.587 KO=6.379 )
---- Response Time Distribution ------------------------------------------------
> t < 800 ms                                         42663 ( 69%)
> 800 ms <= t < 1200 ms                               2918 (  5%)
> t >= 1200 ms                                       14238 ( 23%)
> failed                                              1684 (  3%)
---- Errors --------------------------------------------------------------------
> j.i.IOException: Premature close                                 1661 (98.63%)
> status.find.in(422), but actually found 400                        20 ( 1.19%)
> jmesPath(saldo.total).find.is(0), but actually found 1              2 ( 0.12%)
> jmesPath(saldo.total).find.is(-25), but actually found 2            1 ( 0.06%)
================================================================================
```

## Contato:

- [Linkedin](https://www.linkedin.com/in/alfredomneto/)
- [Github](https://github.com/alfmorais/)
