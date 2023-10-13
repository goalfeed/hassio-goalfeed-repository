ARG BUILD_FROM
FROM $BUILD_FROM

COPY --from=ghcr.io/goalfeed/goalfeed:main /goalfeed .
COPY run.sh /
RUN chmod a+x /run.sh
CMD ["./run.sh"]