
# Rinha de Backend 2024/Q1 - Submit to second edition - Concurrency controls

This project has the main objective to run two services from the same API (in parallel), which will control a lot of HTTP requests (POST and GET) using nginx tool as load balancer.

The request tests have been sent from Gatling script, the API's role needs to respect some rules (for example transactions sequences, return values, number of requests, etc). 

The results you can look in this path \gatling-tests\user-files\results

The project was written in Golang language, Postgresql database and Docker to deploy. 



## Install instructions


```
  $ docker-compose up -d
```



## Links
[github challenge](https://github.com/zanfranceschi/rinha-de-backend-2024-q1)

[github repository](https://github.com/rp83t1/rinha-de-backend-2024-q1)
