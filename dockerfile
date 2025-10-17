FROM alpine:latest
LABEL maintainer="jonnyan404"

ARG TARGETPLATFORM
RUN mkdir -p dest

RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
        cp dist/nav-file-hub-linux-amd64 dest/nav-file-hub && chmod +x dest/nav-file-hub; \
    elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
        cp dist/nav-file-hub-linux-arm64 dest/nav-file-hub && chmod +x dest/nav-file-hub; \
    elif [ "$TARGETPLATFORM" = "linux/386" ]; then \
        cp dist/nav-file-hub-linux-386 dest/nav-file-hub && chmod +x dest/nav-file-hub; \
    else \
        echo "Unsupported platform: $TARGETPLATFORM" && exit 1; \
    fi

CMD ["./dest/nav-file-hub"]