# Build stage
FROM golang:1.22-alpine AS builder

WORKDIR /build

# Copy dependency files first for better layer caching
COPY app/go.mod ./
RUN go mod download

# Copy source and compile a static binary
COPY app/ ./
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /hello-world .

# Final stage — minimal scratch image
FROM scratch

# Import CA certs and passwd from alpine for HTTPS + non-root user
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /etc/passwd /etc/passwd

# Copy the compiled binary
COPY --from=builder /hello-world /hello-world

# Run as nobody (non-root)
USER nobody

EXPOSE 8080

ENTRYPOINT ["/hello-world"]
