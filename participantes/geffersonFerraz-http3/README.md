# Go today, go tomorrow, go forever

- Aplicação (go): https://github.com/geffersonFerraz/grinha-de-backend-2024-q1-http3

- Load balancer (go): https://github.com/geffersonFerraz/lb-http-2-quic

- Database: Mongo


Rinha <> (http1/1) <> LoadBalancer <> (http/3) <> api <> mongo




## If the console displays any warnings regarding buffer size, execute the following command:

( off ~ sim eu sei, é muito provavel que o teste nem vai rodar, visto que a maioria dos kernels ainda estão vindo sem o tunning no buff da UDP. Mas submeti mesmo assim para ensinamentos ¯\_(ツ)_/¯ )

```
sysctl -w net.core.rmem_max=2500000 
sysctl -w net.core.wmem_max=2500000


source( https://github.com/quic-go/quic-go/wiki/UDP-Buffer-Sizes )
```

