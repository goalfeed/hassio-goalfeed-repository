ARG BUILD_FROM
ARG BUILD_ARCH

FROM $BUILD_FROM

# Set the version of the goalfeed binary you want to fetch
ARG GOALFEED_VERSION=v0.0.12

# Map BUILD_ARCH to the corresponding binary name
RUN case "${BUILD_ARCH}" in \
    armhf)     ARCH="armv6" ;; \
    armv7)     ARCH="armv7" ;; \
    aarch64)   ARCH="arm64" ;; \
    amd64)     ARCH="amd64" ;; \
    i386)      ARCH="386" ;; \
    *)         echo "Unsupported architecture ${BUILD_ARCH}"; exit 1 ;; \
    esac

# Download the appropriate binary for the target architecture
ADD https://github.com/goalfeed/goalfeed/releases/download/${GOALFEED_VERSION}/goalfeed_${GOALFEED_VERSION}_linux_${ARCH}.tar.gz /tmp/

# Extract the binary and give it execute permissions
RUN tar -xzf /tmp/goalfeed_${GOALFEED_VERSION}_linux_${ARCH}.tar.gz -C / && \
    rm /tmp/goalfeed_${GOALFEED_VERSION}_linux_${ARCH}.tar.gz && \
    chmod +x /goalfeed

COPY run.sh /
RUN chmod a+x /run.sh

CMD ["./run.sh"]
