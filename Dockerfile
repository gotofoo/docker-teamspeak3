FROM debian:jessie

ENV UID 0
ENV GID 0

ADD entrypoint.sh /

RUN apt update && apt install -y wget bzip2 && \
    mkdir -p /usr/local/bin/teamspeak3 && \
    cd /tmp && \
    TSLINK=$(wget -O - http://www.teamspeak.com/downloads.html | grep '^\s*<a.*teamspeak3-server_linux_amd64.*\.tar\.bz2' | grep -o 'http://.*\.tar\.bz2') && \
    wget -O teamspeak.tar.bz2 $TSLINK && \
    tar -xjvf teamspeak.tar.bz2 --strip-components=1 -C /usr/local/bin/teamspeak3 && \
    rm teamspeak.tar.bz2 && \
    apt remove -y wget bzip2 && \
    apt auto-remove && \
    rm -rf /var/lib/apt/lists/* && \
    chmod +x /entrypoint.sh && \
    mkdir /data

VOLUME ["/data"]

EXPOSE 9987/udp 10011 30033

ENTRYPOINT ["/entrypoint.sh"]

