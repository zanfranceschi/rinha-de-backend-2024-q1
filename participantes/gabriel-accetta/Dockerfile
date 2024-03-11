FROM node:20-buster-slim

WORKDIR /app

COPY package*.json ./

RUN apt-get update -y && apt-get install -y openssl

RUN npm install

COPY src ./src
COPY prisma ./prisma
COPY .env ./
COPY tsconfig.json ./

RUN npx prisma generate

RUN npm run build

EXPOSE 8080

CMD ["npm", "run", "start"]