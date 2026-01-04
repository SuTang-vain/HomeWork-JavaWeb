CREATE DATABASE IF NOT EXISTS user;
USE user;

-- 用户表
CREATE TABLE IF NOT EXISTS user_b (
    username CHAR(10) NOT NULL,
    userpassword CHAR(10) NOT NULL
);

-- 学生信息表
CREATE TABLE IF NOT EXISTS students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    age INT NOT NULL,
    gender VARCHAR(10) NOT NULL,
    height DOUBLE NOT NULL,
    weight DOUBLE NOT NULL,
    bmi DOUBLE,
    health_status VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 测试用户
INSERT INTO user_b (username, userpassword) VALUES ('testuser', 'testpass');
INSERT INTO user_b (username, userpassword) VALUES ('zhangsan', '123456');

-- 测试学生数据
INSERT INTO students (name, age, gender, height, weight, bmi, health_status) VALUES
    ('张三', 20, '男', 175.0, 70.0, 22.86, '正常'),
    ('李四', 21, '女', 162.0, 55.0, 20.96, '正常'),
    ('王五', 19, '男', 180.0, 75.0, 23.15, '正常');
