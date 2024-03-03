FROM golang:1.21 as base

WORKDIR /app
COPY . /app

RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux go build cmd/main.go

FROM alpine

WORKDIR /app
COPY go.mod go.sum ./

COPY --from=base /app/main ./

EXPOSE 80
ENV GIN_MODE release
CMD [ "./main" ]