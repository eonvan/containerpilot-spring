from mq:latest

RUN export DEBIAN_FRONTEND=noninteractive \
  # Install additional packages required by containerpilot, this install process and the runtime scripts
  && apt-get update -y \
  && apt-get install -y --no-install-recommends \
    curl zip unzip

# Install Consul
# Releases at https://releases.hashicorp.com/consul
RUN set -ex \
    && export CONSUL_VERSION=1.0.2 \
    && export CONSUL_CHECKSUM=418329f0f4fc3f18ef08674537b576e57df3f3026f258794b4b4b611beae6c9b \
    && curl --retry 7 --fail -vo /tmp/consul.zip "https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip" \
    && echo "${CONSUL_CHECKSUM}  /tmp/consul.zip" | sha256sum -c \
    && unzip /tmp/consul -d /usr/local/bin \
    && rm /tmp/consul.zip \
    # Create empty directories for Consul config and data \
    && mkdir -p /etc/consul \
    && mkdir -p /var/lib/consul \
    && mkdir /config

# Add Containerpilot and set its configuration
COPY etc/containerpilot.json5 /etc
ENV CONTAINERPILOT /etc/containerpilot.json5
ENV CONTAINERPILOT_VERSION 3.6.2

RUN export CONTAINERPILOT_CHECKSUM=b799efda15b26d3bbf8fd745143a9f4c4df74da9 \
    && export archive=containerpilot-${CONTAINERPILOT_VERSION}.tar.gz \
    && curl -Lso /tmp/${archive} \
         "https://github.com/joyent/containerpilot/releases/download/${CONTAINERPILOT_VERSION}/${archive}" \
    && echo "${CONTAINERPILOT_CHECKSUM}  /tmp/${archive}" | sha1sum -c \
    && tar zxf /tmp/${archive} -C /usr/local/bin \
    && rm /tmp/${archive}

# configuration files and bootstrap scripts
COPY etc/containerpilot.json5 etc/
COPY etc/consul.hcl etc/consul/
COPY bin/* /usr/local/bin/

# Put Consul data on a separate volume to avoid filesystem performance issues
# with Docker image layers. Not necessary on Triton, but...
VOLUME ["/data"]

COPY etc/qconfig.mqsc /etc/mqm/qconfig.mqsc
RUN chmod 755 /etc/mqm/qconfig.mqsc

RUN cat /etc/mqm/qconfig.mqsc >> /etc/mqm/config.mqsc

RUN chmod 755 /usr/local/bin/sensor.sh

EXPOSE 1414 9443
ENTRYPOINT []
CMD ["/usr/local/bin/containerpilot"]