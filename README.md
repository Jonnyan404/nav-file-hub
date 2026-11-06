# Nav-File-Hub

把任意目录变成网页：导航首页、文件浏览、图床、Markdown 阅读站，一个二进制搞定。跨 Windows / macOS / Linux，无需数据库、无需运行时。

- 🧭 **导航首页** —— 搜索框 + 置顶区，把常用站点收在一页，改配置自动刷新
- 📂 **文件浏览器** —— 列目录、上传、下载、重命名、删除；文件夹可一键打包成 zip
- 🖼 **图床模式** —— 目录变图墙，图片走直链，上传接口能接 PicGo / ShareX
- 🔒 **按路由设密码** —— 一条路由一个密码，互不影响
- 🗑 **回收站** —— 删除先进回收站，按原路径恢复
- 📝 **Markdown 站点** —— 目录里的 `.md` 直接渲染成阅读站
- 🖥 **托盘常驻** —— 双击就跑，点托盘图标打开浏览器，还能切换首页显示哪一页

**新手** → [3 分钟上手](#3-分钟上手) ｜ **查字段** → [配置手册](#配置手册) ｜ **接上传工具** → [接入第三方上传工具](#接入第三方上传工具)

<details>
<summary>点开看界面截图</summary>

![主页预览](demo1.png)

![文件浏览器预览](demo2.png)

![MD渲染器预览](demo3.png)

</details>

## 3 分钟上手

### 第 1 步 · 跑起来

到 [Releases](https://github.com/Jonnyan404/nav-file-hub/releases) 下载对应平台的包，双击运行（Linux / macOS 先 `chmod +x`）。

```bash
chmod +x nav-file-hub-darwin-arm64
./nav-file-hub-darwin-arm64
```

启动后它待在系统托盘 / 菜单栏，不弹窗、不占终端。

> macOS 首次打开会被 Gatekeeper 拦一下，[这里](#macos)有放行方法。

### 第 2 步 · 打开页面

浏览器访问 **`http://localhost:10000`**，或点托盘菜单里的「打开随身导航」。

### 第 3 步 · 分享你的第一个目录

**最省事**：一条命令，把某个目录直接变成网页（不写配置）：

```bash
./nav-file-hub -root ~/Documents -port 8080
# 打开 http://localhost:8080
```

**想长期用**：编辑 `config.yaml`，加一个站点（4 行）：

```yaml
port: 10000

sites:
  - name: 我的文档
    url: '/Users/you/Documents/*'   # Windows 写 'D:\Documents\*'，注意单引号
    router: "docs"                   # 访问地址变成 /docs/
    rule: "r"                        # 只读
```

保存后自动生效（配置热重载，不用重启），访问 http://localhost:10000/docs/ 就能看到文件了。

> 配置文件在哪？优先读当前目录的 `config.yaml`；没有的话读用户配置目录（macOS 是 `~/Library/Application Support/NavFileHub/config.yaml`）。
>
> 一个都没有也能跑 —— 会退化成「当前目录的只读文件浏览器」。

### 接下来常做的五件事

| 想做的事 | 怎么做 |
| --- | --- |
| 首页加一张外链卡片 | 站点只写 `name` + `url`，**不写 `router`** |
| 自己也能上传 / 改名 / 删除 | `rule: "rwd"`（r 读、w 写、d 删） |
| 给这个目录加密码 | 加一段 `protected_routes`，见下 |
| 变成图床（看图 + 直链） | 站点加 `mode: "gallery"` |
| 手机上看电脑里的文件 | 文件列表里点右侧 `QR` 按钮，扫码 |

加密码（`router` 要和站点里的对上）：

```yaml
protected_routes:
  - router: "docs"
    pwd: "1234"
```

变图床：

```yaml
sites:
  - name: 我的图床
    url: '/Users/you/Pictures/*'
    router: "img"
    rule: "rwd"
    mode: "gallery"     # 加上这一行
```

## 先认识三个词

配置里 90% 的内容就是这三个字段，理解了就不会配错：

| 字段 | 回答的问题 | 例子 |
| --- | --- | --- |
| `url` | 文件从哪来？ | `'/data/*'`、`'D:\test\*'`、`https://github.com/you` |
| `router` | 挂在哪个网址下？ | `"docs"` → 访问 `/docs/`；**留空 = 只在首页当卡片** |
| `rule` | 谁能干什么？ | `r` 读、`w` 写、`d` 删，可组合成 `"rwd"` |

连起来读就是一句话：**把 `url` 这个目录，挂到 `router` 这个网址下，给它 `rule` 权限。**

`url` 末尾的 `*` 是通配符：`/data/*` 是「目录下所有东西」，`/data/*.md` 是「只要 md 文件」，`/data/readme.md` 是「只要这一个文件」。

## 安装

### 选哪个包

| 平台 | 文件名 |
| --- | --- |
| Windows x86_64 | `nav-file-hub-windows-amd64.exe` |
| Windows ARM64 | `nav-file-hub-windows-arm64.exe` |
| macOS Apple Silicon | `nav-file-hub-darwin-arm64.dmg`（或裸二进制 `-arm64`） |
| macOS Intel | `nav-file-hub-darwin-amd64.dmg`（或裸二进制 `-amd64`） |
| Linux x86_64 | `nav-file-hub-linux-amd64` |
| Linux ARM64 | `nav-file-hub-linux-arm64` |
| Linux ARMv7（树莓派等） | `nav-file-hub-linux-armv7` |

### Windows

下载 `.exe` 双击即可，首次运行 Windows 可能提示「已保护你的电脑」，点「更多信息 → 仍要运行」。

### macOS

推荐 `.dmg`：打开后把 `NavFileHub` 拖进「应用程序」。

首次打开会被 Gatekeeper 拦（提示「无法验证开发者」），因为安装包没做代码签名。任选一种放行：

- 系统设置 → 隐私与安全性 → 找到 NavFileHub → 「仍要打开」；或
- 终端执行 `xattr -dr com.apple.quarantine /Applications/NavFileHub.app`

配置和日志分别在 `~/Library/Application Support/NavFileHub/` 和 `~/Library/Logs/NavFileHub/`。

### Linux

```bash
chmod +x nav-file-hub-linux-amd64
./nav-file-hub-linux-amd64
```

### Docker

```bash
docker run -d --name nav-file-hub -p 10000:10000 \
  -v /host/path/to/files:/data \
  -v /host/path/to/config:/app/config \
  jonnyan404/nav-file-hub:latest
```

容器里的配置文件是 `/app/config/config.yaml`，所以挂载的是**目录** `/app/config`。也可以用仓库自带的 `docker-compose.yml`。

镜像同时发布在 GHCR：`ghcr.io/jonnyan404/nav-file-hub:latest`。访问 `http://localhost:10000`。

### 校验下载（可选）

每个 Release 附带 `checksums.txt`，可执行 `sha256sum -c checksums.txt` 校验完整性。

## 命令行参数

不想写配置、只想临时分享一个目录时，这些参数就够了：

| 参数 | 说明 |
| --- | --- |
| `-config <路径>` | 指定配置文件；留空时依次尝试 `./config.yaml`、平台默认位置 |
| `-root <目录>` | 忽略配置文件，直接以文件浏览器提供这个目录（权限看 `-rule`，默认只读） |
| `-rule <权限>` | `-root` / 无配置兜底站点的权限：`r` 读、`w` 写、`d` 删，可组合成 `rwd`；留空表示只列名字 |
| `-mode <模式>` | `-root` / 兜底站点的呈现方式：留空是文件列表，`gallery` 是图床 |
| `-port <端口>` | 覆盖配置文件里的 `port` |
| `-host <地址>` | 监听地址，默认所有网卡；填 `127.0.0.1` 则只允许本机访问 |
| `-data-dir <目录>` | 配置、日志与状态文件的存放目录（容器里挂一个卷就够） |
| `-no-tray` | 前台运行，不启动托盘图标 |
| `-open` | 启动后自动打开浏览器 |
| `-version` | 打印版本号后退出 |

```bash
# 临时只读分享一个目录
nav-file-hub -root ~/Pictures -port 8080

# 同一个目录，允许上传和删除
nav-file-hub -root ~/Pictures -rule rwd -port 8080

# 直接把一个目录变成图床
nav-file-hub -root ~/Pictures/screenshots -rule rwd -mode gallery -port 8080
```

命令行给的值优先于配置文件，而且**不会**因为配置热重载被覆盖回去。

`-rule` / `-mode` 只作用于 `-root` 和「没有可用配置」时的兜底站点，不改配置文件里已有的站点。权限串写错会直接退出并说明原因——静默当成只读或全权限都比报错更危险。

## 配置手册

### 完整示例

```yaml
# 浏览器标题（可选）
title: 我的导航

port: 10000

# 回收站保留天数：到期自动清理；不写或 0 表示永久保留
trash_retention_days: 30

# 文件夹打包下载总开关（默认开启），站点里可单独覆盖
folder_download: true

protected_routes:
  - router: "app"
    pwd: "123"                 # 主密码
    pwds:                      # 额外密码，任意一个都能进
      - "guest-2026"
  - router: "/"                # 保护整个首页
    pwd: ""

sites:
  # 本地目录：可读可写可删
  - name: docker文件列表
    url: '/data/*'
    router: "docker"
    rule: "rwd"
    hidden:                    # 只从列表里隐藏，直接访问 /docker/tmp 仍能进
      - tmp
      - "*.bak"

  # 配置文件在线编辑
  - name: 配置
    url: config.yaml
    router: "config"

  # 只渲染 md 文件的阅读站
  - name: 笔记
    url: '/data/notes/*.md'
    router: "md"

  # 外链卡片：不写 router，就只在首页出现
  - name: GitHub
    url: https://github.com/jonnyan404
    pin: true                  # 置顶

  # 图床
  - name: 图片
    url: '/data/img/*'
    router: "img"
    rule: "rwd"
    mode: "gallery"

  # 只在 /internal 下出现的站点
  - name: 内部工具
    url: http://192.168.1.100/tools
    router: "internal"

  # Windows 路径必须加单引号
  - name: 仅展示docx
    url: 'D:\test\*.docx'
    router: "doc"
    rule: "rwd"
```

### 字段速查

**顶层**

| 字段 | 类型 | 默认 | 说明 |
| --- | --- | --- | --- |
| `title` | string | 空 | 浏览器标题 / 首页标题 |
| `port` | int | `10000` | 监听端口，改完要重启 |
| `trash_retention_days` | int | `0` | 回收站保留天数，`0` = 永久 |
| `folder_download` | bool | `true` | 是否允许把文件夹打包成 zip 下载 |

**`sites[]`**

| 字段 | 类型 | 默认 | 说明 |
| --- | --- | --- | --- |
| `name` | string | 必填 | 显示名称 |
| `url` | string | 必填 | 本地目录 / 单个文件 / 外链，支持 `*` 通配符 |
| `router` | string | 空 | 挂载的网址；**留空 = 只当首页卡片**，`"/"` = 根路径 |
| `rule` | string | `r` | 权限：`r` 读、`w` 写、`d` 删；留空 = 只显示名字，点不进去 |
| `mode` | string | 空 | 空 = 文件列表，`gallery` = 图床 |
| `pin` | bool | `false` | 首页置顶（**只对 `router` 为空的站点有效**） |
| `hide` | bool | `false` | 首页不显示（**只对 `router` 为空的站点有效**） |
| `hidden` | list | 空 | 站点内要隐藏的目录/文件，见 [按目录隐藏](#按目录隐藏) |
| `folder_download` | bool | 继承顶层 | 单独关掉这个站点的打包下载 |

**`protected_routes[]`**

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| `router` | string | 要保护的路由，`"/"` 表示首页 |
| `pwd` | string | 主密码；留空 = 这条路由不校验 |
| `pwds` | list | 额外密码，任意一个都能进 |

### 路由一览

| 地址 | 说明 |
| --- | --- |
| `/` | 首页，列出所有 `router` 为空的站点 |
| `/{router}/` | 站点的内容：文件列表 / 图床 / Markdown 阅读站 |
| `/{router}/trash` | 回收站（需要 `d` 权限） |
| `POST /{router}/upload` | 上传接口，加 `?format=json` 拿 JSON |
| `POST /{router}/delete` | 批量删除，JSON body：`{"paths":["a.png"]}` |

**在网页里编辑配置**：加一个站点，把 `url` 指向配置文件本身即可：

```yaml
sites:
  - name: 配置
    url: config.yaml
    router: "config"
```

之后访问 `/config/` 就是可视化编辑器：表单和 YAML 源码两个模式随时切换，保存后两边同步。

### 几个容易踩的点

- **`pin` / `hide` 对 `router` 非空的站点无效**：首页只列 `router` 为空的站点，配了也没地方生效。
- **本地目录站点一定要写 `router`**：不写 router 的站点只当首页卡片，而卡片的链接是由 router 生成的——本地路径没 router 时链接是空的，点了没反应。
- **`rule` 留空不是「只读」**：留空是「没有任何权限，只展示名字」，只读要写 `"r"`。
- **`url` 写目录还是文件**：写 `'/data/*'` 是目录站，写 `'/data/a.md'` 是单文件站，写 `https://...` 是外链卡片。
- **改 `port` 必须重启**，其它字段保存即生效。
- **配置改坏了**：每次在网页里保存配置都会把旧版本存成 `config.yaml.backup`，可以直接拿来覆盖回去。

## 导航页（首页）

访问 `/` 默认看到的就是导航页：搜索框 + 置顶区 + 所有站点卡片。它不读任何目录，只读配置里的 `sites`。

**只有 `router` 为空的站点会出现在这里**——这是理解配置的关键：

```yaml
sites:
  # 卡片：不写 router，点了直接跳走
  - name: GitHub
    url: https://github.com/jonnyan404
    pin: true          # 置顶到第一区

  # 页面：写了 router，有自己的地址 /docs/，不进首页
  - name: 文档
    url: '/data/docs/*'
    router: "docs"
```

| 字段 | 在首页上的效果 |
| --- | --- |
| `pin: true` | 置顶到第一区，和其余卡片之间有一条分割线（置顶的卡片不会在下面重复出现） |
| `hide: true` | 首页完全不显示，但 `/{router}/` 照样能访问 |

外链卡片点开是新标签页。

**搜索**是纯前端的：输入即过滤，按名字子串匹配，不发请求、不用回车。

**改完配置不用手动刷新**：首页每 5 分钟查一次版本号，发现配置变了会自己刷新。

### 用 router 做分组

几个外链站点共用同一个 `router`，访问 `/组名/` 就是一个只含它们的页面：

```yaml
sites:
  - name: 设计规范
    url: https://figma.com/xxx
    router: "design"
  - name: 素材库
    url: https://xxx.com/assets
    router: "design"
```

`/design/` 会列出这两张卡片。注意这个 router 下**不能有本地目录站点**——否则 `/design/` 会变成那个目录的文件浏览器，分组页就不出现了。

### 把首页换成文件浏览器 / 图床 / 阅读站

如果你每天来就是为了看文件，不必每次都点卡片：**托盘菜单 → 首页显示**，可以选

```
导航首页 ｜ 文件浏览器 · docs ｜ 图床 · img ｜ 阅读站 · md
```

选完 `/` 会 302 跳到对应页面，选择记在配置目录的 `home-mode` 文件里，重启仍然生效。没配置的类型会置灰。

## 文件浏览器

站点 `rule` 含 `r` 时，`/{router}/` 就是文件列表。三种看法：普通列表、**目录树**、**分栏预览**（不离开列表就能看内容，图片 / Markdown / 文本都支持）。

| 能做什么 | 说明 |
| --- | --- |
| 上传 | 点右上角「上传」，逐个上传并显示实时进度 |
| 下载 | 文件直接下；文件夹一键打成 zip，**边打包边发送**，大目录不用干等 |
| 重命名 / 删除 | 悬停行尾的图标；删除会先进回收站 |
| 二维码 | 每行的 `QR` 按钮，手机扫码直接下这个文件 |
| 筛选 | `/` 聚焦搜索框，`Esc` 取消选择，`↑↓` 在预览间切换 |

写权限由 `rule` 决定：`r` 只能看，`w` 才能上传和重命名，`d` 才能删除。

文件夹打包下载可以用 `folder_download` 全局关掉，也可以在单个站点里覆盖（见 [配置手册](#配置手册)）。

## 图床模式

站点加一行 `mode: "gallery"`，这个目录就变成图墙：

- 缩略图按修改时间倒序排列，点开看原图，支持网格 / 列表切换、按文件名筛选、按时间/名称/大小排序
- 图片走**直链**（`/img/photo.png` 直接返回原始字节），贴到别处就能用
- 上传支持拖拽、粘贴（⌘/Ctrl+V）、点「上传图片」
- 单选或多选后可一键复制直链 / Markdown / HTML（快捷键 `1` `2` `3`）
- 只收图片：按扩展名 + 内容嗅探双检，SVG / HTML 一律拒收

想接 PicGo、ShareX 这些外部工具，见 [接入第三方上传工具](#接入第三方上传工具)。

## 回收站

有删除权限（`rule` 含 `d`）的站点，文件列表右上角会出现「回收站」入口，也可以直接访问 `/router/trash`。

删除文件时不会真删，而是移进站点根目录下的 `.deleted/`：

```
.deleted/
  └── 20261030-133842.417368000-99c36548/
      ├── meta.json   # 原路径、删除时间、大小
      └── data        # 文件或目录本体
```

在回收站页面可以**恢复**（按原路径放回，父目录自动创建，原位置被占用时自动改名、不覆盖）、**彻底删除**、**清空**。

几点说明：

- `.deleted` 目录**不对外提供访问**（`/router/.deleted/` 直接 403），只能通过回收站页面操作
- 回收站条目仍占磁盘空间，建议配 `trash_retention_days` 或定期清空
- 旧版本留下的扁平条目（没有 `meta.json`）会标「旧格式」，恢复时放回站点根目录

## 按目录隐藏

想让某些目录只在列表里消失、但知道地址仍能访问（比如 `/dir/tmp`），有两种写法。

**方式一：站点配置 `hidden`**

```yaml
sites:
  - name: dir
    url: '/data/*'
    router: "dir"
    rule: "rwd"
    hidden:
      - tmp             # 隐藏任意层级的 tmp
      - docs/draft.md   # 只隐藏 docs/draft.md
      - "*.bak"         # 通配符
```

**方式二：目录里放 `.navignore`**（gitignore 风格，对该目录及子目录生效）

```
# /data/.navignore
tmp
*.log
docs/draft.md
```

匹配规则：

| 写法 | 含义 |
| --- | --- |
| `tmp` | 任意层级的 `tmp`（按文件名匹配） |
| `docs/draft.md` | 相对路径整段匹配，不会误伤 `x/docs/draft.md` |
| `/tmp` | 锚定在站点根（`.navignore` 里则是锚定在该目录） |
| `*.bak` | glob，`*` 不跨目录 |
| `# 注释` | 忽略 |

生效范围：文件列表、目录树、Markdown 站点列表、搜索。

> ⚠️ **隐藏不是权限**。路由层不做任何拦截，知道 `/dir/tmp` 的人照样进得去。真要挡人，给这个 router 配 `protected_routes` 密码，或把目录移出站点根。
>
> 另外，文件列表默认**不会**隐藏 `.env`、`.git` 这类点开头的文件（目录树会）。需要挡掉就用 `hidden` 或 `.navignore` 明确写。

## 同一目录，多个路由不同权限

想让同一个目录既能公开只读、又能自己写入，把站点条目复制一份、换 `router` 和 `rule` 就行：

```yaml
sites:
  - name: 共享只读
    url: '/data/*'
    router: "share"
    rule: "r"        # 只能看

  - name: 我的写入入口
    url: '/data/*'
    router: "mine"
    rule: "rwd"      # 可上传 / 重命名 / 删除
```

`/share/` 和 `/mine/` 指向同一个物理目录，权限各按自己那条 `rule` 生效。

几点说明：

- 回收站是**目录级**的（站点根下只有一个 `.deleted`），两条路由共用；但只有带 `d` 权限的路由能看到入口
- `hidden` / `.navignore` 按站点各自生效，两条路由可以显示不同条目
- 两条路由指向同一目录、`rule` 又完全相同时，启动会提醒「可能是复制粘贴忘了改」

## 接入第三方上传工具

图床模式自带一个能被外部工具直接调用的上传接口，不用装插件。

### 接口

```
POST /{router}/upload?format=json
```

- **文件字段名任意**：接口会遍历所有带文件名的 part，`file`、`image`、`files` 都能用
- `format=json`（或请求头 `Accept: application/json`）返回 JSON，否则 302 回列表页
- 返回体两种形状都有：`files[]` 给网页端，顶层扁平字段给第三方工具

```json
{
  "ok": true,
  "url": "http://host/img/photo.png",
  "markdown": "![photo.png](http://host/img/photo.png)",
  "html": "<img src=\"http://host/img/photo.png\" alt=\"photo.png\">",
  "name": "photo.png",
  "path": "photo.png",
  "files": [
    { "name": "photo.png", "url": "http://host/img/photo.png", "markdown": "…", "html": "…" }
  ]
}
```

> 为什么要有顶层 `url`：PicGo 的 `jsonPath` 是 `split('.')` 逐层取值，**不支持 `files[0]` 这种数组下标**，只有扁平字段才能用默认配置直接跑通。ShareX 两种都认。

### 鉴权

受 `protected_routes` 保护的路由，除了浏览器登录，还支持三种给脚本用的方式：

| 方式 | 写法 | 说明 |
| --- | --- | --- |
| 请求头（推荐） | `X-Auth-Pwd: 密码` | 不进 URL、不进日志 |
| Bearer | `Authorization: Bearer 密码` | 工具只有 Token 一栏时用这个 |
| 查询参数 | `?pwd=密码&format=json` | 方便，但密码会留在访问日志里 |

`?pwd=` 在 GET 上仍然会 302 去掉密码；POST 则**直接放行**（302 会把上传的请求体丢掉，等于「密码对了也传不上去」）。

### PicGo / PicList

装插件 `picgo-plugin-web-uploader`（图床列表里叫「自定义 Web 图床」），填四个值：

| 配置项 | 值 |
| --- | --- |
| API 地址 | `http://your-host/img/upload?format=json` |
| POST 参数名 | `file` |
| JSON 路径 | `url` |
| 自定义请求头 | `{"X-Auth-Pwd":"你的密码"}`（没设密码就留空） |

PicList 兼容 PicGo 插件，配置方式一样。

### ShareX

新建自定义上传器，或直接导入 `.sxcu`：

```json
{
  "Version": "15.0.0",
  "Name": "Nav-File-Hub",
  "DestinationType": "ImageUploader",
  "RequestMethod": "POST",
  "RequestURL": "http://your-host/img/upload?format=json",
  "Headers": { "X-Auth-Pwd": "你的密码" },
  "Body": "MultipartFormData",
  "FileFormName": "file",
  "URL": "{json:url}",
  "ErrorMessage": "{json:error}"
}
```

`{json:files[0].url}` 也能用（ShareX 走 JsonPath，支持数组下标）。

### uPic

自定义图床 → API 地址填 `http://your-host/img/upload?format=json`，请求方式 `POST`，文件字段名 `file`，URL 路径 `url`，自定义 Header 加一条 `X-Auth-Pwd: 你的密码`。

### 命令行

```bash
curl -H "X-Auth-Pwd: 你的密码" \
     -F "file=@photo.png" \
     "http://your-host/img/upload?format=json"
```

### 已知边界

- **只能传到站点根目录**：接口支持 `?path=子目录`，但多数客户端不会给每个请求拼参数。要分目录就多配几个站点
- **不做图片处理**：没有压缩、水印、缩略图，也不生成 `ThumbnailURL`。需要的话交给 PicList 这类客户端在上传前处理
- **不支持 WebDAV**：PicGo 的 WebDAV 上传器用不了，请用上面的自定义上传器
- **文件名保留原名**，重名自动加序号（`a.png` → `a (1).png`），不做随机重命名

## 常见问题

**打开 localhost:10000 没反应？** 端口被占了。换一个：`./nav-file-hub -port 8080`，或改配置里的 `port` 后重启。

**手机能访问吗？** 同一局域网下，用电脑的内网 IP 访问，例如 `http://192.168.1.5:10000`。想让外网访问，前面挂一层反向代理（程序认 `X-Forwarded-Proto`，HTTPS 下生成的直链才是 https）。

**改了配置要重启吗？** 不用，除了 `port`。

**密码忘了 / 配置写坏了怎么办？** 配置是纯文本，直接改文件。在网页里保存过的话，旧版本在 `config.yaml.backup`，可以覆盖回去。实在不行删掉 `config.yaml` 重启，会退化成「当前目录只读浏览」。

**`.env`、`.git` 为什么会出现在列表里？** 文件列表默认不隐藏点开头的文件（目录树会隐藏）。用 `hidden` 或 `.navignore` 明确挡掉。

**隐藏的目录别人能进吗？** 能。隐藏只是不在列表里显示，不是权限控制。要挡人请用 `protected_routes`。

**支持 HTTPS 吗？** 程序本身只监听 HTTP，证书交给前面的 Nginx / Caddy。

## 许可证

GPL-3.0，详见 [LICENSE](LICENSE)。

---

**享受使用 Nav-File-Hub，让文件管理更便捷！** 🎉
