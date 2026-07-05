FROM golang:1.26.4-alpine

# Install tools for development
RUN apk add --no-cache git curl

# Install air for hot reload
RUN go install github.com/air-verse/air@v1.65.3

# Install goose for database migrations
RUN go install github.com/pressly/goose/v3/cmd/goose@v3.27.2

WORKDIR /app

# Cache dependencies
# Copy only mod files first so Docker caches 'go mod download'
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY . .

# Run App (Hot reloaded using Air)
CMD ["air"]