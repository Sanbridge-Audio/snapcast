# Set the base image
ARG DEBIAN_VERSION=stable-slim
FROM debian:${DEBIAN_VERSION} AS snapbase

# Set maintainer label
LABEL maintainer="Matt Dickinson <matt.dickinson@outlook.com>"

# Set argument for snapserver version
ARG SNPSRV_VERSION=0.27.0
ENV Version=$SNPSRV_VERSION

# Set environment variables
ENV HOME=/root
ENV TZ=America/New_York

# Install packages required to setup snapserver
RUN apt-get update && apt-get install -y \
    nano \
    git \
    libpulse-dev \
    libsoxr-dev \
    alsa-utils \
    libavahi-client-dev \
    avahi-daemon \
    wget && \
    rm -rf /var/lib/apt/lists/*

# Download and install snapserver
WORKDIR /tmp
RUN wget https://github.com/badaix/snapcast/releases/download/v${SNPSRV_VERSION}/snapserver_${SNPSRV_VERSION}-1_amd64.deb && \
    apt install ./snapserver_${SNPSRV_VERSION}-1_amd64.deb && \
    rm ./snapserver_${SNPSRV_VERSION}-1_amd64.deb

RUN wgethttps://github.com/badaix/snapcast/releases/download/v0.27.0/snapserver_0.27.0-1_amd64.deb
# Create new image based on snapbase
FROM snapbase

# Set working directory
WORKDIR $HOME

# Download s6 overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.3/s6-overlay-amd64.tar.gz /tmp
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /

# Copy snapserver service definition
COPY snapserver /etc/services.d/snapserver

# Copy snapserver configuration file and remove the default one
COPY snapserver.conf /etc/
RUN rm /etc/snapserver.conf

# Set volume
VOLUME /tmp

# Set command and entrypoint
CMD ["snapserver", "--stdout", "--no-daemon"]
ENTRYPOINT ["/init"]

# Expose ports
EXPOSE 1704 1705
