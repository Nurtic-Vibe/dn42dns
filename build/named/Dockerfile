FROM debian:jessie
MAINTAINER Xuu <xuu@sour.is>
VOLUME /srv

RUN	apt-get update; apt-get -y upgrade
RUN	apt-get install -y bind9 python3

RUN	mkdir -p /etc/bind/dn42/

ENTRYPOINT	/usr/sbin/named
CMD		-g -c /srv/bind/named.conf -u bind
