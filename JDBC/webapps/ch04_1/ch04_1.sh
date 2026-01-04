#!/bin/bash

set -e

docker stop mysql-jdbc-test >/dev/null 2>&1 || true
docker rm mysql-jdbc-test >/dev/null 2>&1 || true

echo "=== 使用Docker运行JDBC测试 ==="

# 1. 启动MySQL容器,并设置默认编码
echo "1. 启动MySQL容器..."
docker run -d \
  --name mysql-jdbc-test \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD=123456 \
  -e MYSQL_DATABASE=testdb \
  mysql:8.0 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci

# 2. 等待MySQL启动
echo "2. 等待MySQL完全启动..."
for i in {1..20}; do
    if docker exec mysql-jdbc-test mysql -h 127.0.0.1 -u root -p123456 -e "SELECT 1" &> /dev/null; then
        echo "MySQL is ready!"
        break
    fi
    echo "Waiting for MySQL to be ready... (attempt $i)"
    sleep 3
done

if ! docker exec mysql-jdbc-test mysql -h 127.0.0.1 -u root -p123456 -e "SELECT 1" &> /dev/null; then
    echo "MySQL did not become ready in time. Aborting."
    docker logs mysql-jdbc-test
    exit 1
fi

# 3. 创建表 (显式指定字符集)
echo "3. 创建person表..."
docker exec mysql-jdbc-test mysql --default-character-set=utf8mb4 -h 127.0.0.1 -u root -p123456 testdb -e "
CREATE TABLE IF NOT EXISTS person (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    gender VARCHAR(10),
    age INT,
    weight DOUBLE,
    height DOUBLE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;"


# 4. 下载驱动
echo "4. 下载MySQL JDBC驱动..."
cd /home/sutang/01_yurii/02_project/JAVA_web/JDBC/ch04_1
JAR_NAME="mysql-connector-j-8.0.33.jar"
if [ ! -f "$JAR_NAME" ]; then
    curl -Lf -o "$JAR_NAME" "https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.0.33/$JAR_NAME"
    echo "Driver downloaded."
else
    echo "Driver already exists."
fi

# 5. 编译
echo "5. 编译Java程序..."
javac -cp ".:$JAR_NAME" InsertRecord.java

# 6. 运行
echo "6. 运行程序..."
java -cp ".:$JAR_NAME" InsertRecord

# 7. 验证 (使用正确的客户端字符集)
echo "7. 验证结果..."
docker exec mysql-jdbc-test mysql --default-character-set=utf8mb4 -h 127.0.0.1 -u root -p123456 testdb -e "SELECT * FROM person WHERE id = 16;"

echo "=== 测试完成 ==="
