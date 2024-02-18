FROM oven/bun:1.0.27-alpine

WORKDIR /src

RUN apk update && apk upgrade && \
    apk add --no-cache sqlite-dev

ADD package.json .
ADD ./src .
ADD ./config/init.sql .

RUN bun install

ENTRYPOINT ["/bin/sh", "entrypoint.sh"]