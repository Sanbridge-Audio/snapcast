<<<<<<< HEAD
#FROM debian:stable 
FROM debian:bullseye-slim AS builder
LABEL maintainer "Matt Dickinson"
=======
# Set the base image
ARG DEBIAN_VERSION=stable-slim
FROM debian:${DEBIAN_VERSION} AS snapbase
>>>>>>> gpt

# Set maintainer label
LABEL maintainer="Matt Dickinson <matt.dickinson@outlook.com>"

# Set argument for snapserver version
ARG SNPSRV_VERSION=0.27.0
ENV Version=$SNPSRV_VERSION

# Set environment variables
ENV HOME=/root
ENV TZ=America/New_York

<<<<<<< HEAD
# Install dependencies
RUN apt-get update && \
    apt-get install -y \
        alsa-utils \
        avahi-daemon \
        build-essential \
        git \
        libasound2-dev \
        libpulse-dev \
        libvorbisidec-dev \
        libvorbis-dev \
        libopus-dev \
        libflac-dev \
        libsoxr-dev \
        libavahi-client-dev \
        libexpat1-dev \
        libboost1.74-dev && \
    rm -rf /var/lib/apt/lists/*

# Clone the source code
RUN git clone https://github.com/badaix/snapcast.git

# Build the software
WORKDIR /snapcast
RUN make

# Create the final image
FROM debian:bullseye-slim
#FROM debian:stable-slim
LABEL maintainer "Matt Dickinson"

ENV TZ=America/New_York

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
        alsa-utils \    
        avahi-daemon \
        libasound2-dev \
        libpulse-dev \
        libvorbisidec-dev \
        libvorbis-dev \
        libopus-dev \
        libflac-dev \
        libsoxr-dev \
        libavahi-client-dev \
        libexpat1-dev \
        mosquitto-clients \
        nano && \
    rm -rf /var/lib/apt/lists/*

# Copy the binary and configuration files from the builder stage
COPY --from=builder /usr/bin/snapserver /usr/bin

RUN mkdir /usr/share/snapserver

COPY --from=builder /usr/share/snapserver /usr/share/snapserver

COPY snapserver.conf /etc
=======
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
RUN rm /etc/snapserver.conf
COPY snapserver.conf /etc/

>>>>>>> gpt

# Set volume
VOLUME /tmp

# Set command and entrypoint
CMD ["snapserver", "--stdout", "--no-daemon"]
ENTRYPOINT ["/init"]

<<<<<<< HEAD


=======
# Expose ports
EXPOSE 1704 1705 1780
>>>>>>> gpt
