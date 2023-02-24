# Use Debian stable as the base image
FROM debian:stable AS snapbase

# Set the maintainer label
LABEL maintainer "Matt Dickinson <matt@sanbridge.org>"

# Set the timezone environment variable
ENV TZ=America/New_York

# Install required packages for building Snapcast
RUN apt-get update && apt-get install -y \
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
    libboost-all-dev 

# Clone the Snapcast repository
RUN git clone https://github.com/badaix/snapcast.git

# Set the working directory to the Snapcast server directory
WORKDIR /snapcast/server

# Build and install Snapcast
RUN make && make install NO_ADDUSER=1

# Create a new image for the configuration
FROM debian:stable-slim AS config

# Install required packages for running Snapcast
RUN apt-get update && apt-get install -y \
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
    nano 

# Copy the snapserver binary from the snapbase image
COPY --from=snapbase /usr/bin/snapserver /usr/bin

# Copy the Snapcast configuration files
RUN mkdir /usr/share/snapserver
COPY --from=snapbase /usr/share/snapserver /usr/share/snapserver
COPY snapserver.conf /etc

# Expose the necessary ports
EXPOSE 1704 1705 1780

# Set the default command for the container
CMD ["snapserver", "--stdout", "--no-daemon"]
