# ---- Build stage ----
FROM golang:1.22-alpine AS builder

# Install git (needed for some Go modules)
RUN apk add --no-cache git

WORKDIR /app

# Cache dependencies first
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY . .

# Build the binary (static)
RUN go build -o app .

# ---- Final stage ----
FROM alpine:latest

WORKDIR /app

# Add CA certificates (important for HTTPS requests)
RUN apk add --no-cache ca-certificates

# Copy binary from builder
COPY --from=builder /app/app .

# Expose your app port
EXPOSE 9226

# Run the binary
CMD ["./app"]
