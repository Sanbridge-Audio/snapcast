# Use a Debian base image
FROM debian:stable-slim AS builder

# Install build dependencies
RUN apt update && apt install -y \
    build-essential \
    git \
    libasound2-dev \
    libboost-dev \
    libogg-dev \
    libopus-dev \
    libssl-dev \
    libvorbis-dev \
    libexecinfo-dev \
    && rm -rf /var/lib/apt/lists/*

# Clone Snapcast repository and build it
RUN git clone https://github.com/badaix/snapcast.git /snapcast \
    && cd /snapcast \
    && git checkout $(git tag | sort -V | tail -n 1) \
    && git submodule update --init \
    && ./bootstrap \
    && ./configure \
    && make

# Use a smaller base image
FROM debian:stable-slim

# Copy the built Snapcast binary from the previous stage
COPY --from=builder /snapcast/server/snapserver /usr/local/bin/snapserver

# Clean up unnecessary dependencies
RUN apt update && apt install -y \
    libasound2 \
    libboost-system1.74.0 \
    libogg0 \
    libopus0 \
    libssl1.1 \
    libvorbis0a \
    && rm -rf /var/lib/apt/lists/*

# Expose the Snapcast server port
EXPOSE 1704

# Start the Snapcast server
CMD ["/usr/local/bin/snapserver", "-d"]
