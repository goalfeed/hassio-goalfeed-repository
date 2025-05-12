ARG BUILD_FROM
# hadolint ignore=DL3006
FROM $BUILD_FROM

# Set the version of the goalfeed binary you want to fetch
ARG GOALFEED_VERSION=v1.0.25


RUN ARCH=$(uname -m) && \
    FILE_VERSION=${GOALFEED_VERSION#v} && \
    case "${ARCH}" in \
    armv6l)    BINARY_ARCH="armv6" ;; \
    armv7l)    BINARY_ARCH="armv7" ;; \
    aarch64)   BINARY_ARCH="arm64" ;; \
    x86_64)    BINARY_ARCH="amd64" ;; \
    i686)      BINARY_ARCH="386" ;; \
    *)         BINARY_ARCH=$ARCH ;; \
    esac && \
    echo https://github.com/goalfeed/goalfeed/releases/download/${GOALFEED_VERSION}/goalfeed_${FILE_VERSION}_linux_${BINARY_ARCH}.tar.gz && \
    wget -O /tmp/goalfeed.tar.gz https://github.com/goalfeed/goalfeed/releases/download/${GOALFEED_VERSION}/goalfeed_${FILE_VERSION}_linux_${BINARY_ARCH}.tar.gz && \
    tar -xzf /tmp/goalfeed.tar.gz -C / && \
    rm /tmp/goalfeed.tar.gz && \
    chmod +x ./goalfeed

COPY run.sh /
RUN chmod a+x /run.sh
CMD ["./run.sh"]