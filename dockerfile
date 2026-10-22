FROM alpine:latest
LABEL maintainer="jonnyan404"

# 版本号必填，形如 v2026.10.22，对应 Release 的 tag
ARG VERSION
# 由 buildx 自动注入，用来挑选对应架构的产物
ARG TARGETARCH
ARG TARGETVARIANT

# 注意大小写：tzdata 里的文件名是 Asia/Shanghai，
# 写成小写 shanghai 时 musl 找不到该区，容器会静默回落 UTC（差 8 小时）。
ENV TZ=Asia/Shanghai
WORKDIR /app

RUN apk add --no-cache tzdata ca-certificates

# 从 Release 下载对应架构的二进制，并用 checksums.txt 校验 SHA256
RUN set -eux; \
    if [ -z "${VERSION}" ]; then \
        echo "错误：必须通过 --build-arg VERSION=vYYYY.MM.DD 指定版本" >&2; \
        exit 1; \
    fi; \
    case "${TARGETARCH}${TARGETVARIANT}" in \
        amd64) ASSET="nav-file-hub-linux-amd64" ;; \
        arm64) ASSET="nav-file-hub-linux-arm64" ;; \
        armv7) ASSET="nav-file-hub-linux-armv7" ;; \
        *) echo "不支持的平台：${TARGETARCH}${TARGETVARIANT}" >&2; exit 1 ;; \
    esac; \
    BASE="https://github.com/Jonnyan404/nav-file-hub/releases/download/${VERSION}"; \
    echo "下载 ${ASSET} (${VERSION})"; \
    wget -q -O "/tmp/${ASSET}" "${BASE}/${ASSET}"; \
    wget -q -O /tmp/checksums.txt "${BASE}/checksums.txt"; \
    EXPECTED="$(grep -F " ${ASSET}" /tmp/checksums.txt | awk '{print $1}')"; \
    ACTUAL="$(sha256sum "/tmp/${ASSET}" | awk '{print $1}')"; \
    if [ -z "${EXPECTED}" ] || [ "${EXPECTED}" != "${ACTUAL}" ]; then \
        echo "SHA256 校验失败：期望 ${EXPECTED}，实际 ${ACTUAL}" >&2; \
        exit 1; \
    fi; \
    mv "/tmp/${ASSET}" /app/nav-file-hub; \
    chmod +x /app/nav-file-hub; \
    rm -f /tmp/checksums.txt

RUN mkdir -p /app/config

CMD ["./nav-file-hub", "-config", "/app/config/config.yaml"]
