# Ubiquiti UniFi Controller
FROM openjdk:8
MAINTAINER john@johnmccabe.net

LABEL version="5.5.24"
LABEL distro="debian"

ENV DEBIAN_FRONTEND noninteractive
ENV UNIFI_VERSION 5.5.24

RUN mkdir -p /usr/lib/unifi/data && \
    touch /usr/lib/unifi/data/.unifidatadir

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10 \
    && echo "deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen"  >> /etc/apt/sources.list \
    && apt-get update \
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
