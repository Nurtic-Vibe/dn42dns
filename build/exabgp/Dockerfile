FROM debian:jessie
MAINTAINER Nurtic-Vibe <nurtic-vibe@grmml.eu>
VOLUME /srv

RUN	apt-get update && apt-get -y upgrade
RUN	apt-get install -y python build-essential git dnsutils

RUN     git clone -b master https://github.com/Exa-Networks/exabgp.git /opt/exabgp

RUN     /opt/exabgp/sbin/exabgp --fi > /opt/exabgp/etc/exabgp/exabgp.env

ENTRYPOINT  /bin/bash
CMD    /opt/exabgp/sbin/exabgp /srv/exabgp/exabgp.conf
