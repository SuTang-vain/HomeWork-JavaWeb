# JavaWeb HomeWork

## 项目说明

本项目是 JavaWeb 课程作业，包含 JSP、Servlet、JDBC、JavaBean 等技术实践。

## 项目结构

| 目录 | 说明 |
|------|------|
| `Design/` | Tomcat + MySQL Docker 环境 |
| `JavaBean/` | JavaBean 示例代码 |
| `JDBC/` | JDBC 数据库操作示例 |
| `Jsp/` | JSP 练习项目（原 jsp-workspace） |
| `Static/` | 静态页面练习（原 practice_01） |
| `Java_Web_zip/` | 归档的课程资料 |

## 文档

- [项目技术实现详解](./JavaWeb项目技术实现详解.md)
- [Jsp Docker 开发使用指南](./Jsp/jsp-docker开发使用指南.md)

## Docker 环境

进入 `Design` 目录启动：

```bash
cd Design
docker-compose up -d
```

**服务端口：**
- Tomcat: http://localhost:8090
- MySQL: localhost:3306

**数据库配置：**
- Database: `user`
- Username: `user`
- Password: `password`
- Root Password: `root_password`
