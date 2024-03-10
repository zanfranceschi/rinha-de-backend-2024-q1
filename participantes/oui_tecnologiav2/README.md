# rinha-de-back-end-C-Crébitos-2024
Repositorio da api rest da rinha de back end C em 2024
Essa Versão não possui nenhuma otmização bizarra de perfórmace
e esta seguindo todos os critérios de funcionamento da OUI 

# Contatos

Caso queiram entrar em contanto com a gente

[Nosso Site](https://oui.tec.br/)

[Nosso linkedin](https://www.linkedin.com/company/oui-tecnologia/)

Whats do Cara que escreveu essa api:

+55 11 98333 1701

Email do cara que escreveu essa api:

mateusmoutinho01@gmail.com


# Rodando a aplicação 
para rodar essa aplicação ,você obrigatoriamente precisa estar em um linux
seja alguma distro ou wsl, e também precisa ter um compilador C instalado 
sendo gcc/g++ ou clang 
caso não tenha basta rodar: 
```shel
sudo apt install gcc
```


### Principal 
Para rodar em modo principal basta rodar:

```shel
gcc src/main.c && ./a.out 
```

### Debug 
Caso queira rodar em modo debug, basta rodar: 
```shel
gcc src/main.c -DDEBUG && ./a.out 
```
Em modo debug os arquivos dos clientes terão nomes e chaves sem abreviatura, e a aplicação irá rodar em single process

# Arquitetura 

Esse é o modelo arquitetural simples de funcionamento da aplicação
baseado em armazenamento de arquivos 
Esse modelo arquitetural esta sendo baseado no modo debug de execução
já que em modo prod os nomes são todos abreviados

![Fluxograma Arquitetural](/arquitetura/fotos/fluxo.png)

# Estrutura de diretorio Inicial

Essa é a estrutura de diretorio inicial , que é criada na **main** 
antes da aplicação iniciar 

![Fluxograma Armazenamento inicial](/arquitetura/fotos/armazenamento_inicial.png)

# Estrutura de diretorios Rodando

Essa é estrutura de diretorios enquanto a aplicação esta rodando

![Fluxograma Rodando](/arquitetura/fotos/rodando.png)

# Configurando
em **src/constantes/aplicacao.h**, você pode encontrar todas 
as constantes que controlam o app, como total da fila, total de requests 
simultaneos , etc.

```c

#define PORTA_PADRAO 9999
#define INCONSISTENCIA 422
#define NAO_ENCONTRADO 404
#define MAXIMO_BODY 200
#define RETORNO_OK 200
#define MAXIMO_TRANSACOES 10

#ifdef  DEBUG
#define IDENTAR true
#else
#define  IDENTAR false
#endif
#define MAXIMO_FILA 100000
#define MAXIMO_REQUEST 5
#define TIMEOUT_FUNCAO 60
#define TIMEOUT_CLIENTE 60
```
# Testes

![Imagem teste](/fotos_testes/1.png)
### Teste de vazamento de memória

Para testar vazamentos de memória, você precisa ter o valgrind instalado na sua máquina,instale com(debian baseds): 

```shel 
sudo apt-get install valgrind
```
e rode com :(para finalizar basta bater em **/end**)
```shel 
gcc src/main.c  -DDEBUG && valgrind ./a.out 
```
### Teste de Sanitização 
Também é possível testar sanitização de acesso não autorizado de memória com:

```shel
gcc src/main.c  -DDEBUG -fsanitize=address && ./a.out
```

### Teste de Observabilidade 

Também é possível observar as entradas e saidas de todas as requisições, nesse modo toda requisição será salva na pasta **requisicoes** contendo o request, a respostas, e o meta (contendo dados como inicio, fim , e tempo de bloqueamento do cliente)

```shel
gcc src/main.c  -DOBSERVAR  && ./a.out
```

# Armazenamento  




# dependencias:
 
Para fazer essa api usei uma série de tecnologias OUI

### CWebStudio
Framework web usado para construir fazer as requisições http

[Repositório](https://github.com/OUIsolutions/CWebStudio)

### DoTheWorld
Biblioteca de armazenamento transacional usada para armazenar os arquivos
dos clientes,controlar os bloqueamentos de cada cliente

[Repositório](https://github.com/OUIsolutions/DoTheWorld)

### CXpathJson 
Usada para escrever/ler todos os jsons do projeto, tanto os dos arquivos dos clientes, quanto as entradas e saidas da api 

[Repositório](https://github.com/OUIsolutions/cxpathjson)

### Universal Garbage
Usada para controlar memória impedindo buffer overflows e segment faults 

[Repositório](https://github.com/OUIsolutions/Universal-Garbage-Colector)

### cJSON 
Usada para fazer a interoperabilidade entre o CWebStudio e o CxpathJson 
já que ambos usam o cJSON por baixo 

[Repositório](https://github.com/DaveGamble/cJSON)

### CTextEngine 
Usada para o Processamento de strings 

[Repositório](https://github.com/OUIsolutions/CTextEngine)

