

Zebrito trabalha melhor quando ta embriagado

Repo: [Zebrito](http://github.com/isaquealves/zebrito)


# Hipóteses testadas ao longo do caminho:
- Particionamento influenciaria no controle fino de concorrência?
    - Não percebi vantagem, mas em um cenário real, eu faria, sim.
- Será que dentro do mesmo serviço, apenas com uma instancia de lavinmq, fazendo a publicação em fila e o consumo da mensagem mesmo sem poder lidar com isso como fluxo assíncrono?
    - Não deu bom
- A API é só um detalhe. A linguagem de programação tem pouca ou nenhuma influência sobre o funcionamento do negócio em si. Foco no nginx e postgresql e testo flags.
    - Foi um bom exercício


# Flags do postgres testadas e que deram resultado
max_connections

superuser_reserved_connections

unix_socket_directories

shared_buffers

work_mem

maintenance_work_mem

effective_cache_size

wal_buffers

checkpoint_timeout

checkpoint_completion_target

random_page_cost

effective_io_concurrency

autovacuum

log_statement

log_duration

log_lock_waits

log_error_verbosity

log_min_messages

log_min_error_statement

default_transaction_isolation

max_parallel_maintenance_workers

max_parallel_workers

max_worker_processes

max_parallel_workers_per_gather

Pra isso, li muita coisa aqui [Postgreqlco.nf](https://postgresqlco.nf/tuning-guide)


# Stack
- Application
  - Python 3.12.2
    - fastapi
    - pydantic
    - asyncpg
    - uvicorn & gunicorn
- Database
  - PostgreSQL 16.0 - Debian 16.0-1.pgdg120+1

Obrigado!