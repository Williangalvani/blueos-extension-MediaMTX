# Use Alpine Linux as base image for smaller size
FROM golang:1.23.5-alpine3.21

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
    git checkout v1.11.2 && \
    go generate ./... && \
    CGO_ENABLED=0 go build . && \
    rm -rf /root/.cache

# Create config directory
RUN mkdir /app/config
RUN mkdir -p /usr/blueos/extensions/mediamtx

# Copy configuration file and start script
COPY mediamtx.yml /app/config/mediamtx.yml.template
COPY start.sh /app/start.sh
COPY reader.js /app/reader.js
COPY index.html /app/index.html
COPY webrtc.html /app/webrtc.html
COPY webserver.py /app/webserver.py
COPY register_service /app/register_service
RUN chmod +x /app/start.sh /app/webserver.py

# Expose RTSP, WebRTC, and web server ports
EXPOSE 8554
EXPOSE 8889
EXPOSE 8908

# Docker labels for BlueOS
LABEL version="1.0.0"
LABEL permissions='{\
  "HostConfig": {\
    "Privileged": true,\
    "NetworkMode": "host",\
    "Binds":[\
      "/usr/blueos/extensions/mediamtx:/usr/blueos/extensions/mediamtx"\
    ]\
  }\
}'

# Use the start script as entrypoint
ENTRYPOINT ["/app/start.sh"]