FROM debian:stable AS snapbase
LABEL maintainer "Matt Dickinson <matt@sanbridge.org>"

ENV TZ=America/New_York

#Installation of everything needed to setup snapserver
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

RUN git clone https://github.com/badaix/snapcast.git #&& \
  #cd snapcast 

WORKDIR /snapcast

RUN make
RUN make installserver

FROM debian:stable-slim AS config

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

COPY --from=snapbase /usr/bin/snapserver /usr/bin

RUN mkdir /usr/share/snapserver

COPY --from=snapbase /usr/share/snapserver /usr/share/snapserver

COPY snapserver.conf /etc

VOLUME /tmp

CMD ["snapserver", "--stdout", "--no-daemon"]

EXPOSE 1704 1705 1780
