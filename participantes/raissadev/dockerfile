FROM golang:1.21 as build

## CONFIG GOLANG
ENV PATH="$PATH:$(go env GOPATH)/bin"
ENV CGO_ENABLED 0
ENV GOPATH /go
ENV GOCACHE /go-build
ENV GOOS linux
ENV GOFLAGS "-ldflags=-s -w"

WORKDIR /go/src

COPY ./go.mod ./go.sum ./.env ./cmd/main.go ./

RUN go mod tidy
RUN go mod download

RUN go build -v -o main

FROM alpine:latest as finally

WORKDIR /app

COPY --from=build /go/src/main ./
COPY --from=build /go/src/.env ./

# EXPOSE 4200

CMD [ "/app/main" ]