FROM debian:bullseye

ARG VERSION

RUN apt-get update && apt-get install -y sudo dnsutils debconf apt-utils tzdata ca-certificates curl jq bash wget liblz4-tool aria2 expect supervisor

WORKDIR /opt/node

RUN wget -nd -m https://github.com/ava-labs/avalanchego/releases/download/$VERSION/avalanchego-linux-amd64-$VERSION.tar.gz && tar -xvf avalanchego-linux* && rm -rf *.tar.gz && mv avalanchego* avalanchego

#COPY run_node.sh /
#RUN chmod a+x /run_node.sh

ENTRYPOINT ["/opt/node/avalanchego/avalanchego"]
#CMD [ "/opt/node/avalanchego/avalanchego", "--http-host=0.0.0.0"]

