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
    snapserver \
    wget && \
    rm -rf /var/lib/apt/lists/*

# Create new image based on snapbase
FROM snapbase

# Set working directory
WORKDIR $HOME

# Remove old configuration file and copy new configuration file.
RUN rm /etc/snapserver.conf
COPY snapserver.conf /etc/


# Set volume
VOLUME /tmp

# Set command and entrypoint
CMD ["snapserver", "--stdout", "--no-daemon"]
#ENTRYPOINT ["/init"]

# Expose ports
EXPOSE 1704 1705 1780
