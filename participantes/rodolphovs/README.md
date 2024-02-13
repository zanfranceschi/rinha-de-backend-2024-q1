# Submissão para Rinha de Backend, Segunda Edição: 2024/Q1 - Controle de Concorrência


<img src="https://upload.wikimedia.org/wikipedia/commons/c/c5/Nginx_logo.svg" alt="logo nginx" width="400" height="auto">
<br />
<img src="https://imgs.search.brave.com/CJ1qsQ77NgbW8m08i7yLKL6m78khjHtNRuLy082Pg-w/rs:fit:860:0:0/g:ce/aHR0cHM6Ly91cGxv/YWQud2lraW1lZGlh/Lm9yZy93aWtpcGVk/aWEvY29tbW9ucy8w/LzBlL1RoZV9DX1By/b2dyYW1taW5nX0xh/bmd1YWdlLF9GaXJz/dF9FZGl0aW9uX0Nv/dmVyLnN2Zw.svg" alt="logo C" width="400" height="auto">

## Rodolpho Vianna Santoro ([RodolphoVSantoro](https://github.com/RodolphoVSantoro))

### Ferramentas utilizadas

- `nginx` como load balancer
- `c99` api e banco, utilizando libs como:
  - `sys/socket.h` para receber requisições
  - `sys/file.h` para controle de concorrência de arquivos

<img src="https://s3.amazonaws.com/codenewbie-assets/blogs/binarydropping.gif" alt="logo postgres" width="300" height="auto">

---
### Descrição

Esse projeto foi feito pensando em comparar como uma aplicação simples em C com arquivos binários e locks como **"banco de dados"**, sem uso de nenhuma lib externa ou algum banco, se comportaria em relação as outras submissões.

Também foi minha primeira vez trabalhando com async em C, é um repositório interessante para quem tem curiosidade de ver como funciona(usei o select, mas existem também o poll e o epoll que são melhores).

Mas por favor, nunca usem o código fonte nesse repositório para se basearem em uma aplicação C em produção. Muitas validações e garantias foram deixadas de lado para simplificar o código. Além disso, sou longe de ser um especialista em network programming em C.

---

### Como rodar
```bash
make resetDb # para resetar/criar o banco
sudo docker compose build # para buildar a imagem
sudo docker compose up # para rodar a aplicação
```

---

### Preview testes

<img src="https://i.imgur.com/QARPqZu.png" alt="preview1" width="auto" height="auto">

<img src="https://i.imgur.com/wlZj7Ft.png" alt="preview2" width="auto" height="auto">

<img src="https://i.imgur.com/9EAG9iF.png" alt="preview3" width="auto" height="auto">

#### Teste bônus

<img src="https://i.imgur.com/VX6tckh.png" alt="preview4" width="auto" height="auto">

---
### Links

- [RodolphoVSantoro](https://github.com/RodolphoVSantoro) (@github)
- [Rodolphovs](https://gitlab.com/Rodolphovs) (@gitlab)
- [Source Code](https://github.com/RodolphoVSantoro/c-async-disk-api) (@github)

---

### Menções

- [Reinaldo Rozato Junior]((https://github.com/oloko64)) -> Ajuda com melhorias no nginx e no docker
