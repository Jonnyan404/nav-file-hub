#!/bin/sh
# 容器入口：配置文件不存在时先写一份能直接用的默认配置。
#
# 为什么要在容器里生成，而不是塞进镜像：
#   - 用户把 /app/config 挂成卷时，卷是空的，镜像里带的配置会被挂载遮住；
#   - 直接跑 `docker run` 而不挂卷时，配置又需要落在一个可写位置。
# 所以「启动时按需生成」是唯一能同时覆盖两种情况的写法，也让用户第一次
# 启动就能看到可用的页面，而不是一个空目录 404。
set -eu

BIN="${NAV_BIN:-/app/nav-file-hub}"
CONFIG="${NAV_CONFIG:-/app/config/config.yaml}"

if [ ! -x "$BIN" ]; then
    echo "找不到可执行文件：$BIN" >&2
    exit 1
fi

if [ ! -f "$CONFIG" ]; then
    mkdir -p "$(dirname "$CONFIG")"

    # 先写临时文件再 mv：写一半失败时不会留下一个「存在但残缺」的配置，
    # 否则下次启动会以为配置已经就绪，直接带着坏配置跑。
    tmp="${CONFIG}.tmp.$$"
    if ! cat > "$tmp" <<'YAML'
# 首次启动自动生成的默认配置，可以直接改，也可以整个替换掉。
# 挂载约定：/data 放要共享的文件，/app/config 放这份配置。
title: Nav-File-Hub

port: 10000

# 想要子路径部署（例如反代到 example.com/nav/）时取消注释并填路径，
# 同时按 README 里 nginx / caddy 的示例配置反代，让前缀原样转发进来。
# prefix: /nav

protected_routes: []

sites:
  # 文件共享：可读、可上传；想允许删除把 rule 改成 "rwd"
  - name: 文件共享
    url: '/data/*'
    router: "files"
    rule: "rw"

  # 在线编辑这份配置（建议在上面 protected_routes 里给 config 加个密码）
  - name: 站点配置
    url: config.yaml
    router: "config"
YAML
    then
        echo "无法写入默认配置：$CONFIG（目录不可写？检查 -v ...:/app/config 的挂载权限）" >&2
        rm -f "$tmp"
        exit 1
    fi
    mv "$tmp" "$CONFIG"
    echo "未找到配置文件，已写入默认配置：$CONFIG"
    echo "挂载 /data 放要共享的文件；改完配置会自动热重载。"
fi

# NAV_PREFIX 只是给 compose / docker run -e 用的便捷写法；
# 显式命令行参数放在最后，同名参数以用户的为准。
if [ -n "${NAV_PREFIX:-}" ]; then
    exec "$BIN" -config "$CONFIG" -prefix "$NAV_PREFIX" "$@"
fi
exec "$BIN" -config "$CONFIG" "$@"
