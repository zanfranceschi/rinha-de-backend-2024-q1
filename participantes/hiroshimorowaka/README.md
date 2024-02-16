# Submissão para Rinha de Backend, Segunda Edição: 2024/Q1 - Controle de Concorrência

# Hiroshi Morowaka

Essa versão da API tem um pequeno bugzinho que PODE ocorrer na hora de inicializar o container  
Pode ser que o container da API suba antes do postgres estar pronto pra receber conexões (apesar do depends_on)   
Então SE acontecer de dar algum erro na hora de subir, só derrubar os containers das APIs e subir de novo sem resetar o postgres

Se aparecer "tabelas criadas" ta funfando perfeito

Pra apagar os dados do banco sem precisar resetar o container, use: 
```bash
curl http://localhost:9999/deletedb
```

Irá RESETAR as tabelas (apesar do nome);


### Essa aplicação foi feita com:
- Bun (Runtime Javascript)
- Fastify (Framework WEB)
- Postgres (Banco de dados relacional)
- Nginx (Balanceador de carga)
- [Repositório da API](https://github.com/hiroshimorowaka/rinha-backend-2024)

<hr>
<div style="display: flex; gap: 15px;">
 <a href = "mailto:guilhermecabral1204@gmail.com"><img src="https://img.shields.io/badge/-Gmail-%23333?style=for-the-badge&logo=gmail&logoColor=white" target="_blank"></a>
 <a href = "https://twitter.com/hiroshi_morowak"><img src="https://img.shields.io/badge/Twitter-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white" target="_blank"></a>
 <div>
 
 <hr>