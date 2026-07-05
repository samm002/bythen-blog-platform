FROM golang:1.26.4-alpine

# Install tools for development
RUN apk add --no-cache git curl

# Install air for hot reload
RUN go install github.com/air-verse/air@latest

# Install goose for database migrations
RUN go install github.com/pressly/goose/v3/cmd/goose@latest

WORKDIR /app

# Cache dependencies
# Copy only mod files first so Docker caches 'go mod download'
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY . .

# Run Air for hot reload (will build into ./tmp/app and restart on changes)
CMD ["air"]