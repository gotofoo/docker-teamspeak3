FROM debian:jessie

#   Environment variables
ENV UID 0
ENV GID 0

#   Setup container
ADD entrypoint.sh /

RUN apt-get update && apt install -y wget bzip2 && \
    mkdir -p /usr/local/bin/teamspeak3 && \
    cd /tmp && \
    TSLINK=$(wget -O - http://www.teamspeak.com/downloads.html | grep '^\s*<a.*teamspeak3-server_linux_amd64.*\.tar\.bz2' | grep -o 'http://.*\.tar\.bz2') && \
    wget -O teamspeak.tar.bz2 $TSLINK && \
    tar -xjvf teamspeak.tar.bz2 --strip-components=1 -C /usr/local/bin/teamspeak3 && \
    rm teamspeak.tar.bz2 && \
    apt-get remove --purge -y wget bzip2 && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    chmod +x /entrypoint.sh && \
    mkdir /data

#   Volumes
VOLUME ["/data"]

#   Ports
EXPOSE 9987/udp 10011 30033

#   Entrypoint
ENTRYPOINT ["/entrypoint.sh"]

