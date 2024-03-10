FROM golang:1.21.6-alpine as builder

RUN apk add --no-cache gcc musl-dev

WORKDIR /app

COPY . .

RUN go build -o main

EXPOSE 3000

CMD ["./main"]
