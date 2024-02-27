# syntax=docker/dockerfile:1
# Use a imagem oficial do Node.js como base
FROM node:18-alpine

# Defina o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copie o restante dos arquivos do projeto para o diretório de trabalho
COPY . .

# Instale as dependências do projeto
RUN npm install 

# To redirecionando a porta 8080 do contêiner para a porta 8081 do host
EXPOSE 8081:8080

# Comando para executar sua aplicação quando o contêiner for iniciado
CMD ["npm", "run", "dev"]

