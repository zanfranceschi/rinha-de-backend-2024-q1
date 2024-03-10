# curva-de-rio

![curva-de-rio.png](curva-de-rio.png)

Rinha #2 - https://github.com/zanfranceschi/rinha-de-backend-2024-q1

Fonte - https://github.com/boaglio/curva-de-rio 

Já dizia o velho sábio:  _app Java com pouca memória é uma curva de rio_ 

##  Javinha na Rinha de back end 2024 Q1

* Java 21
* Spring Boot 3.1
* MongoDB 7

### v1

* removido Spring Validator e Actuator
* usando Capped Collections (MongoDB) para gravar transacoes
* pouca memória para usar Virtual Threads =( 
* GraalVM com Spring Boot 3.2 tem bug e não funciona =( 
  (erro Could not find class [org.springframework.data.domain.Unpaged)