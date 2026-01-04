#!/bin/bash

# 运行脚本

echo "=== 运行JDBC程序 ==="

# MySQL JDBC驱动文件
MYSQL_JDBC="mysql-connector-java-8.0.33.jar"

# 检查驱动文件
if [ ! -f "$MYSQL_JDBC" ]; then
    echo "错误: 未找到MySQL JDBC驱动文件 '$MYSQL_JDBC'"
    echo "请将MySQL JDBC驱动放在当前目录下"
    exit 1
fi

# 检查.class文件是否存在
if [ ! -f "InsertRecord.class" ]; then
    echo "错误: 未找到InsertRecord.class文件，请先编译"
    exit 1
fi

echo "正在运行InsertRecord..."
echo ""
java -cp ".:$MYSQL_JDBC" InsertRecord
