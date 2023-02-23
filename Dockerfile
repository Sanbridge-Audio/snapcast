FROM debian:buster-slim

RUN apt update && apt install -y \
    build-essential \
    git \
    libasound2-dev \
    libvorbisidec-dev \
    libflac-dev \
    libogg-dev \
    libopus-dev \
    libpcre3-dev \
    libsoxr-dev \
    libprotobuf-c-dev \
    libavahi-client-dev \
    protobuf-c-compiler \
    libavahi-common-dev \
    autoconf \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/badaix/snapcast.git /snapcast \
    && cd /snapcast \
    && git checkout $(git tag | sort -V | tail -n 1) \
    && git submodule update --init \
    && autoreconf -fi \
    && ./configure \
    && make \
    && make install

ENTRYPOINT ["/usr/local/bin/snapserver"]
