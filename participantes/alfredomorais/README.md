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
Simulation RinhaBackendCrebitosSimulation completed in 262 seconds
Parsing log file(s)...
Parsing log file(s) done in 0s.
Generating reports...

================================================================================
---- Global Information --------------------------------------------------------
> request count                                      61503 (OK=61500  KO=3     )
> min response time                                      1 (OK=1      KO=4     )
> max response time                                    500 (OK=500    KO=5     )
> mean response time                                     6 (OK=6      KO=5     )
> std deviation                                         18 (OK=18     KO=0     )
> response time 50th percentile                          5 (OK=5      KO=5     )
> response time 75th percentile                          5 (OK=5      KO=5     )
> response time 95th percentile                          7 (OK=7      KO=5     )
> response time 99th percentile                         34 (OK=34     KO=5     )
> mean requests/sec                                234.744 (OK=234.733 KO=0.011 )
---- Response Time Distribution ------------------------------------------------
> t < 800 ms                                         61500 (100%)
> 800 ms <= t < 1200 ms                                  0 (  0%)
> t >= 1200 ms                                           0 (  0%)
> failed                                                 3 (  0%)
---- Errors --------------------------------------------------------------------
> jmesPath(saldo.total).find.is(0), but actually found -2             2 (66.67%)
> jmesPath(saldo.total).find.is(-25), but actually found -9           1 (33.33%)
================================================================================
```

## Contato:

- [Linkedin](https://www.linkedin.com/in/alfredomneto/)
- [Github](https://github.com/alfmorais/)
