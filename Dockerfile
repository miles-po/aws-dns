FROM alpine:3.6

LABEL maintainer "Miles Elam <miles.elam@productops.com>"

RUN apk update && \
    apk add unbound

COPY unbound.conf /etc/unbound

RUN unbound-checkconf

CMD unbound -d

