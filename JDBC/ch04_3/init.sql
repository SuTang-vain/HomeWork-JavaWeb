CREATE DATABASE IF NOT EXISTS testdb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE testdb;

DROP TABLE IF EXISTS stu_info;
CREATE TABLE stu_info (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    gender VARCHAR(10),
    age INT,
    department VARCHAR(50),
    address VARCHAR(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO stu_info (name, gender, age, department, address) VALUES
('张三', '男', 20, '计算机科学', '北京市海淀区'),
('李四', '女', 21, '软件工程', '上海市浦东新区'),
('王五', '男', 19, '信息安全', '广州市天河区'),
('赵六', '女', 22, '网络工程', '深圳市南山区'),
('钱七', '男', 20, '计算机科学', '杭州市西湖区');
