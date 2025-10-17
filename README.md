# Nav-File-Hub

一个轻量级、跨平台的个人文件浏览器和导航工具。支持站点导航、文件管理、二维码下载、密码保护路由，并集成系统托盘运行。

## ✨ 特性

- **文件浏览器**：浏览本地目录，支持文件上传、下载、删除、重命名。
- **通配符支持**：使用 `*` 或 `*.ext` 过滤文件类型（如 `*.docx`）。
- **二维码下载**：为文件生成二维码，方便移动设备下载。
- **密码保护**：为特定路由设置密码访问。
- **系统托盘**：后台运行，点击托盘图标打开浏览器。
- **嵌入资源**：静态文件、模板和图标全部嵌入，无需外部依赖。
- **实时配置**：YAML 配置自动重载，支持在线编辑。
- **跨平台**：支持 Windows、Linux、macOS。

## 🖼️ 预览

### 主页 - 随身导航
![主页预览](https://github.com/Jonnyan404/nav-file-hub/blob/main/demo1.png)

### 文件浏览器
![文件浏览器预览](https://github.com/Jonnyan404/nav-file-hub/blob/main/demo2.png)

## 🚀 安装

### 下载预构建版本
从 [dist](https://github.com/Jonnyan404/nav-file-hub/dist) 页面下载最新版本的 `nav-file-hub.exe`（Windows）或 nav-file-hub（Linux/Mac）

### 使用 Docker
1. 拉取镜像：
   ```bash
   docker pull jonnyan404/nav-file-hub:latest
   # 二选一
   docker pull ghcr.io/jonnyan404/nav-file-hub:latest
   ```

2. 运行容器（将 `/host/path/to/files` 替换为你的本地文件目录）：
   ```bash
   docker run -d --name nav-file-hub -p 10000:10000 \
     -v /host/path/to/files:/data \
     jonnyan404/nav-file-hub:latest
   # 二选一
   docker run -d --name nav-file-hub -p 10000:10000 \
     -v /host/path/to/files:/data \
     ghcr.io/jonnyan404/nav-file-hub:latest
   ```

3. 访问 `http://localhost:10000` 使用应用。


## 📖 使用

1. 运行 `nav-file-hub.exe`（或 nav-file-hub）。
2. 应用将在系统托盘中显示图标。
3. 点击托盘菜单中的“打开随身导航”以在浏览器中访问（默认 `http://localhost:10000`）。
4. 使用浏览器管理文件、配置站点等。

### 主要路由
- `/`：主页，显示所有站点。
- `/app/`：文件浏览器（示例路由）。
- `/doc/`：仅显示 `.docx` 文件（示例路由）。
- `/config/`：在线编辑配置文件。

## ⚙️ 配置

配置文件为 `config.yaml`，首次运行时自动生成默认配置。支持实时重载。

### 示例配置
```yaml
# 定义服务器监听的端口
port: 10000

# 定义需要密码保护的路由
protected_routes:
  - router: "app"
    pwd: "123"
  - router: "internal"
    pwd: "admin"
  - router: "/"
    pwd: ""
  - router: "config"
    pwd: "admin"

sites:
  - name: 文件列表功能
    url: 'D:\test\*'  # 目录通配符
    router: "app"
    rule: "rwd"  # 权限：r=读, w=写, d=删

  - name: 仅展示docx文件
    url: 'D:\test\*.docx'  # 文件通配符
    router: "doc"
    rule: "rwd"
```

### 配置说明
- **port**：服务器端口。
- **protected_routes**：密码保护路由，`pwd` 为空表示无需密码。
- **sites**：
  - `url`：本地路径，支持通配符（`*` 或 `*.ext`）。
  - `router`：路由名称。
  - `rule`：权限字符串（r=读, w=写, d=删）。
  - `pin`：置顶显示。
  - `hide`：隐藏站点。

## 📄 许可证

本项目采用 GPL-3.0 许可证。详见 LICENSE 文件。

---

**享受使用 Nav-File-Hub，让文件管理更便捷！** 🎉