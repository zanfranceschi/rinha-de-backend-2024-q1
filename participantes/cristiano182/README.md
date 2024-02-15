# RINHA BACKEND 2024 Q1 - NODEJS

### Cristiano Oliveira


Repositório: [https://github.com/cristiano182/rinha-backend-2024-q1](https://github.com/cristiano182/rinha-backend-2024-q1)




#### RUN APPLICATION

load balance listen on localhost:9999

```
$ docker compose up
```

- run performance test
```
sh stress.sh
```


#### ENVIRONMENTS (required)
```
PORT=3000
POSTGRES_URL=postgres://admin:123@localhost:5432/rinha
IS_PRIMARY_NODE=true
UV_THREADPOOL_SIZE=2
POSTGRES_MAX_POOL=100
POSTGRES_MIN_POOL=30
```


##### STACK
- NodeJS (runtime)
- Hyper-Express (http server)
- PostgresSQL (database)
- NGINX (load balance)
- AJV (schema validator)
- Inversify (DI)


##### CONTACT
EMAIL: cristianogb182@gmail.com


####
linux/amd64,linux/arm64