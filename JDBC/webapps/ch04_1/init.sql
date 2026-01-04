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

-- 创建学生信息表
DROP TABLE IF EXISTS stu_info;
CREATE TABLE stu_info (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    gender VARCHAR(10),
    age INT,
    department VARCHAR(50),
    address VARCHAR(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 插入测试数据
INSERT INTO stu_info (name, gender, age, department, address) VALUES
('张三', '男', 20, '计算机科学', '北京市海淀区'),
('李四', '女', 21, '软件工程', '上海市浦东新区'),
('王五', '男', 19, '信息安全', '广州市天河区'),
('赵六', '女', 22, '网络工程', '深圳市南山区'),
('钱七', '男', 20, '计算机科学', '杭州市西湖区');
