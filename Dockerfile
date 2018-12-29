# Ubiquiti UniFi Controller
FROM debian:jessie

LABEL author="john@johnmccabe.net"
LABEL version="5.9.29"
LABEL mongodbversion="3.4"
LABEL jdkversion="8"

ENV DEBIAN_FRONTEND noninteractive
ENV UNIFI_VERSION 5.9.29
ENV MONGODB_VERSION 3.4
ENV JDK_VERSION 8

RUN mkdir -p /usr/lib/unifi/data && \
    touch /usr/lib/unifi/data/.unifidatadir

RUN apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests curl \
    && curl -sLOk https://www.mongodb.org/static/pgp/server-${MONGODB_VERSION}.asc \
    && apt-key add server-${MONGODB_VERSION}.asc \
    && echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/${MONGODB_VERSION} main"  >> /etc/apt/sources.list \
    && echo "deb http://http.debian.net/debian jessie-backports main" >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y -t jessie-backports openjdk-${JDK_VERSION}-jdk \
    && apt-get install -y --no-install-recommends --no-install-suggests \
            mongodb-server \
            curl \
            binutils \
            jsvc \
    && curl -o /tmp/unifi_sysvinit_all.deb -k \
            http://dl.ubnt.com/unifi/${UNIFI_VERSION}/unifi_sysvinit_all.deb \
    && dpkg -i /tmp/unifi_sysvinit_all.deb \
    && apt-get -q clean \
    && rm -rf /tmp/unifi_sysvinit_all.deb \
            /var/lib/apt/lists/*

VOLUME /usr/lib/unifi/data
EXPOSE  3478/udp 8443/tcp 8880/tcp 8080/tcp
WORKDIR /usr/lib/unifi
CMD ["java", "-Xmx256M", "-jar", "/usr/lib/unifi/lib/ace.jar", "start"]
