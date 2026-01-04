FROM tomcat:9-jdk11-openjdk

# 安装MySQL客户端（可选，用于测试连接）
RUN apt-get update && apt-get install -y default-mysql-client && rm -rf /var/lib/apt/lists/*

# 复制MySQL JDBC驱动到Tomcat的lib目录
# 注意：需要手动下载mysql-connector-java-8.0.33.jar并放在Dockerfile同级目录
# COPY mysql-connector-java-8.0.33.jar /usr/local/tomcat/lib/

EXPOSE 8080
