ARG BUILD_FROM
FROM $BUILD_FROM

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG BUILD_ARCH=amd64
# Set the version of the goalfeed binary you want to fetch
ARG GOALFEED_VERSION=v0.0.12

RUN echo $BUILD_ARCH
# Map BUILD_ARCH to the corresponding binary name
RUN case "${BUILD_ARCH}" in \
    armhf)     ARCH="armv6" ;; \
    aarch64)   ARCH="arm64" ;; \
    i386)      ARCH="386" ;; \
    *)         ARCH="${BUILD_ARCH}" ;; \
    esac

RUN echo $ARCH

RUN curl -J -L -o /tmp/goalfeed.tar.gz https://github.com/goalfeed/goalfeed/releases/download/${GOALFEED_VERSION}/goalfeed_${GOALFEED_VERSION}_linux_${ARCH}.tar.gz && \
    tar -xzf /tmp/goalfeed.tar.gz -C / && \
    rm /tmp/goalfeed.tar.gz && \
    chmod +x /goalfeed

COPY run.sh /
RUN chmod a+x /run.sh

CMD ["./run.sh"]
