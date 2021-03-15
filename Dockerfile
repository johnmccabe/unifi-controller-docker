# Ubiquiti UniFi Controller
FROM ubuntu:focal-20210217

LABEL author="john@johnmccabe.net"
LABEL version="6.0.45"

ENV DEBIAN_FRONTEND noninteractive
ENV UNIFI_VERSION 6.0.45

RUN mkdir -p /usr/lib/unifi/data && \
    touch /usr/lib/unifi/data/.unifidatadir

RUN apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
            binutils \
            libcap2 \
            openjdk-8-jre-headless \
            jsvc \
            logrotate \
            curl \
            mongodb-server \
    && curl -LO https://dl.ui.com/unifi/${UNIFI_VERSION}/unifi_sysvinit_all.deb \
    && dpkg -i ./unifi_sysvinit_all.deb \
    && apt-get -q clean \
    && rm -rf ./unifi_sysvinit_all.deb \
            /var/lib/apt/lists/* \
            /var/tmp/* \
            /tmp/*

VOLUME /usr/lib/unifi/data

# UDP	3478	Port used for STUN.
# UDP	5514	Port used for remote syslog capture.
# TCP	8080	Port used for device and controller communication.
# TCP	8443	Port used for controller GUI/API as seen in a web browser
# TCP	8880	Port used for HTTP portal redirection.
# TCP	8843	Port used for HTTPS portal redirection.
# TCP	6789	Port used for UniFi mobile speed test.
# TCP	27117	Port used for local-bound database communication.
# UDP	5656-5699	Ports used by AP-EDU broadcasting.
# UDP	10001	Port used for device discovery
# UDP	1900	Port used for "Make controller discoverable on L2 network" in controller settings.
EXPOSE  3478/udp 8080/tcp 8443/tcp 8880/tcp 8843/tcp

WORKDIR /usr/lib/unifi
CMD ["java", "-Xmx1024M", "-jar", "/usr/lib/unifi/lib/ace.jar", "start"]
