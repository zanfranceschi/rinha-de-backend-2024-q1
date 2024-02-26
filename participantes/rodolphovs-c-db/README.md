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

Fork do projeto [c-async-disk-api](https://github.com/RodolphoVSantoro/c-async-disk-api)

Leia a descrição da submissão do original para mais detalhes

A principal mudança do fork, é que agora o projeto roda uma api separada que funciona como um db, em vez de acessar o disco diretamente.

---
### Links

- [RodolphoVSantoro](https://github.com/RodolphoVSantoro) (@github)
- [Rodolphovs](https://gitlab.com/Rodolphovs) (@gitlab)
- [Source Code](https://github.com/RodolphoVSantoro/c-async-db-api) (@github)

---

### Menções

- [Reinaldo Rozato Junior](https://github.com/oloko64) -> Ajuda com melhorias no nginx e no docker
