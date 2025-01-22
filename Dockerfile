# Use Alpine Linux as base image for smaller size
FROM alpine:3.20

# Install required dependencies
RUN apk add --no-cache \
    gcc \
    musl-dev \
    git \
    go \
    ffmpeg \
    gettext

# Set working directory
WORKDIR /app

# Clone and build mediamtx with a specific version
RUN git clone https://github.com/aler9/mediamtx.git . && \
    git checkout v1.9.3 && \
    go generate ./... && \
    CGO_ENABLED=0 go build .

# Create config directory
RUN mkdir /app/config

# Copy configuration file and start script
COPY mediamtx.yml /app/config/mediamtx.yml.template
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Expose RTSP port
EXPOSE 8554

# Set default environment variable
ENV TARGET_RTSP_URL=rtsp://source-camera:554/stream

# Use the start script as entrypoint
ENTRYPOINT ["/app/start.sh"]