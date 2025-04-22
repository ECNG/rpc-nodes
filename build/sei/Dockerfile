FROM debian:bookworm

ARG VERSION

RUN apt-get update && apt-get install -y unzip git build-essential sudo dnsutils debconf apt-utils tzdata ca-certificates curl jq bash wget liblz4-tool aria2 expect supervisor

RUN cd /opt/ && wget https://dl.google.com/go/go1.22.0.linux-amd64.tar.gz && tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz \
        && export PATH=$PATH:/usr/local/go/bin


WORKDIR /opt/node

RUN wget -nd -m https://github.com/sei-protocol/sei-chain/releases/download/$VERSION/seid-$VERSION-linux-amd64 && mv seid-$VERSION-linux-amd64 seid

ENTRYPOINT ["/opt/node/seid"]

