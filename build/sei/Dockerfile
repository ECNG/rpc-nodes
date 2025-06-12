FROM golang:1.22.12 as builder

ARG VERSION

RUN apt-get update \
    && apt-get install -y gcc unzip sudo curl jq wget git make

WORKDIR /opt/node

RUN git clone --branch $VERSION --depth 1 https://github.com/sei-protocol/sei-chain \
    && cd sei-chain \
    && export PATH=$PATH:/bin/go/bin \
    && make install

RUN find / | grep -in libwasmvm

FROM debian:12

COPY --from=builder /go/bin/seid /bin/
COPY --from=builder /go/pkg/mod/github.com/sei-protocol/sei-wasmvm@v1.5.4-sei.0.0.3/internal/api/libwasmvm.x86_64.so /lib/

CMD ["/bin/seid"]

STOPSIGNAL SIGTERM