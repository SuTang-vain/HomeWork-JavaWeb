-- 数据库初始化脚本
-- 创建数据库（如果不存在）
CREATE DATABASE IF NOT EXISTS testdb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE testdb;

-- 创建person表
DROP TABLE IF EXISTS person;

CREATE TABLE person (
    id INT PRIMARY KEY COMMENT '序号',
    name VARCHAR(50) NOT NULL COMMENT '姓名',
    gender VARCHAR(10) NOT NULL COMMENT '性别',
    age INT COMMENT '年龄',
    weight DOUBLE COMMENT '体重',
    height DOUBLE COMMENT '身高'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='人员信息表';

-- 查看表结构
DESCRIBE person;
