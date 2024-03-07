**<center><i>API em .NET 8 com Native AOT, PostgreSQL e NGINX.</i></center>**

---
**<center><i>Descritivo das soluções.</i></center>**
==============================
Enquanto idealizava o projeto, pensei em colocar um Informix na base pois estava interessado em validar a forma como ele gerencia row level locking por padrão, diferente do MVCC do Postgres, e o efeito que isso teria junto de um código otimizado, assim como validar seu baixo tempo em OLTP. Ao mesmo tempo, estava contemplando um Envoy no load balancer também por aguentar um paralelismo melhor do que o NGINX, ao menos em benchmarks. Mas a rota do "free and open source" falou mais alto e dropei o Informix, eventualmente desisti do envoy ao ver que o nginx não seria gargalo e não teria diferença significativa de performance. Desta forma, mantive a escolha bem vanilla com o postgresql e o nginx que a maioria tem usado e conhece bem, porém focando na otimização dos recursos para tentar uma performance razoável e brincar entre os monstros da rinha. 

- Load Balancer: Motor X
- Database: Elefantinho
- API: .NET 8 com Native AOT* 
- Metolodogia: XGH
- Design Principle: KISS
<br><br>
\* Após intimações de um amigo ~~neandertal~~ javeiro, fazendo PR para a rinha, com "CADÊ O SEU .NET AGORA?!". Bem, tá aqui seu ~~animal~~ lindo.

Para detalhes sobre a evolução do projeto e resultados, favor verificar o README no repositório da API.

API: [WagnerKessler/Rinha-de-Backend-Q1-2024](https://github.com/WagnerKessler/Rinha-de-Backend-Q1-2024)
<br>
Contato: [LinkedIn](https://linkedin.com/in/wkstumpf)

Kestrel entrando montado no postgres e acompanhado de muito go horse para a rinha... :)
![ASP.NET riding Postgres, paired by XGH](https://th.bing.com/th/id/OIG2.bRohJEk0k3Ex8OF4Fp5O)
