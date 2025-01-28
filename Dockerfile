# Use Alpine Linux as base image for smaller size
FROM alpine:3.20

# Install required dependencies
RUN apk add --no-cache \
    gcc \
    musl-dev \
    git \
    go \
    ffmpeg \
    gettext \
    python3

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
COPY index.html /app/index.html
COPY webserver.py /app/webserver.py
RUN chmod +x /app/start.sh /app/webserver.py

# Expose RTSP, WebRTC, and web server ports
EXPOSE 8554
EXPOSE 8889
EXPOSE 8908

# Set default environment variable
ENV TARGET_RTSP_URL=rtsp://source-camera:554/stream

# Use the start script as entrypoint
ENTRYPOINT ["/app/start.sh"]