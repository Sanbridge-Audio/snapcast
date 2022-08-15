ARG DEBIAN_VERSION=stable-slim
#:${DEBIAN_VERSION}
FROM debian:stable AS snapbase
LABEL maintainer "Matt Dickinson <matt@sanbridge.org>"

ARG SNPSRV_VERSION=0.26.0-1
ENV Version=$SNPSRV_VERSION
ENV HOME /root
ENV TZ=America/New_York

#Installation of everything needed to setup snapserver
RUN apt-get update && apt-get install -y \
#    apt-get install wget -y && \
#    apt-get install apt-utils -y && \
	nano \
	git \
	build-essential \
  libasound2-dev \
  libpulse-dev \
  libvorbisidec-dev \
  libvorbis-dev \
  libopus-dev \
  libflac-dev \
  libsoxr-dev \
  alsa-utils \
  libavahi-client-dev \
  avahi-daemon \
  libexpat1-dev \
	mosquitto-clients

RUN git clone https://github.com/badaix/snapcast.git

WORKDIR /snapcast
#RUN cd <snapcast dir>
#RUN make

FROM snapbase
WORKDIR $HOME
#Download the most recent s6 overlay.
#ADD https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.3/s6-overlay-amd64.tar.gz /tmp
#RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /

#COPY snapserver /etc/services.d/snapserver



#RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#RUN mkdir -p ~/.config/snapcast/

#RUN rm /etc/snapserver.conf

COPY snapserver.conf /etc

VOLUME /tmp


#CMD ["snapserver", "--stdout", "--no-daemon"]
#ENTRYPOINT ["/init"]



EXPOSE 1704
EXPOSE 1705


