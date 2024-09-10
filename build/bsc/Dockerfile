FROM debian:bullseye

ARG VERSION

#Required variables set by default
#ENV KEY="haqq_impulse"

RUN apt-get update && apt-get install -y unzip git build-essential sudo dnsutils debconf apt-utils tzdata ca-certificates curl jq bash wget liblz4-tool aria2 expect supervisor

RUN cd /opt/ && wget https://dl.google.com/go/go1.19.2.linux-amd64.tar.gz && tar -C /usr/local -xzf go1.19.2.linux-amd64.tar.gz \
        && export PATH=$PATH:/usr/local/go/bin

#ENV GOROOT /usr/lib/go
ENV GOPATH /usr/local/go/bin
ENV GO111MODULE on
ENV PATH /usr/local/go/bin:$PATH

WORKDIR /opt

RUN mkdir /opt/bsc/ && cd /opt/bsc && wget -c https://github.com/bnb-chain/bsc/releases/download/$VERSION/geth_linux && mv geth_linux geth && chmod +x /opt/bsc/geth

COPY run_node.sh /
RUN chmod a+x /run_node.sh

RUN apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

CMD ["/run_node.sh"]