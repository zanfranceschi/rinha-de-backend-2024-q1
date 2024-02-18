# Dockerfile References: https://docs.docker.com/engine/reference/builder/

# Start from the latest golang base image
FROM golang:1.19.4-alpine

# Add Maintainer Info
LABEL maintainer="Gabriel Crispino <gabriel.crispino@hotmail.com>"

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source from the current directory to the Working Directory inside the container
COPY . .

# Build the Go app
RUN go build -o rinha .

# Expose port 8080 to the outside world
EXPOSE 8080

# Command to run the executable
CMD ["./rinha", "8080"]
