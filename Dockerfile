FROM debian:jessie
#FROM alpine

RUN \
    apt update && apt install -y wget bzip2 && \
    mkdir -p /usr/local/bin/teamspeak3 && \
    cd /tmp && \
    TSLINK=$(wget -O - http://www.teamspeak.com/downloads.html | grep '^\s*<a.*teamspeak3-server_linux_amd64.*\.tar\.bz2' | grep -o 'http://.*\.tar\.bz2') && \
    wget -O teamspeak.tar.bz2 $TSLINK && \
    tar -xjvf teamspeak.tar.bz2 --strip-components=1 -C /usr/local/bin/teamspeak3 && \
    rm teamspeak.tar.bz2

RUN apt-get remove -y wget bzip2
RUN rm -rf /var/lib/apt/lists/*

ADD entrypoint.sh /

RUN chmod +x /entrypoint.sh

RUN mkdir /data

ENV UID 0
ENV GID 0

ENTRYPOINT ["/entrypoint.sh"]

#    apk --no-cache add ca-certificates && \
#    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub && \
#    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-2.25-r0.apk && \
#    apk add glibc-2.25-r0.apk && \

#echo -e "GET /downloads.html HTTP/1.1\r\nHost: www.teamspeak.com\r\n\r\n" | nc -i 3 www.teamspeak.com 80 | grep '^\s*<a.*teamspeak3-server_linux_amd64.*\.tar\.bz2' | grep -o 'http://.*\.tar\.bz2'

