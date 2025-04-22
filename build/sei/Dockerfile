FROM debian:bookworm

ARG VERSION

RUN apt-get update && apt-get install -y unzip git build-essential sudo dnsutils debconf apt-utils tzdata ca-certificates curl jq bash wget liblz4-tool aria2 expect supervisor

WORKDIR /opt/node

RUN cd /opt/ && wget https://dl.google.com/go/go1.22.0.linux-amd64.tar.gz && tar -C /bin -xzf go1.22.0.linux-amd64.tar.gz \
        && export PATH=$PATH:/bin/go/bin \

#RUN wget -nd -m https://github.com/sei-protocol/sei-chain/releases/download/$VERSION/seid-$VERSION-linux-amd64 && mv seid-$VERSION-linux-amd64 seid
RUN git clone https://github.com/sei-protocol/sei-chain \
    && cd sei-chain \
    && git checkout $VERSION \
    && make install

#ENTRYPOINT ["/opt/node/seid"]

