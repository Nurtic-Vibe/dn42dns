FROM debian:jessie
MAINTAINER Xuu <xuu@sour.is>
VOLUME /srv

RUN	apt-get update && apt-get -y upgrade
RUN	apt-get install -y python3 build-essential monotone git dnsutils

RUN     git clone -b master https://github.com/nixnodes/zonebuild.git /opt/zonebuild
WORKDIR /opt/zonebuild
RUN     ./configure && make 

ADD    config.user /opt/zonebuild/scripts/

WORKDIR /opt/zonebuild/scripts

ENTRYPOINT  /bin/sh
CMD    /opt/zonebuild/scripts/run.sh root res zone arpa -update
