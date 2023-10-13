# First stage: Build the Go binary
FROM golang:latest AS builder

WORKDIR /src

# Clone the Go repository and build the binary
RUN git clone https://github.com/goalfeed/goalfeed.git . && \
    GOOS=linux GOARCH=amd64 go build -o /goalfeed

# Second stage: Copy the built binary to the final image
ARG BUILD_FROM
FROM $BUILD_FROM

# Copy the Go binary from the builder stage and the run.sh script
COPY --from=builder /goalfeed /goalfeed
COPY run.sh /
RUN chmod a+x /run.sh

CMD ["./run.sh"]
