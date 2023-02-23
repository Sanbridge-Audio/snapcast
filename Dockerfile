#FROM debian:stable 
FROM debian:bullseye-slim AS builder
LABEL maintainer "Matt Dickinson"

ENV TZ=America/New_York

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

VOLUME /tmp

EXPOSE 1704 1705 1780

CMD ["snapserver", "--stdout", "--no-daemon"]



