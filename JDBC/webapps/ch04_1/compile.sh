#!/bin/bash

# 编译脚本

echo "=== JDBC项目编译 ==="

# 检查MySQL JDBC驱动是否存在
MYSQL_JDBC="mysql-connector-java-8.0.33.jar"

if [ ! -f "$MYSQL_JDBC" ]; then
    echo "警告: 未找到MySQL JDBC驱动文件 '$MYSQL_JDBC'"
    echo "请确保MySQL JDBC驱动在当前目录下，或修改CLASSPATH路径"
    echo ""
    echo "下载MySQL JDBC驱动:"
    echo "https://dev.mysql.com/downloads/connector/j/"
fi

# 编译Java文件
echo "正在编译InsertRecord.java..."
javac -cp ".:$MYSQL_JDBC" InsertRecord.java

if [ $? -eq 0 ]; then
    echo "✓ 编译成功！"
    echo ""
    echo "运行命令:"
    echo "java -cp ".:$MYSQL_JDBC" InsertRecord"
else
    echo "✗ 编译失败！"
    exit 1
fi
