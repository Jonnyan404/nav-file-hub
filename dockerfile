FROM alpine:latest
LABEL maintainer="jonnyan404"

ARG TARGETPLATFORM
COPY dist/ /tmp/
WORKDIR /app

RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
        cp /tmp/nav-file-hub-linux-amd64 nav-file-hub && chmod +x nav-file-hub; \
    elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
        cp /tmp/nav-file-hub-linux-arm64 nav-file-hub && chmod +x nav-file-hub; \
    else \
        echo "Unsupported platform: $TARGETPLATFORM" && exit 1; \
    fi
RUN rm -rf /tmp/

CMD ["./nav-file-hub"]