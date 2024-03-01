<img src="./logo.png" width="250" alt="Logo" />

# [raw - Uma stack sob-medida](https://github.com/rafaelrcamargo/raw)

Talvez a submissão mais simples de todas, ela não faz um A a mais que o pedido, uma stack feita inteiramente para a rinha, é... é bem isso. INTEIRAMENTE para a rinha. E quando falo isso nem exagero. O ponto de partida foi o banco de dados, com a ideia de criar um banco específico para o desafio que não saía da minha cabeça. Em poucos dias, com um protótipo funcionando, não havia mais volta. Quem desenvolve um banco, cria um servidor HTTP, e quem cria um servidor HTTP, implementa um load balancer.

> [!NOTE]
>
> Queria deixar claro que esse código foi escrito seguindo o descrito [neste livro](https://raw.githubusercontent.com/rochacbruno/rust_memes/master/img/riir.jpg) 👀, e que o código é tão seguro quanto pegar um voo com cantor sertanejo no Brasil.

E assim se foram horas das minhas últimas semanas, mas o resultado é incrivelmente interessante para qualquer um querendo entender mais sobre bancos de dados, TCP e UDP, e programação em "baixo" nível em Rust. E quando digo isso, não é um exagero; a maioria do código, após o parse do JSON, utiliza apenas bytes para evitar [alocações desnecessárias e cópias em memória](https://preview.redd.it/b53rkfcszl761.png?auto=webp&s=e8e64a15689286b2ffbd8d596db50bc95953d209).

## Stack

- **Loadbalancer**: Desenvolvido em Rust, com `async-std` e validação otimista de requests.
- **Servidor HTTP**: Construído em Rust, com `async-std` e deserialização de JSON com SIMDs.
- **Banco de dados**: Criado em Rust, com suporte à comunicação via UDP e um protocolo de comunicação próprio.

## Sobre load balancer

O load balancer é um servidor TCP que aceita conexões de clientes e as distribui entre os servidores HTTP disponíveis usando um algoritmo de round-robin. Ele vai aceitar 16 conexões simultâneas, e é capaz de distribuir as requisições de forma otimista, ou seja, sem esperar a resposta do servidor HTTP para encaminhar a próxima requisição.

Vale ressaltar que o algoritmo de round-robin é feito da forma mais _BigBrain_ conhecida pelo homem, usando um `AtomicBool`, um valor que pode ser lido e escrito de forma segura por múltiplas threads e que calha de ser exatamente o que precisamos para fazer o round-robin entre 2 servidores.

## Sobre servidor HTTP

O servidor HTTP é um listener TCP que aceita até 4 conexões simultâneas, o servidor aproveita a vantagem de ser feito para este exato caso de uso e é capaz de ler apenas 1 byte para determinar o tipo de requisição, mais 1 byte para o ID e somente quando necessário encontrar o body e desserializar o JSON. Dessa forma, o request em si nunca precisa ser totalmente serializado em memória, economizando tempo e recursos.

## Sobre banco de dados

O banco de dados é baseado em um servidor UDP que aceita conexões de clientes e é capaz de armazenar e recuperar dados da maneira mais eficiente **o possível**. Da mesma forma que o servidor, o banco é otimizado para este caso de uso específico. Utiliza um protocolo de comunicação próprio e uma estrutura baseada em dados armazenados em formato binário compacto. O banco apenas adiciona ao arquivo quando um novo dado é inserido e, ao requisitar um dado, como em um extrato, lê exatamente os últimos N\*10 bytes do arquivo, onde N é o tamanho de uma transação.

## Como rodar

Para executar a stack, basta utilizar o docker-compose fornecido. Ele realizará o build de todos os componentes e iniciará o load balancer, servidor HTTP e banco de dados. Execute o comando:

```sh
docker-compose up
```

> [!IMPORTANT]
>
> Se você ainda é iniciante em Rust e está pensando em usar esse código como referencia, por favor, [prossiga com cuidado](https://preview.redd.it/1qso2ve8eza41.jpg?auto=webp&s=a86448cf247e24795e974fab23ff0243b9b81abc). Este código usa de diversas tecnicas que seriam incrievelmente inseguras em um ambiente de produção, como o uso de `unsafe` e `transmute` para manipular bytes diretamente. Além disso, o código não é testado e não possui nenhum tipo de garantia de funcionamento. **(Mas é incrivelmente divertido de ler, eu prometo!)**

## Contato

- **Twitter**: [@rafaelrcamargo](https://twitter.com/rafaelrcamargo)
- **GitHub**: [rafaelrcamargo](https://github.com/rafaelrcamargo)
- **Site**: [cmrg.me](https://cmrg.me) (_Sim, isso foi uma propaganda na cara dura_)
