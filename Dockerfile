# Ubiquiti UniFi Controller
FROM ubuntu:xenial

LABEL author="john@johnmccabe.net"
LABEL version="5.12.35-12979-1"
LABEL mongodbversion="3.4"
LABEL jdkversion="8"

ENV DEBIAN_FRONTEND noninteractive
ENV UNIFI_VERSION 5.12.35-12979-1
ENV MONGODB_VERSION 3.4
ENV JDK_VERSION 8

RUN mkdir -p /usr/lib/unifi/data && \
    touch /usr/lib/unifi/data/.unifidatadir

RUN apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests curl \
    && curl -sLOk https://www.mongodb.org/static/pgp/server-${MONGODB_VERSION}.asc \
    && apt-key add server-${MONGODB_VERSION}.asc \
    && echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" >> /etc/apt/sources.list.d/mongo.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
            mongodb-server \
            binutils \
            openjdk-8-jre-headless \
            jsvc \
    && curl -o /tmp/unifi_sysvinit_all.deb -L \
            https://www.ui.com/downloads/unifi/debian/pool/ubiquiti/u/unifi/unifi_${UNIFI_VERSION}_all.deb \
    && dpkg -i /tmp/unifi_sysvinit_all.deb \
    && apt-get -q clean \
    && rm -rf /tmp/unifi_sysvinit_all.deb \
            /var/lib/apt/lists/* \
            /var/tmp/* \
            /tmp/*

VOLUME /usr/lib/unifi/data
EXPOSE  3478/udp 8443/tcp 8880/tcp 8080/tcp
WORKDIR /usr/lib/unifi
CMD ["java", "-Xmx256M", "-jar", "/usr/lib/unifi/lib/ace.jar", "start"]
