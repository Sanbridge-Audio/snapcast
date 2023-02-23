FROM debian:stable-slim
RUN apt-get update && apt-get install -y autoconf

RUN apt update && \
    apt install -y --no-install-recommends \
        build-essential \
        git \
        libasound2-dev \
        libavahi-client-dev \
        libavcodec-dev \
        libavformat-dev \
        libexpat1-dev \
        libflac-dev \
        libogg-dev \
        libopus-dev \
        libsamplerate0-dev \
        libsndfile1-dev \
        libsoxr-dev \
        libvorbis-dev \
        libwebsockets-dev \
        libxml2-dev \
        python3 \
        python3-setuptools \
        python3-wheel \
        python3-pip && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/badaix/snapcast.git /snapcast && \
    cd /snapcast && \
    git checkout $(git tag | sort -V | tail -n 1) && \
    git submodule update --init && \
    autoreconf -fi && \
    ./configure && \
    make

WORKDIR /snapcast

CMD ["./snapserver"]
