FROM ubuntu:22.04

ARG AXELARD_VERSION
ARG TOFND_VERSION
ARG LIBWASM_VERSION

RUN apt update
RUN apt install -y tzdata ca-certificates curl jq bash wget liblz4-tool aria2 expect supervisor

COPY vald-start.sh /opt/scripts/vald-start.sh
COPY install.sh /opt/scripts/
COPY run_node.sh /opt/scripts/
RUN chmod a+x /opt/scripts/*.sh
RUN /opt/scripts/install.sh

CMD [ "/opt/scripts/run_node.sh"]