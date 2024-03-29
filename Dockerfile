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
    alsa-utils \
    avahi-daemon \
    git \
    libpulse-dev \
    libsoxr-dev \
    libavahi-client-dev \
    nano \
    pulseaudio \
    wget && \
    rm -rf /var/lib/apt/lists/*

# Download and install snapserver
WORKDIR /tmp
RUN wget https://github.com/badaix/snapcast/releases/download/v${SNPSRV_VERSION}/snapserver_${SNPSRV_VERSION}-1_armhf.deb \
    && dpkg -i ./snapserver_${SNPSRV_VERSION}-1_armhf.deb \
    && apt update && apt -f install -y \
    && rm -rf /var/lib/apt/lists/*
#rm ./snapserver_${SNPSRV_VERSION}-1_armhf.deb

# Create new image based on snapbase
FROM snapbase

# Set working directory
WORKDIR $HOME

# Download s6 overlay
#ADD https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.3/s6-overlay-amd64.tar.gz /tmp
#RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /

# Copy snapserver service definition
#COPY snapserver /etc/services.d/snapserver

# Remove old configuration file and copy new configuration file.
RUN rm /etc/snapserver.conf
COPY snapserver.conf /etc/


# Set volume
VOLUME /tmp

# Set command and entrypoint
CMD ["snapserver", "--stdout", "--no-daemon"]
ENTRYPOINT ["/init"]

# Expose ports
EXPOSE 1704 1705 1780
