# JSP Docker 开发环境使用指南

本指南将帮助您快速启动和使用此 JSP 开发环境。

## 1. 先决条件

在开始之前，请确保您的系统已经安装了 [Docker](https://www.docker.com/)。

## 2. 文件结构

-   `Dockerfile`: 定义了您的 JSP 开发环境。它使用 Tomcat 9 和 JRE 8，并将您的项目文件复制到 Tomcat 的 webapps 目录中。
-   `docker-compose.yml`: 用于管理您的 Docker 容器。它定义了服务、端口和数据卷。
-   `index.jsp`: 项目的默认主页。
-   `test/`: 包含测试页面的目录。

## 3. 如何启动开发环境

在项目的根目录下，打开您的终端并运行以下命令：

```bash
docker compose up --build
```

这个命令会：
1.  根据 `Dockerfile` 构建一个 Docker 镜像。
2.  在后台启动一个容器。
3.  将您本机的 8080 端口映射到容器的 8080 端口。
4.  将您当前目录挂载到容器的 webapps/ROOT 目录。

## 4. 如何访问您的应用

启动容器后，您可以在浏览器中通过以下地址访问您的应用：

-   **主页**: [http://localhost:8080](http://localhost:8080)
-   **测试页**: [http://localhost:8080/test/test.jsp](http://localhost:8080/test/test.jsp)

## 5. 如何停止开发环境

要停止容器，您可以在启动容器的终端中按下 `Ctrl + C`，或者在项目根目录下打开一个新的终端并运行以下命令：

```bash
docker compose down
```

## 6. 开发流程

由于我们将您的项目目录挂载到了容器中，您在本地对 `.jsp` 或其他 web 文件的任何修改都会立即反映在运行的容器中。

您只需修改代码并保存，然后刷新浏览器即可看到更改，无需重新构建或重启容器。
