FROM alpine:3.11

ARG VERSION=0.0.5

LABEL maintainer="zgist" \
        org.label-schema.name="Simple-obfs" \
        org.label-schema.version=$VERSION

RUN set -ex && \
    apk add --no-cache \
        --virtual .build-deps \
        autoconf \
        automake \
        build-base \
        curl \
        libev-dev \
        libtool \
        linux-headers \
        openssl-dev \
        pcre-dev \
        tar && \
    mkdir -p /tmp/obfs && \
    cd /tmp/obfs && \
    curl -sSL https://github.com/shadowsocks/simple-obfs/archive/486bebd.tar.gz | tar xz --strip 1 && \
    curl -sSL https://github.com/shadowsocks/libcork/archive/29d7cbafc4b983192baeb0c962ab1ff591418f56.tar.gz | tar xz --strip 1 -C libcork && \
    ./autogen.sh && \
    ./configure --prefix=/usr --disable-documentation && \
    make install && \
    runDeps="$( \
        scanelf --needed --nobanner /usr/bin/obfs-* \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
            | sort -u \
    )" && \
    apk add --no-cache --virtual .run-deps $runDeps && \
    apk del .build-deps && \
    cd / && rm -rf /tmp/*

EXPOSE $SERVER_PORT

RUN mv /usr/bin/obfs-server /usr/bin/tutas
RUN mv /usr/bin/obfs-local /usr/bin/tutal
